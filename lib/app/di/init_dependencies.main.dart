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

void _initIntro() {
  // Data sources

  serviceLocator
    ..registerLazySingleton<OnboardingDataSource>(
      () => OnboardingLocalDataSource(serviceLocator()),
    )
    // Repositories
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(serviceLocator()),
    )
    // Use cases
    ..registerLazySingleton<EndOnboardingUseCase>(
      () => EndOnboardingUseCase(serviceLocator()),
    )
    ..registerLazySingleton<GetOnboardingCompletionStatusUseCase>(
      () => GetOnboardingCompletionStatusUseCase(serviceLocator()),
    )
    // cubits
    ..registerFactory<OnboardingCubit>(
      () => OnboardingCubit(
        endOnboardingUseCase: serviceLocator(),
        getIsOnboardingUseCase: serviceLocator(),
      ),
    );
}

Future<void> _initAuth() async {
  final googleSignIn = GoogleSignIn.instance;
  await googleSignIn.initialize(
    serverClientId: AppConfig.webGoogleClientId,
    clientId: AppConfig.androidGoogleClientId,
  );
  serviceLocator.registerLazySingleton<GoogleSignIn>(() => googleSignIn);

  serviceLocator
    ..registerLazySingleton<GoogleAuthDataSource>(
      () => GoogleAuthDataSourceImpl(googleSignIn: serviceLocator()),
    )
    ..registerLazySingleton<TokenDataSource>(
      () => TokenDataSourceImpl(localStorage: serviceLocator()),
    )
    ..registerLazySingleton<AuthDataSource>(() => AuthDataSourceImpl(dio: serviceLocator()))
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        authDataSource: serviceLocator(),
        googleAuthDataSource: serviceLocator(),
        tokenDataSource: serviceLocator(),
      ),
    )
    ..registerLazySingleton<CurrentUserUseCase>(
      () => CurrentUserUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<LoginWithEmailUseCase>(
      () => LoginWithEmailUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<LoginWithGoogleUseCase>(
      () => LoginWithGoogleUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<LogoutUseCase>(
      () => LogoutUseCase(authRepository: serviceLocator()),
    )
    // cubits & blocs
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        currentUserUseCase: serviceLocator(),
        logoutUseCase: serviceLocator(),
      ),
    )
    ..registerFactory<LoginOptionsCubit>(
      () => LoginOptionsCubit(loginWithGoogleUseCase: serviceLocator()),
    )
    ..registerFactory<LoginDetailsBloc>(
      () => LoginDetailsBloc(loginWithEmailUseCase: serviceLocator()),
    );
}
