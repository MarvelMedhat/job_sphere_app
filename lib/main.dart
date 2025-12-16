import 'package:flutter/material.dart';
import 'ui/screens/login_screen.dart';

void main() {
  runApp(const JobSphereApp());
}

class JobSphereApp extends StatelessWidget {
  const JobSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JobSphere',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),

      home: const LoginScreen(),
    );
  }
}
