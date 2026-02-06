import 'package:fpdart/fpdart.dart';
import 'package:fpt_ojt/core/error/failures.dart';
import 'package:fpt_ojt/core/usecase/usecase_interface.dart';
import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';
import 'package:fpt_ojt/features/wallet/domain/repositories/wallet_repositories.dart';

class GetMyCards implements UseCase<List<WalletItem>, NoParams> {
  GetMyCards({required WalletRepositories walletRepositories})
    : _walletRepositories = walletRepositories;
  final WalletRepositories _walletRepositories;
  @override
  Future<Either<Failure, List<WalletItem>>> call(NoParams params) =>
      _walletRepositories.getMyCards();
}
