import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screen.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

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
              "How Organ Donation Works",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            // 📝 DESCRIPTION
            Text(
              "Organ donation is a carefully managed medical process that begins with consent and ends with saving lives.\n\n"
                  "When a person agrees to donate, medical professionals evaluate the organs to ensure they are healthy and suitable for transplant.\n\n"
                  "Matching is done based on medical compatibility, urgency, and waiting list priority to ensure fairness and success.",
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
                  _pointCard("Step 1: Donor gives consent for organ donation"),
                  _pointCard("Step 2: Medical evaluation of organs and tissues"),
                  _pointCard("Step 3: Matching donor with suitable recipient"),
                  _pointCard("Step 4: Transplant surgery performed by specialists"),
                  _pointCard("Step 5: Post-surgery care and recovery monitoring"),
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
          decoration: const BoxDecoration(
            color: Color(0xFFF4F6F9),
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
                child: Center(
                  child: Text(
                    "Donate Now",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

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