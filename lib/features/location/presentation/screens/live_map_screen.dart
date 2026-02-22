import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/geofence/geofence_state.dart';
import 'package:fpt_ojt/features/location/blocs/location_bloc.dart';
import 'package:fpt_ojt/features/location/blocs/location_event.dart';
import 'package:fpt_ojt/features/location/blocs/location_state.dart';
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
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Vị trí hiện tại'), centerTitle: true),
    body: BlocBuilder<GeofenceBloc, GeofenceState>(
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
                    'Lỗi: ${state.errorMessage ?? "Không thể lấy vị trí"}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LocationBloc>().add(
                        const LocationRequested(),
                      );
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (state.current == null) {
            return const Center(child: Text('Đang chờ vị trí...'));
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
                        const Text(
                          'Vị trí của bạn',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
                                style: const TextStyle(fontSize: 14),
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
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  geofenceState.message!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: geofenceState.activeAgencyId != null
                                        ? Colors.green
                                        : Colors.grey,
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
                                '${geofenceState.geofences.length} địa điểm',
                                style: const TextStyle(fontSize: 14),
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
}
