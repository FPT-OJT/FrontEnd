import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/ai/presentation/constants/ai_text.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({
    required this.onSend,
    this.disabled = false,
    super.key,
  });

  final void Function(String message) onSend;
  final bool disabled;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty || widget.disabled) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: UIGaps.size16,
      vertical: UIGaps.size12,
    ),
    decoration: const BoxDecoration(
      color: AppColors.neutralWhite,
      boxShadow: [
        BoxShadow(
          color: AppColors.shadowNavyA10,
          blurRadius: 12,
          offset: Offset(0, -2),
        ),
      ],
    ),
    child: SafeArea(
      top: false,
      child: Row(
        spacing: UIGaps.size8,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.neutralEggShell20,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.disabled
                      ? AppColors.neutralGrey.withValues(alpha: 0.4)
                      : AppColors.neutralGrey.withValues(alpha: 0.6),
                ),
              ),
              child: TextField(
                controller: _controller,
                enabled: !widget.disabled,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest,
                ),
                decoration: InputDecoration(
                  hintText: widget.disabled
                      ? AiText.typingIndicator
                      : AiText.inputHint,
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutralGrey,
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: UIGaps.size16,
                    vertical: UIGaps.size10,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (_hasText && !widget.disabled)
                  ? AppColors.primaryForest
                  : AppColors.neutralGrey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: (_hasText && !widget.disabled) ? _handleSend : null,
              icon: const Icon(Icons.send_rounded, size: 20),
              color: (_hasText && !widget.disabled)
                  ? AppColors.primaryMint
                  : AppColors.neutralGrey,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    ),
  );
}
