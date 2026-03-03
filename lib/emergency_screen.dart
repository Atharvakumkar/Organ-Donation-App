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
      "distance": 2.3,
      "urgency": "Critical",
    },
    {
      "organ": "Kidney",
      "patient": "Male, 35yr",
      "hospital": "Apollo Hospital",
      "distance": 8.1,
      "urgency": "Medium",
    },
    {
      "organ": "Liver",
      "patient": "Female, 42yr",
      "hospital": "Fortis Hospital",
      "distance": 5.0,
      "urgency": "Critical",
    },
    {
      "organ": "Cornea",
      "patient": "Male, 19yr",
      "hospital": "City Eye Hospital",
      "distance": 3.5,
      "urgency": "Stable",
    },
  ];

  final List<Map<String, dynamic>> myResponses = [];

  final List<String> filters = ["All", "Heart", "Kidney", "Liver", "Cornea"];

  bool gpsEnabled = true;
  double maxDistance = 5.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Emergency Requests",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            TabBar(
              controller: _tabController,
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.black45,
              indicatorColor: Colors.lightGreen,
              tabs: const [
                Tab(text: "Nearby Requests"),
                Tab(text: "My Responses"),
              ],
            ),

            const SizedBox(height: 10),

            SwitchListTile(
              title: Text("Nearby Only (GPS)",
                  style: GoogleFonts.poppins(fontSize: 13)),
              value: gpsEnabled,
              activeColor: Colors.lightGreen,
              onChanged: (val) {
                setState(() => gpsEnabled = val);
              },
            ),

            const SizedBox(height: 10),

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
    List<Map<String, dynamic>> filtered = List.from(requests);

    if (selectedFilter != "All") {
      filtered = filtered
          .where((r) => r["organ"] == selectedFilter)
          .toList();
    }

    if (gpsEnabled) {
      filtered = filtered
          .where((r) => (r["distance"] as num) <= maxDistance)
          .toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Text(
          "No nearby requests",
          style: GoogleFonts.poppins(color: Colors.black45),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _requestCard(filtered[index]);
      },
    );
  }

  Widget _requestCard(Map<String, dynamic> req) {
    bool alreadyAccepted = myResponses.any(
        (r) => r["hospital"].toString() == req["hospital"].toString());

    Color urgencyColor =
        req["urgency"] == "Critical"
            ? Colors.red
            : req["urgency"] == "Medium"
                ? Colors.orange
                : Colors.green;

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${req["organ"]} Required",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text(req["urgency"],
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: urgencyColor)),
            ],
          ),

          const SizedBox(height: 8),

          Text(req["patient"]),
          Text("🏥 ${req["hospital"]}"),
          Text("📍 ${req["distance"]} Km"),

          const SizedBox(height: 14),

          alreadyAccepted
              ? SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)),
                    ),
                    child: Text("Accepted",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600)),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              myResponses
                                  .add(Map<String, dynamic>.from(req));
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Accepted 💚")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(32)),
                          ),
                          child: Text("Accept",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Declined ❌")),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(32)),
                          ),
                          child: Text("Decline",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600)),
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
    if (myResponses.isEmpty) {
      return Center(
        child: Text("No donation responses yet",
            style: GoogleFonts.poppins(color: Colors.black45)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: myResponses.length,
      itemBuilder: (context, index) {
        final r = myResponses[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${r["organ"]} - ${r["hospital"]}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold)),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      myResponses.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Response Cancelled")),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text("Cancel",
                      style: GoogleFonts.poppins(
                          color: Colors.red,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}