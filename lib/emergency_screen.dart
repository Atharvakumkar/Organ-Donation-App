import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:organ_donation_app/homeScreen.dart';
import 'emergency_loading_screen.dart';
import 'screen.dart';
import 'profilePage.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final TextEditingController locationController = TextEditingController();

  String? selectedOrgan;

  int _selectedIndex = 1; // Emergency selected

  final List<String> organs = [
    "Heart",
    "Kidneys",
    "Liver",
    "Lungs",
    "Corneas",
    "Pancreas",
    "Intestine",
    "Skin",
    "Bone",
    "Eyes",
  ];

  final List<Map<String, dynamic>> donors = [
    {
      "name": "Atharva Kumkar",
      "age": 19,
      "gender": "Male",
      "blood": "B+",
      "organ": "Heart",
      "location": "Mumbai",
      "phone": "7045727768"
    },
    {
      "name": "Sanjeev Singh",
      "age": 19,
      "gender": "Male",
      "blood": "A+",
      "organ": "Kidneys",
      "location": "Pune",
      "phone": "9301133636"
    },
    {
      "name": "Rutuja Awale",
      "age": 19,
      "gender": "Female",
      "blood": "O+",
      "organ": "Liver",
      "location": "Delhi",
      "phone": "7304625529"
    },
    {
      "name": "Raj Mohite",
      "age": 18,
      "gender": "Male",
      "blood": "AB+",
      "organ": "Heart",
      "location": "Mumbai",
      "phone": "7977194802"
    },
    {
      "name": "Naman Bhede",
      "age": 20,
      "gender": "Male",
      "blood": "A+",
      "organ": "Liver",
      "location": "Surat",
      "phone": "8928394348"
    },
    {
      "name": "Prasad Mahajan",
      "age": 19,
      "gender": "Male",
      "blood": "O+",
      "organ": "Lungs",
      "location": "Mumbai",
      "phone": "9137219867"
    },
  ];

  void _onNavTap(int index) {
    if (index == _selectedIndex) return;

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

  void _validateAndSearch() {
    final location = locationController.text.trim();

    if (location.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              "Location Required",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              "Please enter your location to search for donors.",
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "OK",
                  style: GoogleFonts.poppins(
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmergencyLoadingScreen(
          location: location,
          selectedOrgan: selectedOrgan,
          donors: donors,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Title
                Text(
                  "Emergency Organ Request",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen,
                  ),
                ),

                const SizedBox(height: 30),

                /// Location Field
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    hintText: "Enter Location",
                    prefixIcon: const Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                /// Organ Selection
                Text(
                  "Select Organ (Optional)",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: organs.map((organ) {
                    final isSelected = selectedOrgan == organ;

                    return ChoiceChip(
                      label: Text(
                        organ,
                        style: GoogleFonts.poppins(),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.lightGreen.shade100,
                      onSelected: (_) {
                        setState(() {
                          selectedOrgan =
                          isSelected ? null : organ;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                /// Search Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _validateAndSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      padding:
                      const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Search Donors",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// Bottom Navbar
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
          currentIndex: _selectedIndex,
          onTap: _onNavTap,
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