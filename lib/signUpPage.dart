import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController passWord = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController age = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    passWord.dispose();
    confirmPassword.dispose();
    age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 13,),
                // Big Sign Up heading
                Text(
                  "Sign Up",
                  style: GoogleFonts.poppins(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.1,
                  ),
                ),

                const SizedBox(height: 8),

                // Already have account row
                Row(
                  children: [
                    Text(
                      "Already have an account?  ",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to login page (not created yet)
                      },
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.lightGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Input fields — pill shaped
                _buildPillTextField(
                  controller: fullName,
                  label: "Full Name",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 14),
                _buildPillTextField(
                  controller: email,
                  label: "Email Address",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _buildPillTextField(
                  controller: age,
                  label: "Age",
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 14),
                _buildPillTextField(
                  controller: passWord,
                  label: "Create Password",
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                      color: Colors.black45,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 14),
                _buildPillTextField(
                  controller: confirmPassword,
                  label: "Re-enter Password",
                  icon: Icons.lock_outline,
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 19,
                      color: Colors.black45,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),

                const SizedBox(height: 30),

                // Sign Up Button — full width pill
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () async {
                        if (passWord.text != confirmPassword.text) {
                         ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Passwords do not match")),
                        );
                        return;
                        }

                        if (fullName.text.isEmpty ||
                           email.text.isEmpty ||
                             age.text.isEmpty ||
                             passWord.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please fill all fields")),
                          );
                           return;
                          }

                            final result = await AuthService().signUp(
                             email: email.text.trim(),
                              password: passWord.text.trim(),
                              name: fullName.text.trim(),
                               age: int.parse(age.text.trim()),
                              );

                             if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Signup Successful")),
                               );

                            Navigator.pop(context); // Go back to Login
                           } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                           SnackBar(content: Text(result)),
                           );
                         }
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Or sign up with divider
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Colors.black26, thickness: 0.8),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "Or sign up with",
                        style: GoogleFonts.poppins(fontSize: 12.5, color: Colors.black45),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Colors.black26, thickness: 0.8),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Google sign up button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black12, width: 1.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: CustomPaint(painter: _GoogleLogoPainter()),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Google",
                          style: GoogleFonts.poppins(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
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
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.poppins(color: Colors.black45, fontSize: 14),
        prefixIcon: Icon(icon, size: 20, color: Colors.black45),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.black12, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: const BorderSide(color: Colors.lightGreen, width: 1.8),
        ),
      ),
    );
  }
}

// Google "G" logo painted with arcs
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    final List<Map<String, dynamic>> segments = [
      {'color': const Color(0xFF4285F4), 'start': -0.52, 'sweep': 1.57},
      {'color': const Color(0xFF34A853), 'start': 1.05, 'sweep': 1.57},
      {'color': const Color(0xFFFBBC05), 'start': 2.62, 'sweep': 0.79},
      {'color': const Color(0xFFEA4335), 'start': 3.41, 'sweep': 1.30},
    ];

    for (final seg in segments) {
      final paint = Paint()
        ..color = seg['color'] as Color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.28;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.72),
        seg['start'] as double,
        seg['sweep'] as double,
        false,
        paint,
      );
    }

    // Blue horizontal bar of the G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
          cx, cy - size.height * 0.14, r * 0.75, size.height * 0.28),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}