import 'dart:async';
import 'dart:io';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/marker.dart';
import '../../services/location.dart';
import 'repository.dart';
import 'view.dart';

class MapController extends GetxController {
  late MapRepo repo;

  late GoogleMapController mapController;
  final Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  CameraPosition? savedCameraPosition;

  final CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();
  final List<MarkerInfo> markersInfo = <MarkerInfo>[];

  final LatLng initialPosition = Environment.initialLocation;
  LatLng userLocation = const LatLng(0, 0);

  RxList<Marker> markers = <Marker>[].obs;
  RxList<Marker> userMarker = <Marker>[].obs;

  RxString mapStyle = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
    loadMapStyle();
    addUserMarker();
  }

  void loadMapStyle() async {
    final mapStyleJson = await DefaultAssetBundle.of(Get.context!)
        .loadString('assets/map_style.json');
    mapStyle.value = mapStyleJson;
  }

  Future<void> addUserMarker() async {
    userMarker.clear();
    if (isValidUserLocation()) {
      final isIos = Platform.isIOS;
      final userPin = await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(),
          'assets/icons/user_pin${isIos ? '_ios' : '' '.png'}');
      final marker = Marker(
          markerId: MarkerId(userLocation.toString()),
          position: userLocation,
          icon: userPin);
      userMarker.add(marker);
    }
  }

  void setMarkers(List<MarkerInfo> pins) async {
    markersInfo.clear();
    markersInfo.addAll(pins);
    final isIos = Platform.isIOS;
    final biznePin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'assets/icons/location_pin${isIos ? '_ios' : '' '.png'}');
    markers.clear();
    markers.addAll(pins.map((p) {
      return Marker(
          markerId: MarkerId(p.id.toString()),
          position: p.position,
          icon: biznePin,
          onTap: () {
            customInfoWindowController.addInfoWindow!(
                MapInfoWindow(p, key: UniqueKey()), p.position);
          });
    }));
  }

  void showInfoWindow(int markerId) {
    final marker = markersInfo.firstWhere((element) => element.id == markerId);
    customInfoWindowController.addInfoWindow!(
        MapInfoWindow(marker, key: UniqueKey()), marker.position);
  }

  CameraPosition cameraPosition() {
    return savedCameraPosition ??
        CameraPosition(target: initialPosition, zoom: 13);
  }

  void onCameraMove(CameraPosition position) {
    savedCameraPosition = position;
  }

  Future<void> getUserLocation() async {
    userLocation = LocationProvide.service.userLocation.value;

    LocationProvide.service.userLocation.addListener(() async {
      userLocation = LocationProvide.service.userLocation.value;
      await addUserMarker();
    });
  }

  Future<void> goToLocation(LatLng location) async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: 16,
    )));
  }

  void moreZoom() {
    mapController.animateCamera(CameraUpdate.zoomIn());
  }

  void lessZoom() {
    mapController.animateCamera(CameraUpdate.zoomOut());
  }

  bool isValidUserLocation() => userLocation != const LatLng(0, 0);

  Future<void> goToUserLocation() async {
    if ((await Geolocator.isLocationServiceEnabled()) &&
        LocationProvide.service.alreadyLocated) {
      await goToLocation(userLocation);
    } else {}
  }

  void goToGoogleMaps(LatLng position) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${userLocation.latitude},${userLocation.longitude}&destination=${position.latitude},${position.longitude}';
    try {
      await launchUrl(Uri.parse(url));
    } on Exception {
      // AlertMessage.show(
      //     context,
      //     Text(AppLocalizations.of(context)!.networkError,
      //         textAlign: TextAlign.center));
    }
  }
}
