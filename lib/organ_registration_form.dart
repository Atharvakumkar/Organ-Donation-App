import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrganRegistrationForm extends StatefulWidget {
  final String selectedOrgan;

  const OrganRegistrationForm({super.key, required this.selectedOrgan});

  @override
  State<OrganRegistrationForm> createState() => _OrganRegistrationFormState();
}

class _OrganRegistrationFormState extends State<OrganRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final bloodController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyController = TextEditingController();
  final medicalHistoryController = TextEditingController();

  bool smokingHistory = false;
  bool previousSurgery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔙 BACK + TITLE
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${widget.selectedOrgan} Donation",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 💚 INFO CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: _cardDecoration(),
                  child: Text(
                    "Register as ${widget.selectedOrgan} Donor",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 22),

                _buildPillField("Full Name", nameController, Icons.person),
                _buildPillField("Age", ageController, Icons.cake, isNumber: true),
                _buildPillField("Blood Group", bloodController, Icons.bloodtype),
                _buildPillField("Phone Number", phoneController, Icons.phone, isNumber: true),
                _buildPillField("Emergency Contact", emergencyController, Icons.contact_phone),

                const SizedBox(height: 16),

                // 🧠 DYNAMIC SECTION
                _buildDynamicMedicalSection(),

                const SizedBox(height: 24),

                // 📤 UPLOAD CARD
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      const Icon(Icons.upload_file, size: 36, color: Colors.lightGreen),
                      const SizedBox(height: 10),
                      Text(
                        "Upload Identity Document",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // 🔥 BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${widget.selectedOrgan} Registration Successful 💚",
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Complete Registration",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔥 PILL INPUT (MATCH SIGNUP)
  Widget _buildPillField(String label, TextEditingController controller, IconData icon,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
        value == null || value.isEmpty ? "Required Field" : null,
        style: GoogleFonts.poppins(fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(icon, size: 20, color: Colors.black45),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide:
            const BorderSide(color: Colors.lightGreen, width: 1.6),
          ),
        ),
      ),
    );
  }

  // 🧠 DYNAMIC SECTION (UNCHANGED LOGIC, UPDATED UI)
  Widget _buildDynamicMedicalSection() {
    String organ = widget.selectedOrgan;

    if (organ == "Lungs") {
      return Column(
        children: [
          _buildSwitchCard("Smoking History", smokingHistory,
                  (val) => setState(() => smokingHistory = val)),
          _buildSwitchCard("Previous Lung Surgery", previousSurgery,
                  (val) => setState(() => previousSurgery = val)),
        ],
      );
    } else if (organ == "Heart") {
      return _buildPillField(
          "Cardiac Medical History", medicalHistoryController, Icons.favorite);
    } else if (organ == "Corneas" || organ == "Eyes") {
      return _buildSwitchCard("Vision Problems History", previousSurgery,
              (val) => setState(() => previousSurgery = val));
    } else {
      return _buildPillField(
          "Medical History", medicalHistoryController, Icons.medical_information);
    }
  }

  // 🔘 SWITCH CARD (MODERN)
  Widget _buildSwitchCard(
      String title, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: _cardDecoration(),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.lightGreen,
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 13),
        ),
      ),
    );
  }

  // 🎨 CARD STYLE
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 15,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }
}