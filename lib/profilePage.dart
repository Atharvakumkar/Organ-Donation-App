import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/user_service.dart';
import '../model/user_model.dart';
import 'loginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController age = TextEditingController();

  final UserService _userService = UserService();
  bool _isLoading = true;

  File? _selectedImage;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userData = await _userService.getUser(currentUser.uid);

      if (userData != null) {
        fullName.text = userData.fullName;
        email.text = userData.email;
        age.text = userData.age.toString();
        _photoUrl = userData.photoUrl;
      }
    }

    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_selectedImage == null) return _photoUrl;

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('$uid.jpg');

    await ref.putFile(_selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveChanges() async {
    if (fullName.text.isEmpty || age.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name and Age cannot be empty")),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() => _isLoading = true);

    String? updatedPhotoUrl =
        await _uploadProfileImage(currentUser.uid);

    UserModel updatedUser = UserModel(
      uid: currentUser.uid,
      fullName: fullName.text.trim(),
      email: email.text.trim(),
      age: int.parse(age.text.trim()),
      photoUrl: updatedPhotoUrl,
    );

    await _userService.updateUser(updatedUser);

    setState(() {
      _photoUrl = updatedPhotoUrl;
      _selectedImage = null;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      return NetworkImage(_photoUrl!);
    }
    return null;
  }

  bool _showDefaultIcon() {
    return _selectedImage == null &&
        (_photoUrl == null || _photoUrl!.isEmpty);
  }

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                Text(
                  "Profile",
                  style: GoogleFonts.poppins(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        backgroundImage: _getProfileImage(),
                        child: _showDefaultIcon()
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.black38,
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.lightGreen,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.white, size: 18),
                            onPressed: _pickImage,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                _buildPillTextField(
                  controller: fullName,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  enabled: true,
                ),

                const SizedBox(height: 14),

                _buildPillTextField(
                  controller: email,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  enabled: false,
                ),

                const SizedBox(height: 14),

                _buildPillTextField(
                  controller: age,
                  label: "Age",
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  enabled: true,
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Save Changes",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _logout,
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                          color: Colors.black12, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Logout",
                      style: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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

  Widget _buildPillTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor:
            enabled ? Colors.white : Colors.grey.shade200,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
    );
  }
}