import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
// import 'package:bizne_flutter_app/src/constants/routes.dart';
// import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_with_discount/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentWithDiscountPage
    extends LayoutRouteWidget<PaymentWithDiscountController> {
  const PaymentWithDiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          height: 3.h,
        ),
        MyText(
          text: AppLocalizations.of(context)!.accountTotal,
          fontSize: 16.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          text: LocalizationFormatters.currencyFormat(1600),
          fontSize: 20.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        SizedBox(
          height: 6.h,
        ),
        MyText(
          color: AppThemes().primary,
          align: TextAlign.center,
          text: AppLocalizations.of(context)!.yourDiscount,
          fontSize: 16.sp,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 1.h,
        ),
        MyText(
          color: AppThemes().primary,
          align: TextAlign.center,
          text: '10 %',
          fontSize: 20.sp,
          type: FontType.semibold,
        ),
        SizedBox(
          height: 6.h,
        ),
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
          text: LocalizationFormatters.currencyFormat(500),
          fontSize: 24.sp,
          type: FontType.bold,
        ),
        const Expanded(child: SizedBox()),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        //   child: BizneElevatedButton(
        //     onPressed: () => controller.navigate(howYouWantPay,
        //         params: const HowYouWantPayParams(
        //             discount: 10, totalToPay: 1000, bizneApp: true)),
        //     title: AppLocalizations.of(context)!.continueText,
        //   ),
        // ),
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
