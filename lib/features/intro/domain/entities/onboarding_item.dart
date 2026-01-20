import 'package:equatable/equatable.dart';

class OnboardingItem extends Equatable {
  const OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.showGetStarted = false,
  });
  final String image;
  final String title;
  final String subtitle;
  final bool showGetStarted;
  @override
  List<Object?> get props => [image, title, subtitle, showGetStarted];
}
