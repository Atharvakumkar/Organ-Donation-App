import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'organ_registration_form.dart';

class OrganDonationScreen extends StatelessWidget {
  const OrganDonationScreen({super.key});

  final List<Map<String, dynamic>> organs = const [
    {"name": "Heart", "icon": FontAwesomeIcons.heart, "color": Colors.red},
    {"name": "Kidneys", "icon": FontAwesomeIcons.kitMedical, "color": Colors.purple},
    {"name": "Liver", "icon": FontAwesomeIcons.dna, "color": Colors.orange},
    {"name": "Lungs", "icon": FontAwesomeIcons.lungs, "color": Colors.blue},
    {"name": "Corneas", "icon": FontAwesomeIcons.eye, "color": Colors.teal},
    {"name": "Pancreas", "icon": FontAwesomeIcons.vial, "color": Colors.green},
    {"name": "Intestine", "icon": FontAwesomeIcons.bacteria, "color": Colors.brown},
    {"name": "Skin", "icon": FontAwesomeIcons.handHoldingMedical, "color": Colors.pink},
    {"name": "Bone", "icon": FontAwesomeIcons.bone, "color": Colors.indigo},
    {"name": "Eyes", "icon": FontAwesomeIcons.eyeDropper, "color": Colors.cyan},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔙 HEADER
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Organ Donation",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 💚 INFO CARD (REPLACES GRADIENT)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Donate Organs, Save Lives 💚",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Choose an organ and become a life saver.",
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🫀 SECTION TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Choose Organ",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 🔥 ORGAN LIST
            SizedBox(
              height: 190,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: organs.length,
                itemBuilder: (context, index) {
                  final organ = organs[index];
                  return _buildOrganCard(context, organ);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganCard(BuildContext context, Map<String, dynamic> organ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrganRegistrationForm(
              selectedOrgan: organ["name"],
            ),
          ),
        );
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ICON CONTAINER (MODERN TOUCH)
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: organ["color"].withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: FaIcon(
                  organ["icon"],
                  size: 26,
                  color: organ["color"],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              organ["name"],
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}