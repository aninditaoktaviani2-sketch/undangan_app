import 'package:flutter/material.dart';
import '../utils/style.dart';

class DecorBackground extends StatelessWidget {
  final Widget child;

  const DecorBackground({super.key, required this.child});

  Widget candi(Alignment align) {
    return Align(
      alignment: align,
      child: Opacity(
        opacity: 0.12,
        child: Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.mahogany, width: 2),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(width: 70, height: 18, color: AppStyle.mahogany),
              Container(width: 90, height: 18, color: AppStyle.mahogany),
              Container(width: 120, height: 40, color: AppStyle.mahogany),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: AppStyle.cream),

        candi(Alignment.bottomLeft),
        candi(Alignment.bottomRight),

        Center(
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppStyle.mahogany.withOpacity(0.05),
            ),
          ),
        ),

        child,
      ],
    );
  }
}