import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationData>((ref) {
  return LocationNotifier();
});

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

class LocationNotifier extends StateNotifier<LocationData> {
  LocationNotifier()
      : super(LocationData(isLoading: false, latitude: null, longitude: null));

  final Location _location = Location();

  Future<void> getLocation() async {
    state = LocationData(
        isLoading: true, latitude: state.latitude, longitude: state.longitude);

    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        state = LocationData(
            isLoading: false,
            latitude: state.latitude,
            longitude: state.longitude);
        return;
      }
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        state = LocationData(
            isLoading: false,
            latitude: state.latitude,
            longitude: state.longitude);
        return;
      }
    }

    try {
      final locationData = await _location.getLocation();
      state = LocationData(
        isLoading: false,
        latitude: locationData.latitude,
        longitude: locationData.longitude,
      );
    } catch (e) {
      state = LocationData(
          isLoading: false,
          latitude: state.latitude,
          longitude: state.longitude);
    }
  }
}
