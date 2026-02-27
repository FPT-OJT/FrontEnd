import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpt_ojt/app/router/route_names.dart';
import 'package:fpt_ojt/core/theme/app_colors.dart';
import 'package:fpt_ojt/core/theme/app_text_styles.dart';
import 'package:fpt_ojt/core/theme/rounded.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_event.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_state.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_event.dart';
import 'package:fpt_ojt/features/location/blocs/location_state.dart';
import 'package:fpt_ojt/features/merchants/domain/entities/merchant_deal_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

class LiveMapScreen extends StatefulWidget {
  const LiveMapScreen({super.key});

  @override
  State<LiveMapScreen> createState() => _LiveMapScreenState();
}

class _LiveMapScreenState extends State<LiveMapScreen> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    context.read<LocationBloc>().add(const LocationStarted());
    context.read<GeofenceBloc>().add(const GeofenceEvent.started());
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Current Location'), centerTitle: true),
    body: BlocConsumer<GeofenceBloc, GeofenceState>(
      listener: (context, geofenceState) {
        if (geofenceState.isOpenDealDetails && 
            geofenceState.selectedDeals.isNotEmpty) {
          _showDealCarouselDialog(context, geofenceState);
        }
      },
      builder: (context, geofenceState) => BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state.status == LoadStatus.success && state.current != null) {
            _mapController.move(
              LatLng(state.current!.latitude, state.current!.longitude),
              15,
            );
          }
        },
        builder: (context, state) {
          if (state.status == LoadStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LoadStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.errorMessage ?? "Cannot get location"}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LocationBloc>().add(
                        const LocationRequested(),
                      );
                    },
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          if (state.current == null) {
            return Center(
              child: Text(
                'Waiting for location...',
                style: AppTextStyles.bodyLarge,
              ),
            );
          }

          final currentPosition = LatLng(
            state.current!.latitude,
            state.current!.longitude,
          );
          debugPrint('length of geofences: ${geofenceState.geofences.length}');
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentPosition,
                  initialZoom: 15,
                  minZoom: 5,
                  maxZoom: 18,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}{r}.png',
                    subdomains: const ['a', 'b', 'c', 'd'],
                    userAgentPackageName: 'com.fpt.ojt',
                  ),
                  // Hiển thị các geofence
                  if (geofenceState.geofences.isNotEmpty)
                    CircleLayer(
                      circles: geofenceState.geofences.map((geofence) {
                        final isActive =
                            geofenceState.activeAgencyId == geofence.id;
                        return CircleMarker(
                          point: LatLng(geofence.latitude, geofence.longitude),
                          radius: geofence.radius,
                          color: isActive
                              ? Colors.green.withValues(alpha: 0.2)
                              : Colors.orange.withValues(alpha: 0.1),
                          borderColor: isActive ? Colors.green : Colors.orange,
                          borderStrokeWidth: 2,
                        );
                      }).toList(),
                    ),
                  // Marker cho các geofence
                  if (geofenceState.geofences.isNotEmpty)
                    MarkerLayer(
                      markers: geofenceState.geofences.map((geofence) {
                        final isActive =
                            geofenceState.activeAgencyId == geofence.id;
                        return Marker(
                          width: 40,
                          height: 40,
                          point: LatLng(geofence.latitude, geofence.longitude),
                          child: Icon(
                            Icons.business,
                            color: isActive ? Colors.green : Colors.orange,
                            size: 32,
                          ),
                        );
                      }).toList(),
                    ),
                  // Vị trí hiện tại
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 80,
                        height: 80,
                        point: currentPosition,
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                  CircleLayer(
                    circles: [
                      CircleMarker(
                        point: currentPosition,
                        radius: 50,
                        color: Colors.blue.withValues(alpha: 0.3),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2,
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Your Location',
                          style: AppTextStyles.h3,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Lat: ${state.current!.latitude.toStringAsFixed(6)}, '
                                'Lng: ${state.current!.longitude.toStringAsFixed(6)}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ),
                          ],
                        ),
                        if (geofenceState.message != null) ...[
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                geofenceState.activeAgencyId != null
                                    ? Icons.check_circle
                                    : Icons.info,
                                size: 16,
                                color: geofenceState.activeAgencyId != null
                                    ? AppColors.notifySuccess
                                    : AppColors.neutralGrey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  geofenceState.message!,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: geofenceState.activeAgencyId != null
                                        ? AppColors.notifySuccess
                                        : AppColors.neutralGrey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (geofenceState.geofences.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.business, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${geofenceState.geofences.length} locations',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    if (state.current != null) {
                      _mapController.move(
                        LatLng(
                          state.current!.latitude,
                          state.current!.longitude,
                        ),
                        15,
                      );
                    }
                  },
                  child: const Icon(Icons.my_location),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  void _showDealCarouselDialog(BuildContext context, GeofenceState state) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: Rounded.lg,
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 550),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryForest,
                  borderRadius: BorderRadius.only(
                    topLeft: Rounded.lg.topLeft,
                    topRight: Rounded.lg.topRight,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Available Deals',
                      style: AppTextStyles.h3.copyWith(
                        color: AppColors.neutralWhite,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.neutralWhite,
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        context.read<GeofenceBloc>().add(
                          const GeofenceEvent.closeDealDetails(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CarouselSlider.builder(
                  itemCount: state.selectedDeals.length,
                  options: CarouselOptions(
                    height: 450,
                    viewportFraction: 0.85,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: state.selectedDeals.length > 1,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    final deal = state.selectedDeals[index];
                    return _buildDealCard(dialogContext, deal);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, MerchantDealDetail deal) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: Rounded.lg,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (deal.logoUrl.isNotEmpty)
                      Center(
                        child: ClipRRect(
                          borderRadius: Rounded.md,
                          child: Image.network(
                            deal.logoUrl,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.neutralEggShell,
                                  borderRadius: Rounded.md,
                                ),
                                child: const Icon(
                                  Icons.store,
                                  size: 40,
                                  color: AppColors.primaryForest,
                                ),
                              ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        deal.merchantName,
                        style: AppTextStyles.h2.copyWith(
                          color: AppColors.primaryForest,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryMint.withValues(alpha: 0.2),
                          borderRadius: Rounded.sm,
                        ),
                        child: Text(
                          deal.dealName,
                          style: AppTextStyles.title.copyWith(
                            color: AppColors.secondaryGreen,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      deal.description,
                      style: AppTextStyles.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    if (deal.discountRate > 0)
                      _buildBenefitRow(
                        Icons.discount,
                        'Discount',
                        '${deal.discountRate}%',
                        AppColors.secondaryCoral,
                      ),
                    if (deal.cashbackRate > 0)
                      _buildBenefitRow(
                        Icons.money,
                        'Cashback',
                        '${deal.cashbackRate}%',
                        AppColors.notifySuccess,
                      ),
                    if (deal.pointsMultiplier > 0)
                      _buildBenefitRow(
                        Icons.stars,
                        'Points',
                        'x${deal.pointsMultiplier}',
                        AppColors.primaryCoin,
                      ),
                    const SizedBox(height: 8),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppColors.neutralGrey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            deal.agencyName,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.read<GeofenceBloc>().add(
                    const GeofenceEvent.closeDealDetails(),
                  );
                  context.push(
                    RouteNames.generateMerchantDetailRoute(deal.agencyId),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryForest,
                  foregroundColor: AppColors.neutralWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: Rounded.md,
                  ),
                ),
                child: Text(
                  'View Details',
                  style: AppTextStyles.button.copyWith(
                    color: AppColors.neutralWhite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  Widget _buildBenefitRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
