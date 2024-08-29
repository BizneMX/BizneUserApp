import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AmountToPayPage extends LayoutRouteWidget<AmountToPayController> {
  const AmountToPayPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as AmountToPayParams;
    controller.getPaymentMethods();
    return SingleChildScrollView(
        child: SizedBox(
      height: 100.h,
      child: Column(
        children: [
          SizedBox(
            height: 2.h,
          ),
          MyText(
            text: AppLocalizations.of(context)!.amountToPay,
            fontSize: 16.sp,
            type: FontType.semibold,
            color: AppThemes().primary,
          ),
          SizedBox(
            height: 2.h,
          ),
          MyText(
            text:
                '${LocalizationFormatters.currencyFormat(currentParams.amountToPay)} MXN',
            color: AppThemes().green,
            type: FontType.bold,
            fontSize: 24.sp,
          ),
          SizedBox(
            height: 2.h,
          ),
          MyText(
            text: AppLocalizations.of(context)!.selectASavedCard,
            fontSize: 16.sp,
            type: FontType.semibold,
            color: AppThemes().primary,
          ),
          SizedBox(
            height: 2.h,
          ),
          Container(
              height: 4.5.h,
              width: 70.w,
              decoration: BoxDecoration(
                  color: AppThemes().whiteInputs,
                  borderRadius: AppThemes().borderRadius),
              child: CreditCardSelector(
                key: controller.selectCardKey,
              )),
          SizedBox(
            height: 2.h,
          ),
          MyText(
            text: AppLocalizations.of(context)!.or,
            fontSize: 16.sp,
            type: FontType.semibold,
            color: AppThemes().primary,
          ),
          SizedBox(
            height: 2.h,
          ),
          MyRichText(
            text: MyTextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () => controller.navigate(addPaymentMethod),
                text: AppLocalizations.of(context)!.enterANewCard,
                fontSize: 14.sp,
                type: FontType.semibold,
                decoration: TextDecoration.underline,
                color: AppThemes().primary),
          ),
          const Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: BizneElevatedButton(
              onPressed: () => controller.continueButton(currentParams),
              title: AppLocalizations.of(context)!.pay,
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
          )
        ],
      ),
    ));
  }
}
