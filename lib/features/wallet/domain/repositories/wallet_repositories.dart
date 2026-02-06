import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';

abstract interface class WalletRepositories {
  Future<Either<Failure, List<WalletItem>>> getMyCards();
  Future<Either<Failure, List<WalletItem>>> getMyFavMerchants();
  Future<Either<Failure, List<WalletItem>>> getMyApps();
}
