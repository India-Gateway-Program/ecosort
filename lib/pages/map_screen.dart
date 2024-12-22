import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/location_provider.dart';

class MapScreen extends ConsumerWidget {
  MapScreen({super.key});

  final mapController = MapController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    double latitude = 12.9716;
    double longitude = 77.5946;

    if (locationState.latitude != null && locationState.longitude != null) {
      latitude = locationState.latitude!;
      longitude = locationState.longitude!;
    }

    ref.listen<LocationData?>(locationProvider, (previous, next) {
      if (next != null && next.latitude != null && next.longitude != null) {
        mapController.move(LatLng(next.latitude!, next.longitude!), 15);
      }
    });

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(latitude, longitude),
        initialZoom: 9.2,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        CurrentLocationLayer(),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () async {
              await ref.read(locationProvider.notifier).getLocation();
            }, // (external)
            child: locationState.isLoading
                ? const CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
