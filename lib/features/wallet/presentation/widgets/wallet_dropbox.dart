import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/features/wallet/domain/entities/wallet_item.dart';
import 'package:fpt_ojt/features/wallet/presentation/widgets/wallet_item_skeleton.dart';
import 'package:go_router/go_router.dart';

class WalletDropbox extends StatefulWidget {
  const WalletDropbox({
    required this.name,
    required this.iconUrl,
    required this.walletItems,
    this.isCard = false,
    this.isLoading = false,
    this.onExpand,
    this.onAddNew,
    super.key,
  });

  final String name;
  final String iconUrl;
  final bool isCard;
  final bool isLoading;
  final List<WalletItem> walletItems;
  final VoidCallback? onExpand;
  final VoidCallback? onAddNew;

  static const double otherItemSize = 83;
  static const double cardItemHeight = 85;
  static const double cardItemWidth = 131;

  @override
  State<WalletDropbox> createState() => _WalletDropboxState();
}

class _WalletDropboxState extends State<WalletDropbox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: Colors.transparent,
      border: Border(bottom: BorderSide(color: AppColors.primaryForest)),
    ),
    padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
              if (_isExpanded) {
                widget.onExpand?.call();
              }
            });
          },
          child: Row(
            children: [
              SvgPicture.asset(widget.iconUrl, width: 24, height: 24),
              const SizedBox(width: 8),
              Expanded(child: Text(widget.name)),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.primaryForest,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Container(
                  color: (widget.isLoading || widget.walletItems.isNotEmpty)
                      ? AppColors.neutralEggShell60
                      : Colors.transparent,
                  padding: (widget.isLoading || widget.walletItems.isNotEmpty)
                      ? const EdgeInsets.all(8)
                      : EdgeInsets.zero,
                  width: double.infinity,
                  child: Column(
                    children: [
                      if (widget.isLoading)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(
                            2,
                            (_) => WalletItemSkeleton(isCard: widget.isCard),
                          ),
                        )
                      else
                        widget.walletItems.isNotEmpty
                            ? Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: widget.walletItems
                                    .where((item) => item.imageUrl != null)
                                    .map(
                                      (item) => ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          item.imageUrl!,
                                          width: widget.isCard
                                              ? WalletDropbox.cardItemWidth
                                              : WalletDropbox.otherItemSize,
                                          height: widget.isCard
                                              ? WalletDropbox.cardItemHeight
                                              : WalletDropbox.otherItemSize,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    width: widget.isCard
                                                        ? WalletDropbox
                                                              .cardItemWidth
                                                        : WalletDropbox
                                                              .otherItemSize,
                                                    height: widget.isCard
                                                        ? WalletDropbox
                                                              .cardItemHeight
                                                        : WalletDropbox
                                                              .otherItemSize,
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.error,
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : const SizedBox.shrink(),
                      if (!widget.isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: SizedBox(
                            width: double.infinity,
                            // height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                context.push(RouteNames.cardSearch);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryCoral,
                                foregroundColor: AppColors.neutralWhite,
                                shape: RoundedRectangleBorder(
                                  borderRadius: Rounded.md,
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Add new',
                                style: AppTextStyles.button,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    ),
  );
}
