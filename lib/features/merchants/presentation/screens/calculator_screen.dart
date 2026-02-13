import 'package:flutter/material.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({required this.merchantId, super.key});
  final String merchantId;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body:  Center(
        child: Text('Calculator $merchantId'),
      ),
    );
}