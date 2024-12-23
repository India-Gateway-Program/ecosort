import 'package:ecosort/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      loading: () {},
      error: (error, stackTrace) {
        // TODO: Show an error message
      },
    );

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
        locationState.when(
          data: (locationData) {
            return CurrentLocationLayer();
          },
          loading: () {
            return Container();
          },
          error: (error, stack) {
            return Container();
          },
        ),
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
          error: (error, stack) {
            return Container();
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppColors.primaryColor,
            onPressed: () async {
              try {
                final locationState = await ref.read(locationProvider.future);
                if (locationState.latitude != null &&
                    locationState.longitude != null) {
                  mapController.move(
                      LatLng(locationState.latitude!, locationState.longitude!),
                      15);
                } else {
                  // TODO: Show an error message
                }
              } catch (e) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              }
            },
            child: locationState.when(
                data: (locationData) =>
                    const Icon(Icons.my_location, color: Colors.white),
                loading: () {
                  return Icon(Icons.location_searching, color: Colors.white);
                },
                error: (error, stack) {
                  return const Icon(Icons.location_disabled, color: Colors.red);
                }),
          ),
        ),
      ],
    );
  }
}
