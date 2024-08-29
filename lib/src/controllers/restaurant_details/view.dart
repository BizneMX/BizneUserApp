import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/home/view.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/restaurant_details/controller.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RestaurantDetailsPage
    extends LayoutRouteWidget<RestaurantDetailsController> {
  const RestaurantDetailsPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    Establishment establishment = params as Establishment;
    controller.getSchedule(establishment);
    controller.isFavorite.call(establishment.favorite);

    final titleContactArea =
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SizedBox(
          width: 70.w,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            MyText(
                text:
                    '${establishment.name} ${AppLocalizations.of(context)!.atDistance(Utils.formattedDistance(establishment.distance))}',
                type: FontType.bold,
                fontSize: 16.sp,
                color: AppThemes().primary)
          ])),
      IconButton(
          onPressed: () => controller.contactBusiness(establishment.phone),
          icon: Image.asset('assets/icons/phone.png', width: 10.w))
    ]);

    final bannerArea = Stack(children: [
      SizedBox(
          height: 25.h,
          width: 100.w,
          child: establishment.menuPic == null || establishment.menuPic!.isEmpty
              ? Image.network(establishment.pic!, fit: BoxFit.cover)
              : Image.network(establishment.menuPic!, fit: BoxFit.cover)),
      Positioned(
          bottom: 10.h,
          right: 5.w,
          child: InkWell(
              onTap: () => controller.setFavorite(establishment),
              child: Obx(() => Icon(
                    color: AppThemes().primary,
                    controller.isFavorite.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 24.sp,
                  )))),
      Positioned(
          bottom: 0,
          child: Container(
              color: const Color.fromRGBO(247, 244, 244, 0.70),
              width: 100.w,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: 0.5.h, left: 2.5.w, right: 2.5.w, bottom: 1.h),
                  child: titleContactArea)))
    ]);

    final selectArea = SizedBox(
        width: 100.w,
        child: Row(children: [
          TabItem(
              onTab: () =>
                  controller.navigate(serviceDetails, params: establishment),
              selected: false,
              text: AppLocalizations.of(context)!.menuOfDay),
          TabItem(
              onTab: () {},
              selected: true,
              text: AppLocalizations.of(context)!.schedule)
        ]));

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      bannerArea,
      selectArea,
      Expanded(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    MyText(
                        text: '${AppLocalizations.of(context)!.schedule}:',
                        type: FontType.bold,
                        fontSize: 16.sp,
                        decoration: TextDecoration.underline),
                    Obx(() => MyText(
                          text: controller.schedule.value,
                          fontSize: 16.sp,
                        )),
                    SizedBox(height: 2.h),
                    MyText(
                        text: '${AppLocalizations.of(context)!.address}:',
                        type: FontType.bold,
                        fontSize: 16.sp,
                        decoration: TextDecoration.underline),
                    MyText(
                      text: establishment.address,
                      fontSize: 16.sp,
                    )
                  ]))))
    ]);
  }
}
