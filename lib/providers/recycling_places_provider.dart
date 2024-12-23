import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'location_provider.dart';

class RecyclingPlace {
  final double lat;
  final double lon;
  final String name;

  RecyclingPlace({
    required this.lat,
    required this.lon,
    required this.name,
  });

  factory RecyclingPlace.fromJson(Map<String, dynamic> json) {
    return RecyclingPlace(
      lat: json['lat'] as double,
      lon: json['lon'] as double,
      name: json['tags']['name'] ?? 'Unnamed',
    );
  }
}

final recyclingPlacesProvider = FutureProvider<List<RecyclingPlace>>(
  (ref) async {
    final locationAsyncValue = ref.watch(locationProvider);

    return locationAsyncValue.when(
      data: (locationData) async {
        if (locationData.latitude == null || locationData.longitude == null) {
          throw Exception('Location data is missing.');
        }

        double latitude = locationData.latitude!;
        double longitude = locationData.longitude!;
        double radius = 10500;

        final String overpassUrl = 'http://overpass-api.de/api/interpreter';
        final String query =
            '[out:json];(node["amenity"="recycling"](around:$radius,$latitude,$longitude););out;';

        try {
          final response = await http.get(
            Uri.parse('$overpassUrl?data=${Uri.encodeComponent(query)}'),
          );

          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            List<RecyclingPlace> places = [];
            for (var element in data['elements']) {
              if (element['lat'] != null && element['lon'] != null) {
                places.add(RecyclingPlace.fromJson(element));
              }
            }
            return places;
          } else {
            throw Exception('Failed to load recycling places from the API.');
          }
        } catch (e) {
          throw Exception('Error while fetching data: $e');
        }
      },
      loading: () async => [],
      error: (error, stackTrace) async {
        throw Exception('Error while loading location data: $error');
      },
    );
  },
);
