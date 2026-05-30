import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'pages/login_page.dart';
import 'pages/undangan_page.dart';
import 'utils/style.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppStyle.cream,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text(
              "THE WEDDING INVITATION",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppStyle.mahogany,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              user != null
                  ? "Login: ${user.displayName}"
                  : "Belum login",
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
              child: const Text("Login Google"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UndanganPage(),
                  ),
                );
              },
              child: const Text("Buka Undangan"),
            ),
          ],
        ),
      ),
    );
  }
}