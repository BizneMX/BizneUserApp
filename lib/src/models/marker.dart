import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerInfo {
  int id;
  String name;
  late LatLng position;
  bool fonda;

  MarkerInfo(
      {required this.id,
      required this.name,
      required lat,
      required lng,
      required this.fonda}) {
    position = LatLng(lat, lng);
  }

  static MarkerInfo fromJson(Map<String, dynamic> json) {
    return MarkerInfo(
        id: json["id"],
        name: json["name"],
        lat: double.parse(json["lat"].toString()),
        lng: double.parse(json["lng"].toString()),
        fonda: json['fonda']);
  }
}
