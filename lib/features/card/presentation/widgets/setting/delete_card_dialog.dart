import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_bloc.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';
import 'package:go_router/go_router.dart';

class DeleteCardDialog extends StatelessWidget {
  const DeleteCardDialog({required this.userCardId, this.imageUrl, super.key});

  final String userCardId;
  final String? imageUrl;

  @override
  Widget build(
    BuildContext context,
  ) => BlocConsumer<SettingCardBloc, SettingCardState>(
    listener: (context, state) {
      if (state.settingStatus == SettingCardStateStatus.deleted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Card removed successfully'),
            backgroundColor: AppColors.secondaryGreen,
          ),
        );
        context.go(RouteNames.wallet);
      } else if (state.settingStatus == SettingCardStateStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage ?? 'Failed to remove card'),
            backgroundColor: AppColors.notifyError,
          ),
        );
      }
    },
    builder: (context, state) {
      final isDeleting = state.settingStatus == SettingCardStateStatus.deleting;

      return Dialog(
        backgroundColor: AppColors.neutralEggShell20,
        shape: RoundedRectangleBorder(borderRadius: Rounded.md),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                CardText.deleteCardTitle,
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.primaryForest,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (imageUrl != null && imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: Rounded.md,
                  child: Image.network(
                    imageUrl!,
                    width: 250,
                    height: 142,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 250,
                      height: 142,
                      decoration: BoxDecoration(
                        color: AppColors.neutralGrey.withValues(alpha: 0.2),
                        borderRadius: Rounded.md,
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        size: 60,
                        color: AppColors.primaryForest,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 250,
                  height: 142,
                  decoration: BoxDecoration(
                    color: AppColors.neutralGrey.withValues(alpha: 0.2),
                    borderRadius: Rounded.md,
                  ),
                  child: const Icon(
                    Icons.credit_card,
                    size: 60,
                    color: AppColors.primaryForest,
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: UIGaps.size48,
                child: ElevatedButton(
                  onPressed: isDeleting
                      ? null
                      : () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.neutralWhite,
                    foregroundColor: AppColors.secondaryCoral,
                    shape: RoundedRectangleBorder(
                      borderRadius: Rounded.md,
                      side: const BorderSide(
                        color: AppColors.secondaryCoral,
                        width: Borders.sm,
                      ),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.neutralWhite.withValues(alpha: 0.5),
                  ),
                  child: Text(
                    CardText.deleteCardButtonNo,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryCoral,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: UIGaps.size48,
                child: ElevatedButton(
                  onPressed: isDeleting
                      ? null
                      : () => context.read<SettingCardBloc>().add(
                          OnCardSettingDeleteEvent(userCardId),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondaryCoral,
                    foregroundColor: AppColors.neutralWhite,
                    shape: RoundedRectangleBorder(borderRadius: Rounded.md),
                    elevation: 0,
                    disabledBackgroundColor: AppColors.secondaryCoralDisabled,
                  ),
                  child: isDeleting
                      ? const SizedBox(
                          height: UIGaps.size20,
                          width: UIGaps.size20,
                          child: CircularProgressIndicator(
                            strokeWidth: Borders.xs,
                            color: AppColors.neutralWhite,
                          ),
                        )
                      : Text(
                          CardText.deleteCardButtonYes,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neutralWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
