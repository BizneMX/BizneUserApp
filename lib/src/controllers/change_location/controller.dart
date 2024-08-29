import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/services/location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../home/controller.dart';

class ChangeLocationController extends LayoutRouteController {
  final searchController = TextEditingController();
  Prediction? selectedPrediction;

  // void start() {
  //   address = '';
  // }

  void cancel() {
    searchController.clear();
  }

  void setLocation(Prediction prediction) {
    if (prediction.lat != null && prediction.lng != null) {
      selectedPrediction = prediction;
    }
  }

  void updateLocation() {
    cancel();
    popNavigate(
      afterPop: () {
        LocationProvide.service.updateLocation(LatLng(
            double.parse(selectedPrediction!.lat!),
            double.parse(selectedPrediction!.lng!)));

        if (selectedPrediction != null) {
          Get.find<HomeController>()
              .updateAddress(selectedPrediction!.description!);
        }
      },
    );
  }
}
