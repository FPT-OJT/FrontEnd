import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_bloc.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_event.dart';
import 'package:fpt_ojt/features/ai/presentation/blocs/ai_chat/ai_chat_state.dart';
import 'package:fpt_ojt/features/ai/presentation/constants/ai_text.dart';
import 'package:fpt_ojt/features/ai/presentation/widgets/chat_bubble.dart';
import 'package:fpt_ojt/features/ai/presentation/widgets/chat_input_field.dart';
import 'package:fpt_ojt/features/ai/presentation/widgets/suggestion_chips.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:fpt_ojt/features/auth/presentation/blocs/auth/auth_state.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';

class AiScreens extends StatefulWidget {
  const AiScreens({super.key});

  @override
  State<AiScreens> createState() => _AiScreensState();
}

class _AiScreensState extends State<AiScreens> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AiChatBloc>().add(const AiChatStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
    child: Scaffold(
      backgroundColor: AppColors.neutralEggShell20,
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiChatBloc, AiChatState>(
              listener: (context, state) => _scrollToBottom(),
              builder: (context, state) {
                if (state.messages.isEmpty && !state.isGenerating) {
                  return _EmptyState();
                }
                return _ChatList(
                  state: state,
                  scrollController: _scrollController,
                );
              },
            ),
          ),
          BlocBuilder<AiChatBloc, AiChatState>(
            builder: (context, state) => ChatInputField(
              disabled: state.isGenerating,
              onSend: (message) {
                final fullName = context.read<AuthBloc>().state is AuthLoggedIn
                    ? (context.read<AuthBloc>().state as AuthLoggedIn)
                          .user
                          .fullName
                    : null;
                final currentLocation = context
                    .read<LocationBloc>()
                    .state
                    .current;
                final latitude = currentLocation?.latitude;
                final longitude = currentLocation?.longitude;
                context.read<AiChatBloc>().add(
                  AiChatMessageSent(
                    message: message,
                    fullName: fullName,
                    latitude: latitude,
                    longitude: longitude,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );

  PreferredSizeWidget _buildAppBar(BuildContext context) => AppBar(
    backgroundColor: AppColors.primaryForest,
    foregroundColor: AppColors.neutralWhite,
    elevation: 0,
    centerTitle: false,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      onPressed: () => Navigator.of(context).pop(),
    ),
    title: Row(
      spacing: UIGaps.size8,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryMint.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            size: 18,
            color: AppColors.primaryMint,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AiText.screenTitle,
              style: AppTextStyles.h3.copyWith(color: AppColors.neutralWhite),
            ),
            Text(
              AiText.appBarSubtitle,
              style: AppTextStyles.bodyExtraSmall.copyWith(
                color: AppColors.primaryMint.withValues(alpha: 0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(UIGaps.size24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UIGaps.h24,
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primaryForest,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryForest.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 36,
              color: AppColors.primaryMint,
            ),
          ),
        ),
        UIGaps.h20,
        Center(
          child: Text(
            AiText.greetingTitle,
            style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
            textAlign: TextAlign.center,
          ),
        ),
        UIGaps.h8,
        Center(
          child: Text(
            AiText.greetingSubtitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryForest.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        UIGaps.h32,
        const SuggestionChips(),
      ],
    ),
  );
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.state, required this.scrollController});

  final AiChatState state;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) => ListView.separated(
    controller: scrollController,
    padding: const EdgeInsets.symmetric(
      horizontal: UIGaps.size16,
      vertical: UIGaps.size20,
    ),
    itemCount: state.messages.length + (state.isGenerating ? 1 : 0),
    separatorBuilder: (_, __) => UIGaps.h12,
    itemBuilder: (context, index) {
      if (index == state.messages.length && state.isGenerating) {
        return const TypingIndicatorBubble();
      }
      return ChatBubble(message: state.messages[index]);
    },
  );
}
