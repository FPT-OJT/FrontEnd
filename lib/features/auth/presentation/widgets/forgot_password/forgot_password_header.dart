import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';

class ForgotPasswordHeader extends StatelessWidget {
  const ForgotPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 80,
        height: 3,
        decoration: BoxDecoration(
          color: const Color(0xFFC2C5CD),
          borderRadius: Rounded.xs,
        ),
      ),
    ],
  );
}
