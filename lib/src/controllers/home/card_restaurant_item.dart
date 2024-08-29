import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CardRestaurantItem extends StatelessWidget {
  final String title;
  final int distance;
  final bool closed;
  final int percent;
  final Function(String route, {dynamic params}) navigate;
  const CardRestaurantItem(
      {super.key,
      required this.closed,
      required this.navigate,
      required this.distance,
      required this.title,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    final leftWith = 25.w;
    final leftArea =
        Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Expanded(
          child: Container(
              decoration: BoxDecoration(
                  color: AppThemes().whiteInputs,
                  borderRadius:
                      const BorderRadius.only(topLeft: Radius.circular(19))))),
      Container(
        decoration: BoxDecoration(
            color: closed ? AppThemes().grey : AppThemes().whiteInputs,
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(19))),
        height: 3.h,
        width: leftWith,
        child: closed
            ? InkWell(
                child: Center(
                  child: MyText(
                    color: AppThemes().white,
                    text: AppLocalizations.of(context)!.closed,
                    fontSize: 10.sp,
                    type: FontType.bold,
                  ),
                ),
                onTap: () {},
              )
            : null,
      )
    ]);

    final rightArea = Padding(
      padding: EdgeInsets.only(left: 7.w, right: 3.w, top: 1.h, bottom: 1.5.h),
      child: Column(children: [
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    type: FontType.bold,
                    fontSize: 14.sp,
                    color: AppThemes().primary,
                  ),
                  MyText(
                    text: AppLocalizations.of(context)!.atDistance(distance),
                  )
                ],
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyText(
              text: AppLocalizations.of(context)!.percentCashback(percent),
              color: AppThemes().green,
              type: FontType.semibold,
            ),
            BizneElevatedButton(
              onPressed: () => navigate(restaurantDetails),
              title: AppLocalizations.of(context)!.details,
              textSize: 11.sp,
              heightFactor: 0.03,
              autoWidth: true,
              color: AppThemes().secondary,
            )
          ],
        )
      ]),
    );
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: AppThemes().borderRadius),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: AppThemes().borderRadius,
                color: AppThemes().white),
            height: 14.h,
            child: Row(children: [
              SizedBox(
                width: leftWith,
                child: leftArea,
              ),
              Expanded(child: rightArea)
            ])));
  }
}
