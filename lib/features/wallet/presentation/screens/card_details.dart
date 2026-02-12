import 'package:flutter/material.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({required this.cardId, super.key});
  final String cardId;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Card Details')),
    body: Center(
      child: Text(
        'Details of the selected card with ID $cardId will be shown here.',
      ),
    ),
  );
}
