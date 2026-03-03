import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen.dart';

class ImpactOnSocietyPage extends StatelessWidget {
  const ImpactOnSocietyPage({super.key, required String type});

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
              "Impact on Society",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 📝 DESCRIPTION
            Text(
              "Organ donation creates a powerful ripple effect across society.\n\n"
                  "Beyond saving individual lives, it strengthens families, reduces healthcare burdens, and builds a culture of compassion and responsibility.\n\n"
                  "Every donor contributes to a healthier, more hopeful community.",
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
                  _pointCard("Reduces long-term medical treatment costs"),
                  _pointCard("Gives families renewed hope and stability"),
                  _pointCard("Improves overall public health outcomes"),
                  _pointCard("Encourages community awareness and compassion"),
                  _pointCard("Builds a culture of social responsibility"),
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