import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrganRegistrationForm extends StatefulWidget {
  final String selectedOrgan;

  const OrganRegistrationForm({super.key, required this.selectedOrgan});

  @override
  State<OrganRegistrationForm> createState() =>
      _OrganRegistrationFormState();
}

class _OrganRegistrationFormState
    extends State<OrganRegistrationForm> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final bloodController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyController = TextEditingController();
  final medicalHistoryController = TextEditingController();

  File? selectedDocument;
  bool isLoading = false;
  String? currentStatus;

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchStatus();
  }

  Future<void> _fetchStatus() async {
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('organ_registrations')
        .where('userId', isEqualTo: user!.uid)
        .where('organ', isEqualTo: widget.selectedOrgan)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        currentStatus = snapshot.docs.first['status'];
      });
    }
  }

  Future<String?> _uploadDocument() async {
    if (selectedDocument == null || user == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('organ_documents')
        .child('${user!.uid}_${widget.selectedOrgan}.jpg');

    await ref.putFile(selectedDocument!);
    return await ref.getDownloadURL();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;

    setState(() => isLoading = true);

    final existing = await FirebaseFirestore.instance
        .collection('organ_registrations')
        .where('userId', isEqualTo: user!.uid)
        .where('organ', isEqualTo: widget.selectedOrgan)
        .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Already Registered")),
      );
      setState(() => isLoading = false);
      return;
    }

    String? documentUrl = await _uploadDocument();

    await FirebaseFirestore.instance
        .collection('organ_registrations')
        .add({
      "userId": user!.uid,
      "organ": widget.selectedOrgan,
      "name": nameController.text.trim(),
      "age": ageController.text.trim(),
      "bloodGroup": bloodController.text.trim(),
      "phone": phoneController.text.trim(),
      "emergencyContact": emergencyController.text.trim(),
      "medicalHistory": medicalHistoryController.text.trim(),
      "documentUrl": documentUrl,
      "status": "Pending",
      "createdAt": Timestamp.now(),
    });

    await _fetchStatus();

    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Registration Submitted 💚")),
    );
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final file =
        await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        selectedDocument = File(file.path);
      });
    }
  }

  Color _statusColor(String status) {
    if (status == "Accepted") return Colors.green;
    if (status == "Rejected") return Colors.red;
    return Colors.orange;
  }

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

  Widget _buildPillField(String label,
      TextEditingController controller,
      IconData icon,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType:
            isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            value == null || value.isEmpty
                ? "Required Field"
                : null,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon:
              Icon(icon, size: 20, color: Colors.black45),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicMedicalSection() {
    return _buildPillField(
        "Medical History",
        medicalHistoryController,
        Icons.medical_information);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              /// ===== HEADER =====
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${widget.selectedOrgan} Donation",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (currentStatus != null)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5),
                      decoration: BoxDecoration(
                        color: _statusColor(
                                currentStatus!)
                            .withOpacity(0.15),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        currentStatus!,
                        style:
                            GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color: _statusColor(
                              currentStatus!),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              /// ===== FORM =====
              Form(
                key: _formKey,
                child: Column(
                  children: [

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(18),
                      decoration:
                          _cardDecoration(),
                      child: Text(
                        "Register as ${widget.selectedOrgan} Donor",
                        style:
                            GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    _buildPillField("Full Name",
                        nameController,
                        Icons.person),

                    _buildPillField("Age",
                        ageController,
                        Icons.cake,
                        isNumber: true),

                    _buildPillField(
                        "Blood Group",
                        bloodController,
                        Icons.bloodtype),

                    _buildPillField(
                        "Phone Number",
                        phoneController,
                        Icons.phone,
                        isNumber: true),

                    _buildPillField(
                        "Emergency Contact",
                        emergencyController,
                        Icons.contact_phone),

                    const SizedBox(height: 16),

                    _buildDynamicMedicalSection(),

                    const SizedBox(height: 24),

                    GestureDetector(
                      onTap: _pickDocument,
                      child: Container(
                        padding:
                            const EdgeInsets.all(20),
                        decoration:
                            _cardDecoration(),
                        child: Column(
                          children: [
                            const Icon(Icons.upload_file,
                                size: 36,
                                color:
                                    Colors.lightGreen),
                            const SizedBox(height: 10),
                            Text(
                              selectedDocument ==
                                      null
                                  ? "Upload Identity Document"
                                  : "Document Selected ✔",
                              style: GoogleFonts.poppins(
                                  fontWeight:
                                      FontWeight
                                          .w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : _submitForm,
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.lightGreen,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(32),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                "Complete Registration",
                                style:
                                    GoogleFonts
                                        .poppins(
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// ===== MY REGISTRATIONS =====
              Text(
                "My Registrations",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('organ_registrations')
                    .where('userId',
                        isEqualTo:
                            FirebaseAuth.instance
                                .currentUser?.uid)
                    .orderBy('createdAt',
                        descending: true)
                    .snapshots(),
                builder: (context, snapshot) {

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding:
                          const EdgeInsets.all(18),
                      decoration:
                          _cardDecoration(),
                      child: Text(
                        "No registrations yet",
                        style:
                            GoogleFonts.poppins(
                                color:
                                    Colors.black45),
                      ),
                    );
                  }

                  final docs =
                      snapshot.data!.docs;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder:
                        (context, index) {

                      final data = docs[index];
                      final organ =
                          data['organ'];
                      final status =
                          data['status'];

                      return Container(
                        margin:
                            const EdgeInsets.only(
                                bottom: 14),
                        padding:
                            const EdgeInsets.all(
                                18),
                        decoration:
                            _cardDecoration(),
                        child: Row(
                          children: [
                            const Icon(
                                Icons.favorite,
                                color:
                                    Colors.lightGreen,
                                size: 26),
                            const SizedBox(
                                width: 12),
                            Expanded(
                              child: Text(
                                "$organ Donation",
                                style: GoogleFonts
                                    .poppins(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(
                                      horizontal:
                                          10,
                                      vertical:
                                          5),
                              decoration:
                                  BoxDecoration(
                                color: _statusColor(
                                        status)
                                    .withOpacity(
                                        0.15),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            20),
                              ),
                              child: Text(
                                status,
                                style:
                                    GoogleFonts
                                        .poppins(
                                  fontSize:
                                      12,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      _statusColor(
                                          status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}