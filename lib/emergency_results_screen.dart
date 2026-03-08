import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyResultsScreen extends StatelessWidget {
  final String location;
  final String? selectedOrgan;

  const EmergencyResultsScreen({
    super.key,
    required this.location,
    this.selectedOrgan, required List<Map<String, dynamic>> donors,
  });

  Future<void> callDonor(String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));

    final Uri uri = Uri(
      scheme: 'tel',
      path: phone,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    String locationInput = location.toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F6F9),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Available Donors",
          style: GoogleFonts.poppins(
            color: Colors.lightGreen,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("organ_donors")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No donors found",
                  style: GoogleFonts.poppins(),
                ),
              );
            }

            final donors = snapshot.data!.docs.map((doc) {
              return doc.data() as Map<String, dynamic>;
            }).toList();

            final filteredDonors = donors.where((donor) {

              bool matchesLocation =
                  locationInput.isEmpty ||
                      donor["location"]
                          ?.toString()
                          .toLowerCase()
                          .contains(locationInput) ==
                          true;

              bool matchesOrgan =
                  selectedOrgan == null ||
                      donor["organ"] == selectedOrgan;

              return matchesLocation && matchesOrgan;

            }).toList();

            if (filteredDonors.isEmpty) {
              return Center(
                child: Text(
                  "No donors match your search",
                  style: GoogleFonts.poppins(),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredDonors.length,
              itemBuilder: (context, index) {

                final donor = filteredDonors[index];

                return Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ExpansionTile(
                      tilePadding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      collapsedIconColor: Colors.black54,
                      iconColor: Colors.lightGreen,
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,

                      title: Text(
                        donor["name"] ?? "Unknown",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      subtitle: Text(
                        "${donor["organ"] ?? ""} • ${donor["location"] ?? ""}",
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                "Age: ${donor["age"] ?? ""}",
                                style: GoogleFonts.poppins(),
                              ),

                              Text(
                                "Gender: ${donor["gender"] ?? ""}",
                                style: GoogleFonts.poppins(),
                              ),

                              Text(
                                "Blood Group: ${donor["bloodGroup"] ?? ""}",
                                style: GoogleFonts.poppins(),
                              ),

                              Text(
                                "Organ: ${donor["organ"] ?? ""}",
                                style: GoogleFonts.poppins(),
                              ),

                              Text(
                                "Location: ${donor["location"] ?? ""}",
                                style: GoogleFonts.poppins(),
                              ),

                              const SizedBox(height: 16),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      callDonor(donor["phone"]),
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.lightGreen,
                                  ),
                                  label: Text(
                                    "Call Donor",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.lightGreen,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      side: const BorderSide(
                                        color: Colors.lightGreen,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}