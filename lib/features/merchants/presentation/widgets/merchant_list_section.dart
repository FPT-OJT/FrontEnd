import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/core/theme/ui_gaps.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_agency.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_bloc.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_event.dart';
import 'package:fpt_ojt/features/merchants/presentation/blocs/merchant_search/merchant_search_state.dart';
import 'package:fpt_ojt/features/merchants/presentation/constants/merchant_text.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class MerchantListSection extends StatelessWidget {
  const MerchantListSection({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<MerchantSearchBloc, MerchantSearchState>(
        builder: (context, state) {
          if (state.isLoading) return const _LoadingList();

          if (!state.hasQuery) {
            return _RecentSearchSection(items: state.recentSearches);
          }

          if (state.results.isEmpty) {
            return _EmptyResult(query: state.query);
          }

          return _ResultSection(query: state.query, items: state.results);
        },
      );
}

class _RecentSearchSection extends StatelessWidget {
  const _RecentSearchSection({required this.items});

  final List<MerchantAgency> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: UIGaps.size12,
    children: [
      Text(
        MerchantText.merchantListTitleNoSearch,
        style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
      ),
      if (items.isEmpty)
        Padding(
          padding: const EdgeInsets.only(top: UIGaps.size8),
          child: Text(
            MerchantText.noRecentSearches,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primaryForest.withValues(alpha: 0.5),
            ),
          ),
        )
      else
        ...items.map(
          (agency) => _MerchantRow(agency: agency, showDistance: true),
        ),
    ],
  );
}

class _ResultSection extends StatelessWidget {
  const _ResultSection({required this.query, required this.items});

  final String query;
  final List<MerchantAgency> items;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: UIGaps.size12,
    children: [
      RichText(
        text: TextSpan(
          style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
          children: [
            const TextSpan(text: '${MerchantText.merchantListTitleHasSearch} '),
            TextSpan(
              text: '"$query"',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primaryForest,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      ...items.map(
        (agency) => _MerchantRow(agency: agency, showDistance: true),
      ),
    ],
  );
}

class _EmptyResult extends StatelessWidget {
  const _EmptyResult({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
          children: [
            const TextSpan(text: '${MerchantText.merchantListTitleHasSearch} '),
            TextSpan(
              text: '"$query"',
              style: AppTextStyles.h3.copyWith(
                color: AppColors.primaryForest,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
      UIGaps.h32,
      Center(
        child: Column(
          spacing: UIGaps.size16,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: AppColors.primaryForest.withValues(alpha: 0.4),
            ),
            Text(
              MerchantText.emptyResultTitle,
              style: AppTextStyles.h3.copyWith(color: AppColors.primaryForest),
              textAlign: TextAlign.center,
            ),
            Text(
              MerchantText.emptyResultSubtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primaryForest.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryForest.withValues(alpha: 0.6),
                ),
                children: [
                  const TextSpan(text: MerchantText.contactUs),
                  TextSpan(
                    text: MerchantText.contactUsHere,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.secondaryCoral,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

// ──────────────────────────────────────────────
// Single merchant row
// ──────────────────────────────────────────────

class _MerchantRow extends StatelessWidget {
  const _MerchantRow({required this.agency, this.showDistance = false});

  final MerchantAgency agency;
  final bool showDistance;

  static const double _logoSize = 44;
  static const double _kMetersPerKm = 1000;

  String _formatDistance(double? meters) {
    if (meters == null) return '';
    if (meters >= _kMetersPerKm) {
      return '${(meters / _kMetersPerKm).toStringAsFixed(1)}km';
    }
    return '${meters.toStringAsFixed(0)}m';
  }

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: Rounded.md,
    onTap: () {
      context.read<MerchantSearchBloc>().add(
        MerchantSearchResultTapped(agency: agency),
      );
      context.push(RouteNames.generateMerchantDetailRoute(agency.id));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: UIGaps.size8),
      child: Row(
        spacing: UIGaps.size12,
        children: [
          _AgencyLogo(imageUrl: agency.merchant.logoUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: UIGaps.size4,
              children: [
                Text(
                  agency.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryForest,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  agency.merchant.description,
                  style: AppTextStyles.bodyExtraSmall.copyWith(
                    color: AppColors.primaryForest.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showDistance && agency.distance != null)
            Text(
              _formatDistance(agency.distance),
              style: AppTextStyles.bodyExtraSmall.copyWith(
                color: AppColors.primaryForest.withValues(alpha: 0.5),
              ),
            ),
        ],
      ),
    ),
  );
}

class _AgencyLogo extends StatelessWidget {
  const _AgencyLogo({required this.imageUrl});

  final String imageUrl;

  static const double size = 44;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: AppColors.neutralEggShell40,
      borderRadius: Rounded.sm,
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadowNavyA10,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: imageUrl.isNotEmpty
        ? Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const _FallbackIcon(),
          )
        : const _FallbackIcon(),
  );
}

class _FallbackIcon extends StatelessWidget {
  const _FallbackIcon();

  @override
  Widget build(BuildContext context) =>
      const Icon(Icons.store_rounded, size: 24, color: AppColors.primaryForest);
}

// ──────────────────────────────────────────────
// Loading skeleton
// ──────────────────────────────────────────────

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.neutralEggShell40,
    highlightColor: AppColors.neutralEggShell20,
    child: Column(
      spacing: UIGaps.size16,
      children: List.generate(
        5,
        (_) => Row(
          spacing: UIGaps.size12,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: Rounded.sm,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: UIGaps.size8,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Rounded.xs,
                    ),
                  ),
                  Container(
                    height: 12,
                    width: 160,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: Rounded.xs,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
