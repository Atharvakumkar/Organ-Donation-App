import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'article_detail_screen.dart';
import 'screen.dart';
import 'emergency_screen.dart';
import 'profilePage.dart';
import 'organ_info_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _selectedIndex = 0;

  static const List<Map<String, String>> newsList = [
    {
      "title": "India Reports Rise in Organ Transplant Success Rate",
      "desc": "Medical advancements are improving transplant survival rates.",
      "image": "assets/images/news1.png",
      "category": "Medical",
      "source": "Health News",
      "link": "https://www.notto.mohfw.gov.in/"
    },
    {
      "title": "One Organ Donor Can Save Up To 8 Lives",
      "desc": "Doctors emphasize the life-saving impact of organ donation.",
      "image": "assets/images/news2.png",
      "category": "Awareness",
      "source": "WHO",
      "link": "https://www.organdonor.gov/"
    },
    {
      "title": "AI Helping in Faster Organ Matching",
      "desc": "Artificial Intelligence is assisting doctors.",
      "image": "assets/images/news3.png",
      "category": "Innovation",
      "source": "Medical Tech",
      "link": "https://www.ncbi.nlm.nih.gov/"
    },
  ];

  void _onNavTap(int index) {
    setState(() => _selectedIndex = index);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmergencyScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
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
            children: [
              _buildHeader(),

              _buildRegisterDonorSection(context),

              const SizedBox(height: 10),

              _buildOrganInfoCarousel(context),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Latest Medical Articles",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  return _buildNewsCard(context, newsList[index]);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

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
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Emergency'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // 🔥 HEADER
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Hello User",
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // 🫀 DONOR BUTTONS
  Widget _buildRegisterDonorSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Register Yourself as a Donor",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      _showComingSoon(context, "Blood Donation"),
                  child: _bigDonorButton(
                    icon: Icons.bloodtype,
                    label: "Blood Donation",
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => OrganDonationScreen()),
                    );
                  },
                  child: _bigDonorButton(
                    icon: Icons.favorite,
                    label: "Organ Donation",
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bigDonorButton({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // 📚 CAROUSEL
  Widget _buildOrganInfoCarousel(BuildContext context) {
    final List<Map<String, String>> infoList = [
      {
        "title": "What is Organ Donation?",
        "subtitle": "Learn the basics of saving lives",
        "type": "what"
      },
      {
        "title": "How It Works",
        "subtitle": "Understand the donation process",
        "type": "how"
      },
      {
        "title": "Impact on Society",
        "subtitle": "See how lives are transformed",
        "type": "impact"
      },
      {
        "title": "Who Can Donate?",
        "subtitle": "Check eligibility & myths",
        "type": "who"
      },
    ];

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            itemCount: infoList.length,
            itemBuilder: (context, index) {
              final item = infoList[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          OrganInfoScreen(type: item["type"]!),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 3, right: 3),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.00),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                        const Icon(Icons.menu_book, color: Colors.green),
                      ),
                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item["title"]!,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["subtitle"]!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 DOT INDICATOR
        SmoothPageIndicator(
          controller: _pageController,
          count: infoList.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
            spacing: 6,
            dotColor: Colors.grey.shade400,
            activeDotColor: Colors.lightGreen,
          ),
        ),
      ],
    );
  }
  // 📰 NEWS
  Widget _buildNewsCard(BuildContext context, Map<String, String> news) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(news: news),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(28)),
              child: Image.asset(
                news["image"]!,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                news["title"]!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$title - Coming Soon")),
    );
  }
}