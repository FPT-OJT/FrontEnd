import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/widgets/merchant_list_section.dart';
import 'package:fpt_ojt/features/merchants/presentation/widgets/search_input_text_field.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<MerchantSearchBloc>().add(const MerchantSearchStarted());
    _controller.addListener(() {
      context.read<MerchantSearchBloc>().add(
        MerchantSearchQueryChanged(query: _controller.text),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: const SystemUiOverlayStyle(
      statusBarColor: AppColors.primaryForest,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.primaryForest,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
    child: Scaffold(
      body: Column(
        children: [
          ColoredBox(
            color: AppColors.primaryForest,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: UIGaps.size20,
                  vertical: UIGaps.size16,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    UIGaps.w24,
                    Expanded(
                      child: SearchInputTextField(
                        controller: _controller,
                        onSubmitted: (value) => context
                            .read<MerchantSearchBloc>()
                            .add(MerchantSearchQueryChanged(query: value)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
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
              child: const SingleChildScrollView(child: MerchantListSection()),
            ),
          ),
        ],
      ),
    ),
  );
}
