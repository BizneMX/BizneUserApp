import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../environment.dart';

class LocationProvide extends GetxService {
  static LocationProvide get service => Get.find();
  bool serviceEnabled = false;
  bool alreadyLocated = false;
  ValueNotifier<LatLng> userLocation = ValueNotifier(const LatLng(0, 0));

  Future<LocationProvide> init() async {
    if (await requestPermission()) {
      await enableService();
    }
    return this;
  }

  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled ||
        !(permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse)) {
      permission = await Geolocator.requestPermission();
      serviceEnabled = (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse);
      return serviceEnabled;
    }
    return true;
  }

  Future enableService() async {
    Location location = Location();

    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    bool isTurnedOn = await location.requestService();
    if (!isTurnedOn) {
      return Future.error('Location services are disabled.');
      // }
      // serviceEnabled = true;
    }
    determinePosition();
  }

  Future determinePosition() async {
    if (serviceEnabled) {
      final position = await Geolocator.getCurrentPosition();
      userLocation.value = LatLng(position.latitude, position.longitude);
      alreadyLocated = true;
    } else {
      return Future.error('Location services are disabled.');
    }
  }

  void updateLocation(LatLng location) {
    userLocation.value = location;
  }

  Future<String> getAddressByLocation(double lat, double lng) async {
    final api = GoogleGeocodingApi(Environment.googleApiKey, isLogged: false);
    final searchResults = await api.reverse(
      '$lat,$lng',
      language: 'es',
    );
    if (searchResults.status.toString() == 'OK') {
      return searchResults.results.first.formattedAddress;
    } else {
      return '';
    }
  }
}
