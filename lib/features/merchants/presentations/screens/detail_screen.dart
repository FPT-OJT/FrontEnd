import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_event.dart';

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
    context.read<MerchantDetailBloc>().add(MerchantDetailStarted(merchantId: widget.merchantId));
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Merchant Detail')));
}
