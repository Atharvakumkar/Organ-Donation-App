import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen.dart';

class WhoCanDonatePage extends StatelessWidget {
  const WhoCanDonatePage({super.key, required String type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.black),
        leadingWidth: 40,
        titleSpacing: 0,
        title: Text(
          "Educate Yourself",
          style: GoogleFonts.poppins(
            color: Colors.lightGreen,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TITLE
            Text(
              "Who Can Donate?",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 📝 DESCRIPTION
            Text(
              "Almost anyone can become an organ donor, regardless of age or background.\n\n"
                  "Medical professionals evaluate each donor individually to determine suitability at the time of donation.\n\n"
                  "What matters most is your willingness to give someone a second chance at life.",
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
                  _pointCard("People of all ages can register as donors"),
                  _pointCard("Medical condition is evaluated at the time of donation"),
                  _pointCard("Both living and deceased individuals can donate"),
                  _pointCard("Family consent plays an important role"),
                  _pointCard("Healthy organs and tissues are carefully matched to recipients"),
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
                color: Colors.black.withOpacity(0.00),
                blurRadius: 100,
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