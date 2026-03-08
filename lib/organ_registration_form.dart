import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final locationController = TextEditingController(); // ✅ NEW

  String? selectedGender; // ✅ NEW
  bool smokingHistory = false;
  bool previousSurgery = false;
  bool isLoading = false;

  Future<void> submitData() async {
    if (!_formKey.currentState!.validate() || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please complete all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance.collection("organ_donors").add({
        "name": nameController.text.trim(),
        "age": int.parse(ageController.text.trim()),
        "bloodGroup": bloodController.text.trim(),
        "phone": phoneController.text.trim(),
        "emergencyContact": emergencyController.text.trim(),
        "organ": widget.selectedOrgan,
        "location": locationController.text.trim().toLowerCase(), // ✅
        "gender": selectedGender, // ✅
        "smokingHistory": smokingHistory,
        "previousSurgery": previousSurgery,
        "medicalHistory": medicalHistoryController.text.trim(),
        "createdAt": Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${widget.selectedOrgan} Donation Registration Successful",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      nameController.clear();
      ageController.clear();
      bloodController.clear();
      phoneController.clear();
      emergencyController.clear();
      medicalHistoryController.clear();
      locationController.clear();

      setState(() {
        selectedGender = null;
        smokingHistory = false;
        previousSurgery = false;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => isLoading = false);
  }

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
                        color: Colors.lightGreen,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildPillField("Full Name", nameController, Icons.person),
                _buildPillField("Age", ageController, Icons.cake, isNumber: true),
                _buildPillField("Blood Group", bloodController, Icons.bloodtype),
                _buildPillField("Phone Number", phoneController, Icons.phone, isNumber: true),
                _buildPillField("Emergency Contact", emergencyController, Icons.contact_phone),
                _buildPillField("Location (City)", locationController, Icons.location_city), // ✅

                const SizedBox(height: 16),

                _buildGenderSelector(), // ✅ NEW

                const SizedBox(height: 16),

                _buildDynamicMedicalSection(),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : submitData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Complete Registration",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    final genders = ["Male", "Female", "Other"];

    return Wrap(
      spacing: 10,
      children: genders.map((gender) {
        final isSelected = selectedGender == gender;

        return ChoiceChip(
          label: Text(gender),
          selected: isSelected,
          selectedColor: Colors.lightGreen,
          onSelected: (_) {
            setState(() {
              selectedGender = gender;
            });
          },
        );
      }).toList(),
    );
  }

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
    } else {
      return _buildPillField(
          "Medical History", medicalHistoryController, Icons.medical_information);
    }
  }

  Widget _buildSwitchCard(
      String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeColor: Colors.lightGreen,
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 13),
      ),
    );
  }
}