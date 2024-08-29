import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'controller.dart';

class CardItemService extends GetWidget<HomeController> {
  final Establishment item;
  final Function(Establishment) eatHere;
  final Function(String routeName, {dynamic params}) navigate;
  final GlobalKey? tutorialKey;
  const CardItemService({
    super.key,
    required this.item,
    required this.navigate,
    required this.eatHere,
    this.tutorialKey,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => controller.onTapEstablishment(item),
        child: Card(
            elevation: 5.0,
            shape:
                RoundedRectangleBorder(borderRadius: AppThemes().borderRadius),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: AppThemes().borderRadius,
                    color: AppThemes().background,
                    image: DecorationImage(
                        image: NetworkImage(item.pic!),
                        fit: BoxFit
                            .cover // Asegura que la imagen cubra todo el espacio disponible
                        )),
                height: 14.h,
                width: 100.w,
                child: Stack(children: [
                  Positioned(
                      left: 0,
                      top: 0,
                      child: item.closed || item.basicMenu
                          ? Container(
                              decoration: BoxDecoration(
                                  color: item.closed
                                      ? AppThemes().grey
                                      : AppThemes().green,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(19))),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.5.h, horizontal: 2.w),
                                  child: MyText(
                                      type: FontType.semibold,
                                      fontSize: 8.sp,
                                      color: AppThemes().white,
                                      text: item.closed
                                          ? AppLocalizations.of(context)!.closed
                                          : "${AppLocalizations.of(context)!.from} 50 BzCoins")))
                          : const SizedBox()),
                  Positioned(
                      right: 0,
                      top: 0,
                      child: item.logoPic == null
                          ? const SizedBox()
                          : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(19)),
                              child: Image.network(
                                height: 6.h,
                                width: 6.h,
                                fit: BoxFit.cover,
                                item.logoPic!,
                              ))),
                  Positioned(
                      bottom: 0,
                      child: Container(
                          color: const Color.fromRGBO(247, 244, 244, 0.7),
                          height: 8.h,
                          width: 95.w,
                          child: Padding(
                              padding: EdgeInsets.only(
                                  top: 0.5.h,
                                  left: 2.5.w,
                                  right: 2.5.w,
                                  bottom: 1.h),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(children: [
                                            MyText(
                                              fontSize: 13.5.sp,
                                              text:
                                                  Utils.truncateText(item.name),
                                              type: FontType.bold,
                                            ),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            MyText(
                                                type: FontType.semibold,
                                                fontSize: 12.5.sp,
                                                text: Utils.formattedDistance(
                                                    item.distance)),
                                            SizedBox(
                                              width: 3.w,
                                            ),
                                            item.favorite
                                                ? Icon(
                                                    color:
                                                        AppThemes().secondary,
                                                    Icons.favorite,
                                                    size: 13.sp,
                                                  )
                                                : const SizedBox()
                                          ]),
                                          Row(children: [
                                            Icon(Icons.star,
                                                size: 14.sp,
                                                color: AppThemes().gold),
                                            MyText(
                                                type: FontType.semibold,
                                                fontSize: 12.5.sp,
                                                text: item.calification
                                                    .toInt()
                                                    .toString())
                                          ])
                                        ]),
                                    Row(children: [
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              child: BizneElevatedButton(
                                                  heightFactor: 0.03,
                                                  onPressed: () => navigate(
                                                      scheduleFood,
                                                      params: item),
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .schedule1,
                                                  textSize: 9.sp,
                                                  secondary: true))),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              child: BizneElevatedButton(
                                                color: AppThemes().secondary,
                                                heightFactor: 0.03,
                                                textSize: 9.sp,
                                                onPressed: () => navigate(
                                                    serviceDetails,
                                                    params: item),
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .seeMenu,
                                              ))),
                                      Expanded(
                                          flex: 1,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 1.w),
                                              child: BizneElevatedButton(
                                                  key: tutorialKey,
                                                  color: AppThemes().secondary,
                                                  heightFactor: 0.03,
                                                  textSize: 9.sp,
                                                  onPressed: () =>
                                                      eatHere(item),
                                                  title: AppLocalizations.of(
                                                          context)!
                                                      .eatHere)))
                                    ])
                                  ]))))
                ]))));
  }
}
