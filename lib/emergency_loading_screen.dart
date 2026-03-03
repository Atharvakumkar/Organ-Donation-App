import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'emergency_results_screen.dart';

class EmergencyLoadingScreen extends StatefulWidget {
  final String location;
  final String? selectedOrgan;
  final List<Map<String, dynamic>> donors;

  const EmergencyLoadingScreen({
    super.key,
    required this.location,
    required this.selectedOrgan,
    required this.donors,
  });

  @override
  State<EmergencyLoadingScreen> createState() =>
      _EmergencyLoadingScreenState();
}

class _EmergencyLoadingScreenState
    extends State<EmergencyLoadingScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _scaleAnimation =
        Tween<double>(begin: 0.95, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
        );

    _controller.forward();

    // Delay before navigating
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration:
          const Duration(milliseconds: 400),
          pageBuilder: (_, animation, __) =>
              EmergencyResultsScreen(
                location: widget.location,
                selectedOrgan: widget.selectedOrgan,
                donors: widget.donors,
              ),
          transitionsBuilder:
              (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                const CircularProgressIndicator(
                  color: Colors.lightGreen,
                  strokeWidth: 3,
                ),

                const SizedBox(height: 25),

                Text(
                  "Searching donors near you",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  widget.location.isEmpty
                      ? "Finding the best matches"
                      : "Location: ${widget.location}",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}