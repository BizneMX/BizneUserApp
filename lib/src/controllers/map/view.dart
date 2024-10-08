// ignore_for_file: deprecated_member_use

import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import '../../models/marker.dart';
import 'controller.dart';

class MapPage extends GetView<MapController> {
  final double btnPos;
  const MapPage({super.key, required this.btnPos});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Obx(() => GoogleMap(
          initialCameraPosition: controller.cameraPosition(),
          mapType: MapType.normal,
          style: controller.mapStyle.value.isEmpty
              ? null
              : controller.mapStyle.value,
          onCameraMoveStarted: () => FirebaseAnalytics.instance.logEvent(
            name: 'user_app_map_help',
            parameters: {
              'type': 'button',
              'name': 'help'
            }
          ),
          onCameraMove: (position) {
            controller.onCameraMove(position);
            controller.customInfoWindowController.onCameraMove!();
          },
          onTap: (position) {
            controller.customInfoWindowController.hideInfoWindow!();
          },
          tiltGesturesEnabled: false,
          zoomControlsEnabled: false,
          scrollGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          markers:
              (controller.markers.isEmpty ? {} : controller.markers.toSet())
                ..addAll(controller.userMarker.isEmpty
                    ? {}
                    : controller.userMarker.toSet()),
          gestureRecognizers: {}..add(
              Factory<PanGestureRecognizer>(() => PanGestureRecognizer())))),
      CustomInfoWindow(
          controller: controller.customInfoWindowController,
          height: 15.h,
          width: 50.w,
          offset: 55),
      Row(children: [
        const Expanded(child: SizedBox()),
        Container(
            margin: EdgeInsets.only(right: 5.w, bottom: 5.w),
            height: 100.h,
            width: 15.w,
            child: Column(children: [
              SizedBox(
                height: btnPos,
              ),
              MapButton(
                  onTap: () async {
                    FirebaseAnalytics.instance.logEvent(
                      name: 'user_app_map_whatsapp',
                      parameters: {
                        'type': 'button',
                        'name': 'whatsapp'
                      }
                    );
                    await Utils.contactSupport();
                  },
                  color: AppThemes().green,
                  child: Image.asset('assets/icons/support_chat_white.png',
                      scale: 1.6)),
              MapButton(
                  onTap: () {
                    FirebaseAnalytics.instance.logEvent(
                      name: 'user_app_map_location',
                      parameters: {
                        'type': 'button',
                        'name': 'user_location'
                      }
                    );
                    controller.goToUserLocation();
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 1.w),
                      child: Image.asset('assets/icons/go_location.png',
                          scale: 1.5))),
            ]))
      ]),
    ]);
  }

  void _onMapCreated(GoogleMapController mapController) async {
    controller.mapController = mapController;
    if (!controller.googleMapController.isCompleted) {
      controller.googleMapController.complete(mapController);
      controller.goToUserLocation();
    }
    controller.customInfoWindowController.googleMapController = mapController;
  }
}

class MapInfoWindow extends GetWidget<MapController> {
  final MarkerInfo marker;
  const MapInfoWindow(this.marker, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        Container(
          decoration: BoxDecoration(
              color: AppThemes().primary,
              border: Border.all(color: AppThemes().primary, width: 1.w),
              borderRadius: AppThemes().borderRadius,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    offset: const Offset(0, 2))
              ]),
          child: Container(
            decoration: BoxDecoration(
                color: AppThemes().white,
                borderRadius: AppThemes().borderRadius),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(1.w),
                  child: MyText(
                    text: marker.name,
                    align: TextAlign.center,
                    type: FontType.bold,
                    fontSize: 14.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.goToGoogleMaps(marker.position),
                  child: Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: AppThemes().tertiary,
                      borderRadius: BorderRadius.only(
                          bottomLeft: AppThemes().borderRadius.bottomLeft,
                          bottomRight: AppThemes().borderRadius.bottomRight),
                    ),
                    child: Center(
                        child: MyText(
                      text: 'Ir',
                      color: AppThemes().white,
                      type: FontType.bold,
                      fontSize: 12.sp,
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
        SvgPicture.asset(
          'assets/images/info_window_triangle.svg',
          height: 1.5.h,
          color: AppThemes().primary,
        )
      ],
    );
  }
}

class MapButton extends StatelessWidget {
  final void Function() onTap;
  final Widget child;
  final Color? color;
  const MapButton(
      {super.key, required this.onTap, required this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 1.h),
            height: 12.w,
            width: 12.w,
            decoration: BoxDecoration(
                color: color ?? AppThemes().primary, shape: BoxShape.circle),
            child: Center(child: child)));
  }
}
