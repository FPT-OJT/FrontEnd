import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fpt_ojt/app/app.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/core/config/app_config.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_details/login_details_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/login_options/login_options_cubit.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_bloc.dart';
import 'package:fpt_ojt/features/home/presentation/blocs/home_event.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/profile/presentations/blocs/update_profile/update_profile_bloc.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_bloc.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await initDependencies();
  AppConfig.validate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (context) =>
              serviceLocator<LocationBloc>()..add(const LocationStarted()),
        ),
        BlocProvider<OnboardingCubit>(
          create: (context) => serviceLocator<OnboardingCubit>(),
        ),
        BlocProvider<AuthBloc>(create: (context) => serviceLocator<AuthBloc>()),
        BlocProvider<LoginOptionsCubit>(
          create: (context) => serviceLocator<LoginOptionsCubit>(),
        ),
        BlocProvider<LoginDetailsBloc>(
          create: (context) => serviceLocator<LoginDetailsBloc>(),
        ),
        BlocProvider<HomeBloc>(
          create: (context) =>
              serviceLocator<HomeBloc>()..add(const HomeStarted()),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => serviceLocator<WalletBloc>(),
        ),
        BlocProvider<UpdateProfileBloc>(
          create: (context) => serviceLocator<UpdateProfileBloc>(),
        ),
        BlocProvider<MerchantDetailBloc>(
          create: (context) => serviceLocator<MerchantDetailBloc>(),
        ),
        BlocProvider<GeofenceBloc>(
          create: (context) => serviceLocator<GeofenceBloc>(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}
