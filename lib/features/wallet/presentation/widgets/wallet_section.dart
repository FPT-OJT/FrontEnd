import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:fpt_ojt/features/wallet/presentation/bloc/wallet_state.dart';
import 'package:fpt_ojt/features/wallet/presentation/widgets/wallet_dropbox.dart';

class WalletSection extends StatelessWidget {
  const WalletSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _buildCreditCardList(),
      _buildPaymentAppList(),
      _buildFavoriteMerchantList(),
    ],
  );

  Widget _buildErrorState(String? errorMessage) =>
      Text(errorMessage ?? 'An error occurred');

  Widget _buildCreditCardList() => BlocBuilder<WalletBloc, WalletState>(
    builder: (context, walletState) {
      if (walletState.creditCardStatus == WalletLoadStatus.failure) {
        return _buildErrorState(walletState.errorMessage);
      }

      return WalletDropbox(
        name: 'Your credit cards',
        iconUrl: 'assets/images/wallet/icons/wallet.svg',
        isCard: true,
        isLoading: walletState.creditCardStatus == WalletLoadStatus.loading,
        walletItems: walletState.creditCards,
        onExpand: () => context.read<WalletBloc>().add(const LoadCreditCards()),
      );
    },
  );
  Widget _buildPaymentAppList() => BlocBuilder<WalletBloc, WalletState>(
    builder: (context, walletState) {
      if (walletState.paymentAppsStatus == WalletLoadStatus.failure) {
        return _buildErrorState(walletState.errorMessage);
      }

      return WalletDropbox(
        name: 'Your payment apps',
        iconUrl: 'assets/images/wallet/icons/payment_app.svg',
        isLoading: walletState.paymentAppsStatus == WalletLoadStatus.loading,
        walletItems: walletState.paymentApps,
        onExpand: () => context.read<WalletBloc>().add(const LoadPaymentApps()),
      );
    },
  );
  Widget _buildFavoriteMerchantList() => BlocBuilder<WalletBloc, WalletState>(
    builder: (context, walletState) {
      if (walletState.favoriteMerchantsStatus == WalletLoadStatus.failure) {
        return _buildErrorState(walletState.errorMessage);
      }

      return WalletDropbox(
        name: 'Favorite merchants',
        iconUrl: 'assets/images/wallet/icons/fav_merchant.svg',
        isLoading:
            walletState.favoriteMerchantsStatus == WalletLoadStatus.loading,
        walletItems: walletState.favoriteMerchants,
        onExpand: () =>
            context.read<WalletBloc>().add(const LoadFavoriteMerchants()),
      );
    },
  );
}
