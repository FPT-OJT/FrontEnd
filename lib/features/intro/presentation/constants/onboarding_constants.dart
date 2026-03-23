import 'package:fpt_ojt/features/intro/domain/entities/onboarding_item.dart';

class OnboardingConstants {
  OnboardingConstants._();
  static const List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      image: 'assets/images/onboarding/onboarding_1.png',
      title: "Whenever you're at the checkout",
      subtitle:
          "Whether you're buying online, at the shops, or deciding where to go...",
    ),
    OnboardingItem(
      image: 'assets/images/onboarding/onboarding_2.png',
      title: 'We are here to help you choose, constantly. ',
      subtitle:
          "We'll let you know which card is the best to earn the best rewards, whether you're looking for cash back, air miles or loyalty points",
    ),
    OnboardingItem(
      image: 'assets/images/onboarding/onboarding_3.png',
      title: 'Sit back and reap the reward.',
      subtitle:
          'You can go on with your day knowing you have made the best decision on your purchases! ',
      showGetStarted: true,
    ),
  ];

  static const String getStartedButtonText = 'Get Started';
}
