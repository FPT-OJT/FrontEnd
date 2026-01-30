part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependencies() async {
  serviceLocator
    ..registerLazySingleton<KeyValueStorage>(
      LocalStore.new,
      instanceName: 'local_storage',
    )
    ..registerLazySingleton<KeyValueStorage>(
      SecureStore.new,
      instanceName: 'secure_storage',
    )
    ..registerLazySingleton<Dio>(
      () => HttpClient(
        tokenStore: serviceLocator(),
        refreshTokenDataSource: serviceLocator(),
      ).createDioClient(AppConfig.apiUrl),
    );
  _initIntro();
  await _initAuth();
  await _initMerchant();
  await _initHome();
}

void _initIntro() {
  // Data sources

  serviceLocator
    ..registerLazySingleton<OnboardingDataSource>(
      () => OnboardingLocalDataSource(
        serviceLocator(instanceName: 'local_storage'),
      ),
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
    ..registerLazySingleton<TokenStore>(
      () => TokenStoreImpl(
        secureKVStorage: serviceLocator(instanceName: 'secure_storage'),
      ),
    )
    ..registerLazySingleton<RefreshTokenDataSource>(
      () => RefreshTokenDataSourceImpl(
        dio: Dio(
          BaseOptions(
            baseUrl: AppConfig.apiUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ),
      ),
    )
    ..registerLazySingleton<AuthDataSource>(
      () => AuthDataSourceImpl(dio: serviceLocator()),
    )
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
    ..registerFactory<RegisterUseCase>(
      () => RegisterUseCase(authRepository: serviceLocator()),
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
    )
    ..registerFactory<RegisterBloc>(
      () => RegisterBloc(registerUseCase: serviceLocator()),
    )
    ..registerFactory<ForgotPasswordUseCase>(
      () => ForgotPasswordUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<ResetPasswordUseCase>(
      () => ResetPasswordUseCase(authRepository: serviceLocator()),
    )
    ..registerFactory<ForgotPasswordBloc>(
      () => ForgotPasswordBloc(
        forgotPasswordUseCase: serviceLocator(),
        resetPasswordUseCase: serviceLocator(),
      ),
    );
}

Future<void> _initMerchant() async {
  serviceLocator
    ..registerLazySingleton<MerchantCategoryDataSource>(
      () => MerchantCategoryDataSourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<MerchantAgencyDatasource>(
      () => MerchantAgencyDatasourceImpl(dio: serviceLocator()),
    )
    ..registerLazySingleton<LocationDataSource>(LocationDatasourceImpl.new)
    ..registerLazySingleton<MerchantCategoryRepository>(
      () => MerchantCategoryRepositoryImpl(dataSource: serviceLocator()),
    )
    ..registerLazySingleton<MerchantAgencyRepository>(
      () => MerchantAgencyRepositoryImpl(
        locationDataSource: serviceLocator(),
        merchantAgencyDataSource: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetMerchantCategoriesUseCase>(
      () => GetMerchantCategoriesUseCase(
        merchantCategoryRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton<GetNearestMerchantAgenciesUseCase>(
      () => GetNearestMerchantAgenciesUseCase(serviceLocator()),
    );
}

Future<void> _initHome() async {
  serviceLocator.registerFactory<HomeBloc>(
    () => HomeBloc(
      getMerchantCategoriesUseCase: serviceLocator(),
      getNearestMerchantAgenciesUseCase: serviceLocator(),
    ),
  );
}
