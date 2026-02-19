import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
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
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Current Location'), centerTitle: true),
    body: BlocConsumer<LocationBloc, LocationState>(
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
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<LocationBloc>().add(const LocationRequested());
                  },
                  child: const Text('Try again'),
                ),
              ],
            ),
          );
        }

        if (state.current == null) {
          return const Center(child: Text('Waiting for location...'));
        }

        final currentPosition = LatLng(
          state.current!.latitude,
          state.current!.longitude,
        );

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
                  urlTemplate: const String.fromEnvironment('TILE_URL'),
                  userAgentPackageName: 'com.fpt.ojt',
                ),
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
                        'Your location',
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
                      LatLng(state.current!.latitude, state.current!.longitude),
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
  );
}
