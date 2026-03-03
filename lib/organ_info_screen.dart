import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen.dart';

class OrganInfoScreen extends StatelessWidget {
  const OrganInfoScreen({super.key, required String type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "What is Organ Donation?",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 HEADER
            Text(
              "Educate Yourself",
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.lightGreen,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 6),

            // 🔥 TITLE
            Text(
              "What is Organ Donation?",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // 📝 DESCRIPTION
            Text(
              "Organ donation is the process of giving an organ or tissue to help someone who needs a transplant.\n\n "
                  "It is a life-saving medical procedure that allows healthy organs from one person to replace failing organs in another.\n\n"
                  "A single donor can save up to 8 lives and improve many more through tissue donation.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 20),

            // 📦 POINT CARDS
            Expanded(
              child: ListView(
                children: [
                  _pointCard("One donor can save up to 8 lives"),
                  _pointCard("Organs like heart, liver, kidneys can be donated"),
                  _pointCard("Tissues like cornea and skin can also be donated"),
                  _pointCard("Gives patients a second chance at life"),
                  _pointCard("A powerful act of humanity and kindness"),
                ],
              ),
            ),
          ],
        ),
      ),

      // 🔥 CTA BUTTON
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OrganDonationScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Donate Now",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 CARD DESIGN
  Widget _pointCard(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }
}