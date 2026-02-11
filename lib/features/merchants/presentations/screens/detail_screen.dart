import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentations/blocs/merchant_detail/merchant_detail_event.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/agency_detail_section.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/card_options_section.dart';

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
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryForest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      body: Container(
        width: double.infinity,
        color: AppColors.primaryForest,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(
                    'https://eu-images.contentstack.com/v3/assets/bltea7aee2fca050a19/bltcc157be03a336644/6724e088ca36fb0e631eeb88/Starbucks-HOTC.jpg',
                  ),
                  fit: BoxFit.fitWidth,
                  colorFilter: ColorFilter.mode(
                    AppColors.primaryForest.withValues(alpha: 0.6), 
                    BlendMode.darken,
                  ),
                ),
              ),

              height: 180,
              padding: const EdgeInsets.only(
                left: UIGaps.size20,
                right: UIGaps.size20,
                top: UIGaps.size48,
                bottom: UIGaps.size20,
              ),
              child: const AgencyDetailSection(name: 'Starbucks New World'),
            ),
            const Expanded(
              child: SingleChildScrollView(child: _ContentSection()),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ContentSection extends StatelessWidget {
  const _ContentSection();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: UIGaps.size20,
      vertical: UIGaps.size20,
    ),
    decoration: const BoxDecoration(
      color: AppColors.neutralEggShell20,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    width: double.infinity,
    constraints: const BoxConstraints(minHeight: 700),
    child: const Column(
      spacing: UIGaps.size20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ CardOptionsSection()],
    ),
  );
}
