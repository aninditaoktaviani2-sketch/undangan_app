import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';
import 'utils/style.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mahogany,
      body: Center(
        child: Text(
          "THE WEDDING INVITATION",
          style: AppStyle.script.copyWith(color: AppStyle.cream),
        ),
      ),
    );
  }
}