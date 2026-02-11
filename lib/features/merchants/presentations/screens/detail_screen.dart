import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_state.dart';

class MerchantDetailScreen extends StatefulWidget {
  const MerchantDetailScreen({super.key, required this.merchantId});
  final String merchantId;

  @override
  State<MerchantDetailScreen> createState() => _MerchantDetailScreenState();
}

class _MerchantDetailScreenState extends State<MerchantDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MerchantDetailBloc>().add(
      MerchantDetailStarted(merchantId: widget.merchantId),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Merchant Detail')),
    body: BlocBuilder<MerchantDetailBloc, MerchantDetailState>(
      builder: (context, state) {
        if (state is MerchantDetailLoading || state is MerchantDetailInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is MerchantDetailError) {
          return Center(child: Text(state.error));
        }
        if (state is MerchantDetailLoaded) {
          return Center(child: Text(state.merchantDetail.agencyName));
        }
        return const Center(child: Text('Error'));
      },
    ),
  );
}
