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
  await _initLocation();
  _initWallet();
  _initCard();
  _initProfile();
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
        localStorage: serviceLocator(instanceName: 'local_storage'),
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
      () => GetNearestMerchantAgenciesUseCase(
        merchantAgencyRepository: serviceLocator(),
        getShortestDistanceUseCase: serviceLocator(),
      ),
    );
}

Future<void> _initHome() async {
  // Data sources
  serviceLocator.registerLazySingleton<HomeDatasource>(
    () => HomeDatasourceImpl(dio: serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(homeDatasource: serviceLocator()),
  );

  // Use cases
  serviceLocator.registerLazySingleton<GetHomeUc>(
    () => GetHomeUc(homeRepository: serviceLocator()),
  );

  // BLoC
  serviceLocator.registerFactory<HomeBloc>(
    () => HomeBloc(getHomeUc: serviceLocator()),
  );
}

Future<void> _initLocation() async {
  serviceLocator.registerLazySingleton<LocationDataSource>(
    () => LocationDatasourceImpl(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(locationDataSource: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CurrentCoordinateUseCase>(
    () => CurrentCoordinateUseCase(locationRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CoordinateStreamUseCase>(
    () => CoordinateStreamUseCase(locationRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetShortestDistanceUseCase>(
    () => GetShortestDistanceUseCase(locationRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<LocationBloc>(
    () => LocationBloc(
      currentCoordinateUseCase: serviceLocator(),
      coordinateStreamUseCase: serviceLocator(),
    ),
  );
}

void _initWallet() {
  // Data sources
  serviceLocator.registerLazySingleton<WalletDatasource>(
    () => WalletDatasourceImpl(dio: serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<WalletRepositories>(
    () => WalletRepositoriesImpl(walletDatasource: serviceLocator()),
  );

  // Use cases
  serviceLocator
    ..registerLazySingleton<GetMyCards>(
      () => GetMyCards(walletRepositories: serviceLocator()),
    )
    ..registerLazySingleton<GetMyApps>(
      () => GetMyApps(walletRepositories: serviceLocator()),
    )
    ..registerLazySingleton<GetMyFavMerchants>(
      () => GetMyFavMerchants(walletRepositories: serviceLocator()),
    );

  // BLoC
  serviceLocator.registerFactory<WalletBloc>(
    () => WalletBloc(
      getMyCards: serviceLocator(),
      getMyApps: serviceLocator(),
      getMyFavMerchants: serviceLocator(),
    ),
  );
}

void _initCard() {
  // Data sources
  serviceLocator.registerLazySingleton<CardDatasource>(
    () => CardDatasouceImpl(dio: serviceLocator()),
  );

  // Repositories
  serviceLocator.registerLazySingleton<CardRepositories>(
    () => CardRepositoriesImpl(cardDatasource: serviceLocator()),
  );

  // Use cases
  serviceLocator
    ..registerLazySingleton<SearchCardsUsecase>(
      () => SearchCardsUsecase(cardRepositories: serviceLocator()),
    )
    ..registerLazySingleton<AddCardToUserUsecase>(
      () => AddCardToUserUsecase(cardRepositories: serviceLocator()),
    )
    ..registerLazySingleton<IsCardExistInUserUsecase>(
      () => IsCardExistInUserUsecase(cardRepositories: serviceLocator()),
    );

  // BLoC
  serviceLocator
    ..registerFactory<SearchCardBloc>(
      () => SearchCardBloc(searchCardsUsecase: serviceLocator()),
    )
    ..registerFactory<DetailCardSheetBloc>(
      () => DetailCardSheetBloc(addCardToUserUsecase: serviceLocator()),
    );
}

void _initProfile() {
  serviceLocator.registerLazySingleton<ProfileDatasource>(
    () => ProfileDatasourceImpl(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<CountryDatasource>(
    () => CountryDatasourceImpl(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileDatasource: serviceLocator(),
      countryDatasource: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton<GetMyProfileUseCase>(
    () => GetMyProfileUseCase(profileRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<UpdateMyProfileUseCase>(
    () => UpdateMyProfileUseCase(profileRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<GetCountriesUseCase>(
    () => GetCountriesUseCase(profileRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<UpdateProfileBloc>(
    () => UpdateProfileBloc(
      getMyProfileUseCase: serviceLocator(),
      updateMyProfileUseCase: serviceLocator(),
      getCountriesUseCase: serviceLocator(),
    ),
  );
}
