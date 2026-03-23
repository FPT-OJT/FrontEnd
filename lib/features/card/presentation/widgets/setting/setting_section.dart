import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_bloc.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/setting/setting_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/delete_card_dialog.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_item_date.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_item_text.dart';
import 'package:fpt_ojt/features/card/presentation/widgets/setting/setting_warning_item.dart';
import 'package:go_router/go_router.dart';

class SettingSection extends StatefulWidget {
  const SettingSection({
    required this.cardId,
    this.firstPaymentDate,
    this.expiryDate,
    this.warningMessage,
    this.imageUrl,
    super.key,
  });

  final String cardId;
  final int? firstPaymentDate;
  final DateTime? expiryDate;
  final String? warningMessage;
  final String? imageUrl;

  @override
  State<SettingSection> createState() => _SettingSectionState();
}

class _SettingSectionState extends State<SettingSection> {
  bool _showWarning = true;
  int? _editedFirstPaymentDate;
  DateTime? _editedExpiryDate;

  void _onDataChanged() {
    context.read<SettingCardBloc>().add(const OnCardSettingDataChangedEvent());
  }

  void _onSavePressed(bool isDataChanged) {
    if (isDataChanged) {
      context.read<SettingCardBloc>().add(
        OnCardSettingUpdateEvent(
          widget.cardId,
          _editedFirstPaymentDate ?? widget.firstPaymentDate,
          _editedExpiryDate ?? widget.expiryDate,
        ),
      );
    } else {
      // Show delete dialog
      showDialog<void>(
        context: context,
        builder: (dialogContext) => BlocProvider.value(
          value: context.read<SettingCardBloc>(),
          child: DeleteCardDialog(
            userCardId: widget.cardId,
            imageUrl: widget.imageUrl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasWarning = widget.warningMessage != null && _showWarning;

    return BlocConsumer<SettingCardBloc, SettingCardState>(
      listener: (context, state) {
        if (state.settingStatus == SettingCardStateStatus.updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Card settings updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          context.go(RouteNames.wallet);
        } else if (state.settingStatus == SettingCardStateStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMessage ?? 'Failed to update card settings',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) => Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Warning item
          if (hasWarning) ...[
            SettingWarningItem(
              warningText: widget.warningMessage!,
              onClose: () {
                setState(() {
                  _showWarning = false;
                });
              },
            ),
            const SizedBox(height: 8),
          ],
          // Section title
          Text(
            'Card Settings',
            style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
          ),
          // Setting items
          SettingItemText(
            title: CardText.reminderSetting,
            description: CardText.reminderSettingDesc,
            datePickerTitle: 'Select reminder date',
            reminderDate: widget.firstPaymentDate,
            onChanged: (value) {
              setState(() {
                _editedFirstPaymentDate = value;
              });
              _onDataChanged();
            },
          ),
          SettingItemDate(
            title: CardText.expirySetting,
            description: CardText.expirySettingDesc,
            datePickerTitle: 'Select card expiry date',
            expiryDate: widget.expiryDate,
            onChanged: (value) {
              setState(() {
                _editedExpiryDate = value;
              });
              _onDataChanged();
            },
          ),
          const SizedBox(height: 8),
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: state.settingStatus == SettingCardStateStatus.updating
                  ? null
                  : () => _onSavePressed(state.isDataChanged),
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
              ),
              child: state.settingStatus == SettingCardStateStatus.updating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.secondaryCoral,
                      ),
                    )
                  : Text(
                      state.isDataChanged
                          ? CardText.settingButtonDataChanged
                          : CardText.settingButton,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.secondaryCoral,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
