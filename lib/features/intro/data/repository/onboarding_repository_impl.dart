import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/intro/data/datasources/onboarding_datasource.dart';
import 'package:fpt_ojt/features/intro/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._dataSource);
  final OnboardingDataSource _dataSource;
  @override
  Future<bool> isSeen() async {
    final seen = await _dataSource.isSeen();
    return seen;
  }

  @override
  Future<Either<Failure, Unit>> setSeen() async {
    try {
      await _dataSource.setSeen();
      return right<Failure, Unit>(unit);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
