import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/controllers/change_location/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../environment.dart';

class ChangeLocationPage extends LayoutRouteWidget<ChangeLocationController> {
  const ChangeLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: 90.w,
          child: const Row(children: [
            Expanded(flex: 3, child: AdressField()),
            // Expanded(
            //     flex: 1,
            //     child: Center(
            //         child: TextButton(
            //             onPressed: controller.cancel,
            //             child: MyText(
            //                 fontSize: 12.sp,
            //                 text: AppLocalizations.of(context)!.cancel,
            //                 type: FontType.bold,
            //                 color: AppThemes().black))))
          ])),
      const Expanded(child: SizedBox()
          // child: Obx(() => Column(
          //       children: [
          //         for (Prediction prediction in controller.predictions)
          //           Container(
          //               color: Colors.blue,
          //               padding: EdgeInsets.all(1.h),
          //               child: Text(prediction.description ?? ""))
          //       ],
          //     )
          //     )
          // ListView.builder(itemBuilder: (buildContext, index) {
          //   return Column(children: [
          //     SizedBox(height: 1.5.h),
          //     SizedBox(
          //         width: 80.w,
          //         child: InkWell(
          //           onTap: () {},
          //           child: MyText(
          //               fontSize: 12.sp,
          //               text:
          //                   'Calle 10 #225, Ampliación Progreso Nacional, 07720, CDMX, Ciudad de México'),
          //         )),
          //     SizedBox(
          //         width: 90.w,
          //         child: Divider(color: AppThemes().grey.withOpacity(0.5)))
          //   ]);
          // })
          ),
      Container(
        margin: EdgeInsets.only(top: 2.h),
        width: 80.w,
        child: BizneElevatedButton(
            onPressed: () => controller.updateLocation(),
            title: AppLocalizations.of(context)!.useMyCurrentLocation),
      ),
      SizedBox(height: 4.h)
    ]);
  }
}

class AdressField extends GetWidget<ChangeLocationController> {
  const AdressField({super.key});

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
        boxDecoration:
            BoxDecoration(border: Border.all(color: AppThemes().background)),
        textEditingController: controller.searchController,
        googleAPIKey: Environment.googleApiKey,
        isCrossBtnShown: true,
        inputDecoration: InputDecoration(
            suffixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            prefixIconConstraints:
                BoxConstraints(minHeight: 4.h, maxHeight: 4.h),
            prefixIcon: Padding(
                padding: EdgeInsets.only(left: 2.w, right: 1.w),
                child: const Icon(Icons.search, size: 20)),
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 7.5, horizontal: 15),
            fillColor: AppThemes().whiteInputs,
            border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: AppThemes().borderRadius),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppThemes().secondary, width: 2),
                borderRadius: AppThemes().borderRadius),
            enabledBorder: OutlineInputBorder(
                borderRadius: AppThemes().borderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            hintText: AppLocalizations.of(context)!.search),
        debounceTime: 800,
        countries: const ['mx'],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) =>
            controller.setLocation(prediction),
        itemClick: (Prediction prediction) {
          controller.searchController.text = prediction.description!;
          controller.searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description!.length));
          controller.setLocation(prediction);
        },
        itemBuilder: (context, index, Prediction prediction) {
          // controller.predictions.add(prediction);
          return Container(
              // color: Colors.blue,
              padding: EdgeInsets.all(1.h),
              child: Text(prediction.description ?? ""));
        },
        seperatedBuilder: Divider(
          height: 1.w,
          thickness: 0.5.w,
          color: AppThemes().whiteInputs,
        ));
  }
}
