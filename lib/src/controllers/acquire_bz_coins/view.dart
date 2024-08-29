import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/acquire_bz_coins/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AcquireBzCoinsPage extends LayoutRouteWidget<AcquireBzCoinsController> {
  const AcquireBzCoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget getBzCard(int index, int total) {
      return Obx(() => BzCard(
          total: total,
          selected: controller.selected.value == index,
          onPressed: () => controller.selected.call(index)));
    }

    return SizedBox(
      width: 100.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.h,
          ),
          Image(
            image: const AssetImage(
              'assets/images/logo.png',
            ),
            width: 20.w,
          ),
          SizedBox(
            height: 2.h,
          ),
          SizedBox(
            width: 80.w,
            child: MyText(
              align: TextAlign.center,
              text: AppLocalizations.of(context)!.acquireBzCoins,
              fontSize: 16.sp,
              type: FontType.semibold,
              color: AppThemes().primary,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          ...controller.options.map((e) => getBzCard(e.$1, e.$2)),
          const Expanded(
            child: SizedBox(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.w,
              vertical: 2.h,
            ),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Icon(
                      size: 12.sp,
                      Icons.info_outline,
                      color: AppThemes().secondary,
                    )),
                Expanded(
                    flex: 9,
                    child: MyRichText(
                      text: MyTextSpan(children: [
                        MyTextSpan(
                            text:
                                '${AppLocalizations.of(context)!.bzCoinsPurchased} ',
                            fontSize: 11.sp),
                        MyTextSpan(
                            text: AppLocalizations.of(context)!.theyAreNotValid,
                            type: FontType.bold,
                            fontSize: 11.sp)
                      ]),
                    ))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: BizneElevatedButton(
              onPressed: controller.continueButton,
              title: AppLocalizations.of(context)!.continueText,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: BizneElevatedButton(
              secondary: true,
              onPressed: () => controller.popNavigate(),
              title: AppLocalizations.of(context)!.cancel,
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
        ],
      ),
    );
  }
}

class BzCard extends StatelessWidget {
  final bool selected;
  final Function() onPressed;
  final int total;
  const BzCard(
      {super.key,
      required this.total,
      required this.selected,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final primaryOrNotSelected =
        selected ? AppThemes().primary : AppThemes().notSelected;
    final secondaryOrNotSelected =
        selected ? AppThemes().secondary : AppThemes().notSelected;
    final greenOrNotSelected =
        selected ? AppThemes().green : AppThemes().notSelected;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: SizedBox(
        width: 85.w,
        height: 10.h,
        child: ElevatedButton(
          style: ButtonStyle(
              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
              backgroundColor: MaterialStateProperty.all(AppThemes().white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19.0),
                  side: selected
                      ? BorderSide(width: 2, color: AppThemes().secondary)
                      : BorderSide.none))),
          onPressed: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                                  color: secondaryOrNotSelected, width: 1))),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyText(
                              text: AppLocalizations.of(context)!.pay1,
                              type:
                                  selected ? FontType.bold : FontType.semibold,
                              color: primaryOrNotSelected,
                              fontSize: 14.sp,
                            ),
                            MyText(
                              text: LocalizationFormatters.currencyFormat(
                                  total.toDouble(),
                                  decimalDigits: 0),
                              type:
                                  selected ? FontType.bold : FontType.semibold,
                              color: primaryOrNotSelected,
                              fontSize: 14.sp,
                            )
                          ]),
                    )),
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: AppLocalizations.of(context)!.andReceive,
                        fontSize: 14.sp,
                        type: selected ? FontType.bold : FontType.semibold,
                        color: primaryOrNotSelected,
                      ),
                      MyText(
                          text: '${total * 110 ~/ 100} Bz Coins',
                          fontSize: 16.sp,
                          type: FontType.bold,
                          color: greenOrNotSelected)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
