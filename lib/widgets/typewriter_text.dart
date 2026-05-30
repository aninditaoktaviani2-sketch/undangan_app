import 'package:flutter/material.dart';
import '../utils/style.dart';

class SlideWidget extends StatelessWidget {
  final String text;

  const SlideWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppStyle.cream,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppStyle.normal, // ✅ FIX DI SINI
          ),
        ),
      ),
    );
  }
}