import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String selectedFilter = "All";

  final List<Map<String, dynamic>> requests = [
    {
      "organ": "Heart",
      "patient": "Female, 21yr",
      "hospital": "AIIMS Hospital",
      "distance": "2.3 Km",
      "urgency": "Critical",
    },
    {
      "organ": "Kidney",
      "patient": "Male, 35yr",
      "hospital": "Apollo Hospital",
      "distance": "4.1 Km",
      "urgency": "Medium",
    },
    {
      "organ": "Liver",
      "patient": "Female, 42yr",
      "hospital": "Fortis Hospital",
      "distance": "6.0 Km",
      "urgency": "Critical",
    },
    {
      "organ": "Cornea",
      "patient": "Male, 19yr",
      "hospital": "City Eye Hospital",
      "distance": "3.5 Km",
      "urgency": "Stable",
    },
  ];

  final List<String> filters = ["All", "Heart", "Kidney", "Liver", "Cornea"];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      body: SafeArea(
        child: Column(
          children: [

            // 🔥 CLEAN HEADER (MATCHING YOUR APP STYLE)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Emergency Requests",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            // 🧭 TABS (CLEAN STYLE)
            TabBar(
              controller: _tabController,
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.black45,
              indicatorColor: Colors.lightGreen,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: "Nearby Requests"),
                Tab(text: "My Responses"),
              ],
            ),

            const SizedBox(height: 12),

            // 🎯 FILTER CHIPS (PILL STYLE)
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: filters.length,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final isSelected = selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.lightGreen,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      onSelected: (_) {
                        setState(() => selectedFilter = filter);
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // 📋 TAB CONTENT
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequestList(),
                  _buildMyResponses(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    final filtered = selectedFilter == "All"
        ? requests
        : requests.where((r) => r["organ"] == selectedFilter).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _requestCard(filtered[index]);
      },
    );
  }

  Widget _requestCard(Map<String, dynamic> req) {
    Color urgencyColor;
    if (req["urgency"] == "Critical") {
      urgencyColor = Colors.red;
    } else if (req["urgency"] == "Medium") {
      urgencyColor = Colors.orange;
    } else {
      urgencyColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
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

          // 🫀 TITLE + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${req["organ"]} Required",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: urgencyColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  req["urgency"],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: urgencyColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(req["patient"], style: GoogleFonts.poppins(fontSize: 13)),
          const SizedBox(height: 4),
          Text("🏥 ${req["hospital"]}",
              style: GoogleFonts.poppins(fontSize: 13)),
          const SizedBox(height: 4),
          Text("📍 ${req["distance"]}",
              style: GoogleFonts.poppins(fontSize: 13)),

          const SizedBox(height: 14),

          // 🔥 ACTION BUTTONS (PILL STYLE)
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("Donation Response Sent 💚"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Accept",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Decline",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyResponses() {
    return Center(
      child: Text(
        "No donation responses yet",
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black45,
        ),
      ),
    );
  }
}