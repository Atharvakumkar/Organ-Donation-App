import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Map<String, String> news;

  const ArticleDetailScreen({super.key, required this.news});

  Future<void> _openArticleLink(BuildContext context) async {
    final link = news["link"];

    if (link == null || link.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Article link not available")),
      );
      return;
    }

    final Uri uri = Uri.parse(link);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open the article")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error opening article")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔙 BACK BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
              ),

              // 🖼️ IMAGE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    news["image"]!,
                    width: double.infinity,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // 🏷️ CATEGORY + SOURCE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.lightGreen.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Text(
                            news["category"]!,
                            style: GoogleFonts.poppins(
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          news["source"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // 📰 TITLE
                    Text(
                      news["title"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // 📖 DESCRIPTION
                    Text(
                      news["desc"]!,
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        color: Colors.black54,
                        height: 1.7,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // 💚 AWARENESS CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Why Organ Donation Matters 💚",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "A single donor can save up to 8 lives. Increasing awareness helps reduce the global organ shortage and gives patients a second chance at life.",
                            style: GoogleFonts.poppins(
                              fontSize: 13.5,
                              color: Colors.black54,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // 🔗 BUTTON (MATCH AUTH STYLE)
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: () => _openArticleLink(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        child: Text(
                          "Read Full Article",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ❤️ ACTION ROW
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(Icons.favorite_border, size: 26, color: Colors.black54),
                        Icon(Icons.bookmark_border, size: 26, color: Colors.black54),
                        Icon(Icons.share, size: 26, color: Colors.black54),
                      ],
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}