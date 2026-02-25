import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_bloc.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_event.dart';
import 'package:fpt_ojt/features/ai/presentation/constants/ai_text.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';

class SuggestionChips extends StatelessWidget {
  const SuggestionChips({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: UIGaps.size12,
    children: [
      Text(
        AiText.suggestionsLabel,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primaryForest.withValues(alpha: 0.6),
          fontWeight: FontWeight.w600,
        ),
      ),
      Wrap(
        spacing: UIGaps.size8,
        runSpacing: UIGaps.size8,
        children: AiText.suggestions
            .map((s) => _SuggestionChip(label: s))
            .toList(),
      ),
    ],
  );
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () {
      final fullName = context.read<AuthBloc>().state is AuthLoggedIn
          ? (context.read<AuthBloc>().state as AuthLoggedIn).user.fullName
          : null;
      final currentLocation = context.read<LocationBloc>().state.current;
      final latitude = currentLocation?.latitude;
      final longitude = currentLocation?.longitude;
      context.read<AiChatBloc>().add(
        AiChatSuggestionTapped(
          suggestion: label,
          fullName: fullName,
          latitude: latitude,
          longitude: longitude,
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: UIGaps.size12,
        vertical: UIGaps.size8,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryMint.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.primaryMint, width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primaryForest,
          fontSize: 13,
        ),
      ),
    ),
  );
}
