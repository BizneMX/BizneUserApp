import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/tip/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipPage extends LayoutRouteWidget<TipController> {
  const TipPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as TipParams;
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Image.asset(
          'assets/images/logo.png',
          width: 30.w,
        ),
        SizedBox(
          height: 5.h,
        ),
        MyText(
          text: AppLocalizations.of(context)!.addTip,
          fontSize: 16.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        SizedBox(
          height: 3.h,
        ),
        Container(
            height: 4.5.h,
            width: 70.w,
            decoration: BoxDecoration(
                color: AppThemes().whiteInputs,
                borderRadius: AppThemes().borderRadius),
            child: TipSelector(
              key: const Key('Tips'),
              tips: controller.tips,
              onChange: (value) {
                controller.tipSelected = value;
              },
            )),
        const Expanded(child: SizedBox()),
        MyText(
          color: AppThemes().primary,
          align: TextAlign.center,
          text: AppLocalizations.of(context)!.totalToPay,
          fontSize: 16.sp,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          color: AppThemes().green,
          align: TextAlign.center,
          text:
              LocalizationFormatters.currencyFormat(currentParams.amountToPay),
          fontSize: 24.sp,
          type: FontType.bold,
        ),
        SizedBox(
          height: 3.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.payTicket(params),
            title: AppLocalizations.of(context)!.continueText,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.popNavigate(),
            title: AppLocalizations.of(context)!.cancel,
            secondary: true,
          ),
        ),
        SizedBox(
          height: 5.h,
        )
      ],
    );
  }
}
