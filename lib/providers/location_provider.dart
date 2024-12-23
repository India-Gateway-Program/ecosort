import 'package:ecosort/exceptions/location_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

class LocationData {
  final bool isLoading;
  final double? latitude;
  final double? longitude;

  LocationData({
    required this.isLoading,
    this.latitude,
    this.longitude,
  });
}

final locationProvider = FutureProvider<LocationData>((ref) async {
  try {
    final Location location = Location();
    location.changeSettings(accuracy: LocationAccuracy.balanced);

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      throw LocationException('Location service is disabled.');
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw LocationException('Location permission is required.');
      }
    }

    final locationData = await location.getLocation();
    return LocationData(
      isLoading: false,
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
  } catch (e) {
    throw LocationException(e.toString());
  }
});
