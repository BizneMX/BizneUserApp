import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_with_qr/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/widgets.dart';
import 'package:sizer/sizer.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayWithQRPage extends LayoutRouteWidget<PayWithQRController> {
  const PayWithQRPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    final currentParams = params as PayWithQRParams;

    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        MyText(
            text: AppLocalizations.of(context)!.youCanOnlyPayWithMethod,
            color: AppThemes().primary,
            fontSize: 12.sp,
            type: FontType.semibold),
        SizedBox(
          height: 3.h,
        ),
        Container(
          width: 60.w,
          height: 6.h,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: AppThemes().grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0.0, 1.0))
          ], borderRadius: AppThemes().borderRadius, color: AppThemes().white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyText(
                fontFamily: FontFamily.rajdhani,
                color: AppThemes().primary,
                text: LocalizationFormatters.numberFormat(
                    currentParams.dailyDzCoins.toDouble(),
                    decimalDigits: 0),
                type: FontType.bold,
                fontSize: 24.sp,
              ),
              SizedBox(
                width: 2.w,
              ),
              MyText(
                  text: 'BZC',
                  color: AppThemes().primary,
                  fontSize: 16.sp,
                  type: FontType.semibold)
            ],
          ),
        ),
        SizedBox(
          height: 8.h,
        ),
        SizedBox(
          width: 80.w,
          child: MyText(
              align: TextAlign.center,
              text: AppLocalizations.of(context)!.askTheWaiterOrManager,
              color: AppThemes().primary,
              fontSize: 12.sp,
              type: FontType.semibold),
        ),
        SizedBox(
          height: 5.h,
        ),
        QrImageView(
          data: currentParams.shareCode,
          version: QrVersions.auto,
          size: 50.w,
        ),
        SizedBox(
          height: 2.h,
        ),
        MyText(
          text: LocalizationFormatters.dateFormat2(DateTime.now()),
          color: AppThemes().primary,
          type: FontType.semibold,
          fontSize: 12.sp,
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: const BizneSupportMyBizneButton(),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: BizneElevatedButton(
            onPressed: () => controller.popNavigate(),
            title: AppLocalizations.of(context)!.cancel,
            secondary: true,
          ),
        )
      ],
    );
  }
}
