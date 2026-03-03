import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonationFlow extends StatefulWidget {
  const DonationFlow({super.key});

  @override
  State<DonationFlow> createState() => _DonationFlowState();
}

class _DonationFlowState extends State<DonationFlow> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PageController _controller = PageController();
  final _personalKey = GlobalKey<FormState>();
  final _medicalKey = GlobalKey<FormState>();

  int step = 0;

  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final weight = TextEditingController();

  String? selectedGender;
  String? selectedBloodGroup;

  DateTime? dob;
  DateTime? lastDonationDate;
  PlatformFile? report;

  final Color primaryGreen = const Color(0xFF1B5E20);
  final Color backgroundColor = const Color(0xFFF1F8F4);

  // ================= AGE =================
  int? get age {
    if (dob == null) return null;
    final today = DateTime.now();
    int a = today.year - dob!.year;
    if (today.month < dob!.month ||
        (today.month == dob!.month && today.day < dob!.day)) {
      a--;
    }
    return a;
  }

  bool get ageEligible => age != null && age! >= 18 && age! <= 65;

  bool get weightEligible =>
      weight.text.isNotEmpty &&
          int.tryParse(weight.text) != null &&
          int.parse(weight.text) >= 50;

  bool get lastDonationEligible {
    if (lastDonationDate == null) return true;
    final difference =
        DateTime.now().difference(lastDonationDate!).inDays;
    return difference >= 90;
  }

  // ================= NAVIGATION =================
  void next() {
    if (step < 3) {
      setState(() => step++);
      _controller.animateToPage(step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  void back() {
    if (step > 0) {
      setState(() => step--);
      _controller.animateToPage(step,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  // ================= FILE PICKER =================
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        report = result.files.first;
      });
    }
  }

  // ================= HEADER =================
  Widget buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: primaryGreen),
            onPressed: back,
          ),
          Expanded(
            child: Column(
              children: [
                Text("Step ${step + 1} of 4",
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(title,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryGreen)),
              ],
            ),
          ),
          const SizedBox(width: 40)
        ],
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 650),
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: child,
        ),
      ),
    );
  }

  // ================= PAGE 1 =================
  Widget overviewStep() {
    return buildContainer(
      SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Text("Donate Blood. Save Lives.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen)),
            const SizedBox(height: 30),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 55,
                  sectionsSpace: 3,
                  sections: [
                    PieChartSectionData(
                      value: 65,
                      color: primaryGreen,
                      radius: 60,
                      title: "65%",
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    PieChartSectionData(
                      value: 35,
                      color: Colors.grey.shade300,
                      radius: 55,
                      title: "",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "65% of required blood units fulfilled.\nBe the hero someone needs today.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child:
              buildPrimaryButton("Start Registration", next),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PAGE 2 =================
  Widget personalStep() {
    return buildContainer(
      Form(
        key: _personalKey,
        child: ListView(
          children: [
            buildField("Full Name", name,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Full name required";
                  }
                  if (v.length < 3) {
                    return "Enter valid name";
                  }
                  return null;
                }),
            buildField("Email", email,
                type: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Email required";
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                      .hasMatch(v)) {
                    return "Enter valid email";
                  }
                  return null;
                }),
            buildField("Phone Number", phone,
                type: TextInputType.phone,
                validator: (v) {
                  if (!RegExp(r'^[0-9]{10}$')
                      .hasMatch(v ?? "")) {
                    return "Enter valid 10-digit number";
                  }
                  return null;
                }),
            buildDropdown(
                "Gender",
                ["Male", "Female", "Other"],
                selectedGender, (val) {
              setState(() => selectedGender = val);
            }),
            buildDOBPicker(),
            if (age != null) buildAgeIndicator(),
            const SizedBox(height: 20),
            buildPrimaryButton("Next", () {
              if (_personalKey.currentState!.validate() &&
                  ageEligible &&
                  selectedGender != null) {
                next();
              }
            })
          ],
        ),
      ),
    );
  }

  Widget buildDOBPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          initialDate: DateTime(2000),
        );
        if (picked != null) {
          setState(() => dob = picked);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryGreen),
        ),
        child: Text(dob == null
            ? "Select Date of Birth"
            : DateFormat('dd MMM yyyy').format(dob!)),
      ),
    );
  }

  Widget buildAgeIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color:
        ageEligible ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: ageEligible ? Colors.green : Colors.red),
      ),
      child: Row(
        children: [
          Icon(
            ageEligible
                ? Icons.check_circle
                : Icons.cancel,
            color: ageEligible
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(width: 10),
          Text(
            ageEligible
                ? "Age: $age (Eligible)"
                : "Age: $age (Must be 18–65)",
          )
        ],
      ),
    );
  }

  // ================= PAGE 3 =================
  Widget medicalStep() {
    return buildContainer(
      Form(
        key: _medicalKey,
        child: ListView(
          children: [
            buildDropdown(
                "Blood Group",
                ["A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"],
                selectedBloodGroup, (val) {
              setState(() => selectedBloodGroup = val);
            }),
            buildField("Weight (kg)", weight,
                type: TextInputType.number,
                validator: (v) {
                  final w = int.tryParse(v ?? "");
                  if (w == null || w < 50) {
                    return "Minimum 50kg required";
                  }
                  return null;
                }),
            buildLastDonationPicker(),
            if (lastDonationDate != null)
              buildDonationIndicator(),
            buildFileUpload(),
            const SizedBox(height: 20),
            buildPrimaryButton("Next", () {
              if (_medicalKey.currentState!.validate() &&
                  report != null &&
                  selectedBloodGroup != null &&
                  lastDonationEligible) {
                next();
              }
            })
          ],
        ),
      ),
    );
  }

  Widget buildLastDonationPicker() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
          initialDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => lastDonationDate = picked);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryGreen),
        ),
        child: Text(
          lastDonationDate == null
              ? "Select Last Donation Date (Optional)"
              : DateFormat('dd MMM yyyy')
              .format(lastDonationDate!),
        ),
      ),
    );
  }

  Widget buildDonationIndicator() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: lastDonationEligible
            ? Colors.green.shade50
            : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: lastDonationEligible
                ? Colors.green
                : Colors.red),
      ),
      child: Row(
        children: [
          Icon(
            lastDonationEligible
                ? Icons.check_circle
                : Icons.cancel,
            color: lastDonationEligible
                ? Colors.green
                : Colors.red,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              lastDonationEligible
                  ? "Eligible (90+ days gap maintained)"
                  : "Minimum 90 days gap required",
            ),
          )
        ],
      ),
    );
  }

  Widget buildFileUpload() {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(color: primaryGreen),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Icon(Icons.upload_file, color: primaryGreen),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                report == null
                    ? "Upload Blood Report (Required)"
                    : report!.name,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= PAGE 4 =================
  Widget reviewStep() {
    return buildContainer(
      Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Review Your Details",
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryGreen)),
              const SizedBox(height: 25),
              buildReviewRow("Name", name.text),
              buildReviewRow("Gender", selectedGender ?? ""),
              buildReviewRow(
                  "Blood Group", selectedBloodGroup ?? ""),
              buildReviewRow("Age", "$age years"),
              buildReviewRow(
                  "Weight", "${weight.text} kg"),
              buildReviewRow(
                  "Last Donation",
                  lastDonationDate == null
                      ? "First Time Donor"
                      : DateFormat('dd MMM yyyy')
                      .format(lastDonationDate!)),
              buildReviewRow(
                  "Report", report?.name ?? "Not uploaded"),
              const SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: buildPrimaryButton("Submit", () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(20)),
                        content: Column(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 90),
                            const SizedBox(height: 20),
                            Text(
                              "Successfully Submitted!",
                              style:
                              GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Please wait for doctor's approval.",
                              textAlign:
                              TextAlign.center,
                            ),
                          ],
                        ),
                      ));
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text("$label: ",
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value,
                style:
                GoogleFonts.poppins(fontSize: 16)),
          )
        ],
      ),
    );
  }

  Widget buildField(String label,
      TextEditingController controller,
      {TextInputType? type,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        validator:
        validator ?? (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildDropdown(String label, List<String> items,
      String? selected, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: selected,
        items: items
            .map((e) =>
            DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        validator: (v) =>
        v == null ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget buildPrimaryButton(
      String text, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        padding:
        const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(30)),
      ),
      onPressed: onTap,
      child: Text(text,
          style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titles = [
      "Impact Overview",
      "Personal Information",
      "Medical Information",
      "Review & Submit"
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildHeader(titles[step]),
            Expanded(
              child: PageView(
                controller: _controller,
                physics:
                const NeverScrollableScrollPhysics(),
                children: [
                  overviewStep(),
                  personalStep(),
                  medicalStep(),
                  reviewStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}