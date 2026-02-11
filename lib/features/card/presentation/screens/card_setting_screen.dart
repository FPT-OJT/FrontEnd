import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_bloc.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/header_card_setting.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_section.dart';

class CardSettingScreen extends StatelessWidget {
  const CardSettingScreen({required this.cardId, super.key});
  final String cardId;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) =>
        serviceLocator<SettingCardBloc>()..add(OnCardSettingLoadEvent(cardId)),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryForest,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.primaryForest,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: BlocBuilder<SettingCardBloc, SettingCardState>(
          builder: (context, state) {
            if (state.settingStatus == SettingCardStateStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryForest,
                ),
              );
            }

            if (state.settingStatus == SettingCardStateStatus.failure) {
              return Center(
                child: Text(
                  state.errorMessage ?? 'Failed to load card details',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.secondaryCoral,
                  ),
                ),
              );
            }

            final cardDetail = state.cardDetail;

            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                color: AppColors.primaryForest,
                child: Column(
                  children: [
                    HeaderCardSetting(imageUrl: cardDetail?.cardImageUrl),
                    UIGaps.h24,
                    _ContentSection(
                      cardId: cardId,
                      firstPaymentDate: cardDetail?.firstPaymentDate,
                      expiryDate: cardDetail?.expiryDate,
                      warningMessage: state.warningMessage,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

class _ContentSection extends StatelessWidget {
  const _ContentSection({
    required this.cardId,
    this.firstPaymentDate,
    this.expiryDate,
    this.warningMessage,
  });
  final String cardId;
  final int? firstPaymentDate;
  final DateTime? expiryDate;
  final String? warningMessage;

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
    child: SettingSection(
      cardId: cardId,
      firstPaymentDate: firstPaymentDate,
      expiryDate: expiryDate,
      warningMessage: warningMessage,
    ),
  );
}
