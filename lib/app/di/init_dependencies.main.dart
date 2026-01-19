part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  serviceLocator
    ..registerLazySingleton<KeyValueStorage>(LocalStore.new)
    ..registerLazySingleton<Dio>(
      () => HttpClient().createDioClient('https://api.example.com'),
    );
  _initIntro();
  await _initAuth();
}

void _initIntro() {}

Future<void> _initAuth() async {}
