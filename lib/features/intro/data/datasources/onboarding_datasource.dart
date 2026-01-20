import 'package:fpt_ojt/core/storages/key_value_storage.dart';

part 'onboarding_datasource.impl.dart';

abstract class OnboardingDataSource {
  Future<void> setSeen();
  Future<bool> isSeen();
}
