import 'package:flutter/material.dart';
import 'job_list_screen.dart';
import 'login_screen.dart';
import 'applicant_profile.dart';
import '../../features/auth/auth_controller.dart';

class ApplicantHomeScreen extends StatelessWidget {
  const ApplicantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController();

    // Colors
    final Color primaryColor = Colors.deepPurple;
    final Color cardColor = Colors.white.withOpacity(0.95);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Applicant Dashboard",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: "Logout",
                        onPressed: () {
                          authController.logout();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 40),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const JobListScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      color: cardColor,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: SizedBox(
                        height: 140,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.work,
                                size: 50, color: primaryColor),
                            title: Text(
                              "Browse Jobs",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                const Text("Explore and apply for jobs"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ApplicantProfileScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Card(
                      color: cardColor,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: SizedBox(
                        height: 140,
                        child: Center(
                          child: ListTile(
                            leading: Icon(Icons.person,
                                size: 50, color: Colors.green),
                            title: Text(
                              "My Profile",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                const Text("View and edit your profile"),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
