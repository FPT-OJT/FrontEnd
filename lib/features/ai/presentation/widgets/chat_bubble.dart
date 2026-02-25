import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/ai/domain/entities/ai_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({required this.message, super.key});

  final AiMessage message;

  @override
  Widget build(BuildContext context) => message.isUser
        ? _UserBubble(message: message)
        : _BotBubble(message: message);
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.message});

  final AiMessage message;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: UIGaps.size16,
        vertical: UIGaps.size12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primaryForest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Text(
        message.content,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.neutralWhite),
      ),
    ),
  );
}

class _BotBubble extends StatelessWidget {
  const _BotBubble({required this.message});

  final AiMessage message;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: UIGaps.size8,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryMint.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: AppColors.primaryMint,
          ),
        ),
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.82,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: UIGaps.size16,
              vertical: UIGaps.size12,
            ),
            decoration: const BoxDecoration(
              color: AppColors.neutralWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowNavyA10,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: MarkdownBody(
              data: message.content,
              styleSheet: MarkdownStyleSheet(
                p: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest,
                ),
                strong: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest,
                  fontWeight: FontWeight.w700,
                ),
                em: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest.withValues(alpha: 0.75),
                  fontStyle: FontStyle.italic,
                ),
                blockquote: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest.withValues(alpha: 0.7),
                ),
                blockquoteDecoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: AppColors.primaryMint,
                      width: 3,
                    ),
                  ),
                ),
                tableHead: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest,
                  fontWeight: FontWeight.w700,
                ),
                tableBody: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest,
                ),
                tableBorder: TableBorder.all(
                  color: AppColors.neutralGrey.withValues(alpha: 0.4),
                ),
                listBullet: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryMint,
                ),
                tableColumnWidth: const FlexColumnWidth(),
                blockSpacing: UIGaps.size8,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class TypingIndicatorBubble extends StatefulWidget {
  const TypingIndicatorBubble({super.key});

  @override
  State<TypingIndicatorBubble> createState() => _TypingIndicatorBubbleState();
}

class _TypingIndicatorBubbleState extends State<TypingIndicatorBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: UIGaps.size8,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryMint.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 16,
            color: AppColors.primaryMint,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: UIGaps.size16,
            vertical: UIGaps.size12,
          ),
          decoration: const BoxDecoration(
            color: AppColors.neutralWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowNavyA10,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            spacing: UIGaps.size4,
            children: List.generate(
              3,
              (i) => AnimatedBuilder(
                animation: _animation,
                builder: (_, __) => Opacity(
                  opacity: (_animation.value - i * 0.15).clamp(0.2, 1.0),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryMint,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
