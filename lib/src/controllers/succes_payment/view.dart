import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessPaymentPage extends LayoutRouteWidget<SuccessPaymentController> {
  const SuccessPaymentPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as SuccessPaymentParams;

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
          text: currentParams.congratulations
              ? AppLocalizations.of(context)!.congratulations
              : AppLocalizations.of(context)!.successPayment,
          fontSize: 20.sp,
          type: FontType.bold,
          color: AppThemes().green,
        ),
        SizedBox(
          height: 5.h,
        ),
        ...currentParams.paragraphs.map((e) => Padding(
            padding: EdgeInsets.only(bottom: 1.5.h, left: 10.w, right: 10.w),
            child: MyText(
              color: AppThemes().primary,
              align: TextAlign.center,
              text: e,
              fontSize: 16.sp,
              type: FontType.semibold,
            ))),
        const Expanded(child: SizedBox()),
        MyText(
          text: LocalizationFormatters.dateFormat2(DateTime.now()),
          fontSize: 16.sp,
          type: FontType.semibold,
          color: AppThemes().primary,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
          child: BizneElevatedButton(
            onPressed: () => controller.navigate(currentParams.routeToFinish),
            title: AppLocalizations.of(context)!.finish,
          ),
        ),
        SizedBox(
          height: 5.h,
        )
      ],
    );
  }
}

class SuccessPaymentParams {
  final List<String> paragraphs;
  final bool congratulations;
  final String routeToFinish;
  const SuccessPaymentParams(
      {required this.paragraphs,
      required this.routeToFinish,
      this.congratulations = false});
}
