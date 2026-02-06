import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';
import 'package:fpt_ojt/features/home/domain/repositories/home_repository.dart';

class GetHomeUc implements UseCase<HomeData, NoParams> {
  GetHomeUc({required HomeRepository homeRepository})
    : _homeRepository = homeRepository;
  final HomeRepository _homeRepository;
  @override
  Future<Either<Failure, HomeData>> call(NoParams params) async =>
      _homeRepository.getHomeData();
}
