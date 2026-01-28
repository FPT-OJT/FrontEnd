import 'package:flutter/material.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';

class NavigationItem {
  NavigationItem({
    required this.icon,
    required this.label,
    required this.routePath,
  });
  final IconData icon;
  final String label;
  final String routePath;
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });
  final List<NavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  // Colors from your design
  static const _activeColor = AppColors.secondaryCoral; 
  static const _inactiveColor = AppColors.primaryForest; 
  static const _bgColor = Colors.white;

  @override
  Widget build(BuildContext context) => Container(
    height: 80 + MediaQuery.of(context).padding.bottom / 2,
    decoration: const BoxDecoration(
      color: _bgColor,
      border: Border(top: BorderSide(color: AppColors.neutralEggShell40)),
    ),
    child: Column(
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isActive = index == currentIndex;

            return GestureDetector(
              onTap: () => onTap(index),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Icon(
                        item.icon,
                        size: 28,
                        color: isActive ? _activeColor : _inactiveColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: AppTextStyles.textLink.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive ? _activeColor : _inactiveColor,
                      ),
                      child: Text(item.label),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const Spacer(),
        Container(
          width: 134,
          height: 5,
          decoration: BoxDecoration(
            color: AppColors.neutralEggShell40,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
