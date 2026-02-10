import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/di/init_dependencies.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/borders.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/card/domain/usecases/is_card_exist_in_user_usecase.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/details/detail_card_bloc.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/details/detail_card_event.dart';
import 'package:fpt_ojt/features/card/presentation/bloc/details/detail_card_state.dart';
import 'package:fpt_ojt/features/card/presentation/constants/card_text.dart';
import 'package:go_router/go_router.dart';

class CardDetailBottomSheet extends StatefulWidget {
  const CardDetailBottomSheet({
    required this.cardId,
    required this.cardName,
    required this.imageUrl,
    super.key,
  });
  final String cardId;
  final String cardName;
  final String imageUrl;

  @override
  State<CardDetailBottomSheet> createState() => _CardDetailBottomSheetState();
}

class _CardDetailBottomSheetState extends State<CardDetailBottomSheet> {
  bool? _isCardExist;
  bool _isCheckingExistence = true;

  @override
  void initState() {
    super.initState();
    _checkCardExistence();
  }

  Future<void> _checkCardExistence() async {
    final usecase = serviceLocator<IsCardExistInUserUsecase>();
    final result = await usecase(
      IsCardExistInUserParams(cardId: widget.cardId),
    );

    result.fold(
      (failure) {
        setState(() {
          _isCardExist = false;
          _isCheckingExistence = false;
        });
      },
      (exists) {
        setState(() {
          _isCardExist = exists;
          _isCheckingExistence = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => serviceLocator<DetailCardBloc>(),
    child: Container(
      padding: const EdgeInsets.only(top: 50, left: 30, right: 30, bottom: 50),
      decoration: const BoxDecoration(
        color: AppColors.neutralEggShell20,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: _isCheckingExistence
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isCardExist ?? false
                      ? CardText.cardDetailTitle
                      : CardText.cardDetailTitleExist,
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.primaryForest,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (widget.imageUrl.isNotEmpty)
                  Image.network(
                    widget.imageUrl,
                    width: 335,
                    height: 190,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 350,
                      height: 200,
                      decoration: BoxDecoration(
                        color: AppColors.neutralGrey.withOpacity(0.2),
                        borderRadius: Rounded.md,
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        size: 80,
                        color: AppColors.primaryForest,
                      ),
                    ),
                  )
                else
                  Container(
                    width: 335,
                    height: 190,
                    decoration: BoxDecoration(
                      color: AppColors.neutralGrey.withOpacity(0.2),
                      borderRadius: Rounded.md,
                    ),
                    child: const Icon(
                      Icons.credit_card,
                      size: 80,
                      color: AppColors.primaryForest,
                    ),
                  ),
                const SizedBox(height: 20),
                _buildButton1(context),
                const SizedBox(height: 20),
                _buildButton2(context),
              ],
            ),
    ),
  );

  Widget _buildButton1(BuildContext context) => SizedBox(
    width: double.infinity,
    height: UIGaps.size48,
    child: ElevatedButton(
      onPressed: () => context.pop(),
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
      child: Text(
        _isCardExist ?? false ? CardText.button1Exist : CardText.button1,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.secondaryCoral,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  Widget _buildButton2(BuildContext context) =>
      BlocConsumer<DetailCardBloc, DetailCardState>(
        listener: (context, state) {
          if (state.detailStatus == DetailCardLoadStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Card added successfully!'),
                backgroundColor: AppColors.secondaryGreen,
              ),
            );
            context.pop();
          } else if (state.detailStatus == DetailCardLoadStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Failed to add card'),
                backgroundColor: AppColors.notifyError,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.detailStatus == DetailCardLoadStatus.loading;
          return SizedBox(
            width: double.infinity,
            height: UIGaps.size48,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_isCardExist ?? false) {
                        context.pop();
                        context.go(RouteNames.wallet);
                      } else {
                        // Add card
                        context.read<DetailCardBloc>().add(
                          OnCardAddEvent(widget.cardId),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryCoral,
                foregroundColor: AppColors.neutralWhite,
                shape: RoundedRectangleBorder(borderRadius: Rounded.md),
                elevation: 0,
                disabledBackgroundColor: AppColors.secondaryCoralDisabled,
              ),
              child: isLoading
                  ? const SizedBox(
                      height: UIGaps.size20,
                      width: UIGaps.size20,
                      child: CircularProgressIndicator(
                        strokeWidth: Borders.xs,
                        color: AppColors.neutralWhite,
                      ),
                    )
                  : Text(
                      _isCardExist ?? false
                          ? CardText.button2Exist
                          : CardText.button2,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.neutralWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          );
        },
      );
}
