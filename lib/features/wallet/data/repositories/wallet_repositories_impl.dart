import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/wallet/data/datasources/wallet_datasource.dart';
import 'package:fpt_ojt/features/wallet/data/mapper/wallet_mapper.dart';
import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';
import 'package:fpt_ojt/features/wallet/domain/repositories/wallet_repositories.dart';

class WalletRepositoriesImpl implements WalletRepositories {
  WalletRepositoriesImpl({required WalletDatasource walletDatasource})
    : _walletDatasource = walletDatasource;
  final WalletDatasource _walletDatasource;

  @override
  Future<Either<Failure, List<WalletItem>>> getMyApps() async {
    try {
      final response = await _walletDatasource.getMyApps('PAYMENT_APP');
      return Right(response.data!.map((item) => item.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletItem>>> getMyCards() async {
    try {
      final response = await _walletDatasource.getMyCards();
      return Right(response.data!.map((item) => item.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<WalletItem>>> getMyFavMerchants() async {
    try {
      final response = await _walletDatasource.getMyFavMerchants();
      return Right(response.data!.map((item) => item.toEntity()).toList());
    } on Exception catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
