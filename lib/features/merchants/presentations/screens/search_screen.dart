import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/presentations/widgets/search_input_text_field.dart';
import 'package:go_router/go_router.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: AppColors.primaryForest,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: UIGaps.size20),
                child: Column(
                  children: [
                    UIGaps.h60,
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.neutralWhite.withValues(
                              alpha: 0.3,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              context.pop();
                            },
                          ),
                        ),
                        UIGaps.w24,
                        const Expanded(child: SearchInputTextField()),
                      ],
                    ),
                  ],
                ),
              ),
              UIGaps.h24,
            ],
          ),
        ),
      ),
    ),
  );
}
