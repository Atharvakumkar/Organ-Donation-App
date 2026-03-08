import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:organ_donation_app/homeScreen.dart';
import 'signUpPage.dart';
import 'loginPage.dart';
import 'screen.dart';
import 'homeScreen.dart';
import 'profilePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
