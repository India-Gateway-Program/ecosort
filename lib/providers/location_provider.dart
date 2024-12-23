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
  final Location location = Location();
  location.changeSettings(accuracy: LocationAccuracy.balanced);

  LocationData state = LocationData(isLoading: true);

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return LocationData(isLoading: false);
    }
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return LocationData(isLoading: false);
    }
  }

  try {
    final locationData = await location.getLocation();
    return LocationData(
      isLoading: false,
      latitude: locationData.latitude,
      longitude: locationData.longitude,
    );
  } catch (e) {
    return LocationData(isLoading: false);
  }
});
