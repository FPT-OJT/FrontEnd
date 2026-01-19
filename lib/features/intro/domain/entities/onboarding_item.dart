class OnboardingItem {
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
}
