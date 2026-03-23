part of 'onboarding_datasource.dart';

class OnboardingLocalDataSource implements OnboardingDataSource {
  const OnboardingLocalDataSource(this._kvStorage);
  final KeyValueStorage _kvStorage;
  static const String _seenKey = 'onboarding_seen';

  @override
  Future<void> setSeen() async {
    await _kvStorage.set(_seenKey, true);
  }

  @override
  Future<bool> isSeen() async {
    final seen = await _kvStorage.get<bool>(_seenKey);
    return seen ?? false;
  }
}
