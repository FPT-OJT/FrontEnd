import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({required this.item, super.key});
  final OnboardingItem item;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      UIGaps.h12,
      _buildImage(),
      UIGaps.h20,
      _buildTitle(context),
      UIGaps.h20,
      _buildSubtitle(context),
    ],
  );

  Widget _buildImage() => SizedBox(
    width: 217,
    height: 217,
    child: Image.asset(item.image, fit: BoxFit.cover),
  );

  Widget _buildTitle(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Text(
      item.title,
      style: Theme.of(context).textTheme.displayMedium,
      textAlign: TextAlign.center,
    ),
  );

  Widget _buildSubtitle(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 72),
    child: Text(
      item.subtitle,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
    ),
  );
}
