import 'package:flutter/material.dart';
import 'signUpPage.dart';
import 'loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUpPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
