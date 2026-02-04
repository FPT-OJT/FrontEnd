import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/home/data/models/home_data.dart';

abstract interface class HomeRepository {
  Future<Either<Failure, HomeData>> getHomeData();
}
