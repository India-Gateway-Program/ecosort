import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../providers/location_provider.dart';
import '../providers/recycling_places_provider.dart';

class MapScreen extends ConsumerWidget {
  MapScreen({super.key});

  final mapController = MapController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);
    final recyclingPlaces = ref.watch(recyclingPlacesProvider);

    double latitude = 12.9716; // Default latitude
    double longitude = 77.5946; // Default longitude

    locationState.when(
      data: (locationData) {
        if (locationData.latitude != null && locationData.longitude != null) {
          latitude = locationData.latitude!;
          longitude = locationData.longitude!;
        }
      },
      loading: () {
        // TODO: Show a loading indicator
      },
      error: (error, stackTrace) {
        // TODO: Show an error message
      },
    );

    ref.listen<AsyncValue<LocationData>>(locationProvider, (previous, next) {
      next.when(
        data: (locationData) {
          if (locationData.latitude != null && locationData.longitude != null) {
            mapController.move(
                LatLng(locationData.latitude!, locationData.longitude!), 15);
          }
        },
        loading: () {},
        error: (error, stack) {},
      );
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
        recyclingPlaces.when(
          data: (places) {
            return MarkerLayer(
              markers: places.map((place) {
                return Marker(
                  point: LatLng(place.lat, place.lon),
                  child: const Icon(
                    Icons.recycling,
                    color: Colors.green,
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () async {
              final locationState = await ref.read(locationProvider.future);

              if (locationState.latitude != null &&
                  locationState.longitude != null) {
                mapController.move(
                    LatLng(locationState.latitude!, locationState.longitude!),
                    15);
              } else {
              // TODO: Show an error message
              }
            },
            child: locationState.maybeWhen(
              data: (locationData) =>
                  const Icon(Icons.my_location, color: Colors.white),
              orElse: () => const CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
