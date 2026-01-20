import 'package:dio/dio.dart';
import 'package:fpt_ojt/core/network/http_client.dart';
import 'package:fpt_ojt/core/storages/key_value_storage.dart';
import 'package:fpt_ojt/core/storages/local_storage.dart';
import 'package:fpt_ojt/features/intro/data/datasources/onboarding_datasource.dart';
import 'package:fpt_ojt/features/intro/data/repository/onboarding_repository_impl.dart';
import 'package:fpt_ojt/features/intro/domain/repositories/onboarding_repository.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/end_onboarding.dart';
import 'package:fpt_ojt/features/intro/domain/usecases/get_onboarding_completion_status.dart';
import 'package:fpt_ojt/features/intro/presentation/blocs/onboarding/onboarding_cubit.dart';
import 'package:get_it/get_it.dart';

part 'init_dependencies.main.dart';
