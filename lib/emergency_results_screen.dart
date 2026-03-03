import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:organ_donation_app/homeScreen.dart';
import 'profilePage.dart';

class EmergencyResultsScreen extends StatelessWidget {
  final String location;
  final String? selectedOrgan;
  final List<Map<String, dynamic>> donors;

  const EmergencyResultsScreen({
    super.key,
    required this.location,
    required this.selectedOrgan,
    required this.donors,
  });

  // Case-insensitive filtering
  List<Map<String, dynamic>> getFilteredDonors() {
    String locationInput = location.toLowerCase();

    return donors.where((donor) {
      bool matchesLocation = locationInput.isEmpty ||
          donor["location"]
              .toString()
              .toLowerCase()
              .contains(locationInput);

      bool matchesOrgan =
          selectedOrgan == null ||
              donor["organ"] == selectedOrgan;

      return matchesLocation && matchesOrgan;
    }).toList();
  }

  Future<void> callDonor(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));

    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onNavTap(BuildContext context, int index) {
    if (index == 1) return; // Already on Emergency

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDonors = getFilteredDonors();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Available Donors",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: filteredDonors.isEmpty
            ? Center(
          child: Text(
            "No donors found",
            style: GoogleFonts.poppins(),
          ),
        )
            : ListView.builder(
          itemCount: filteredDonors.length,
          itemBuilder: (context, index) {
            final donor = filteredDonors[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ExpansionTile(
                title: Text(
                  donor["name"],
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  "${donor["organ"]} • ${donor["location"]}",
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text("Age: ${donor["age"]}"),
                        Text("Gender: ${donor["gender"]}"),
                        Text("Blood Group: ${donor["blood"]}"),
                        Text("Organ: ${donor["organ"]}"),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                callDonor(donor["phone"]),
                            icon: const Icon(Icons.call),
                            label: const Text("Call Donor"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),

      /// ✅ SAME BOTTOM NAVBAR
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 1, // Emergency selected
          onTap: (index) => _onNavTap(context, index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.lightGreen,
          unselectedItemColor: Colors.black45,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.warning), label: 'Emergency'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}