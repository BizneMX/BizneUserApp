// import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/my_reserves/controller.dart';
import 'package:bizne_flutter_app/src/models/reserve.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyReservesPage extends LayoutRouteWidget<MyReserveController> {
  const MyReservesPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getMyReserves();
    final title = SizedBox(
        height: 6.h,
        child: Stack(children: [
          Center(
              child: MyText(
                  text: AppLocalizations.of(context)!.myReserves,
                  fontSize: 18.sp,
                  color: AppThemes().primary,
                  type: FontType.bold)),
          Positioned(
              top: 1.h,
              right: 1.h,
              child: InkWell(
                onTap: controller.launchInfo,
                child: Icon(
                  size: 4.h,
                  Icons.info_outline_rounded,
                  color: AppThemes().primary,
                ),
              ))
        ]));

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        title,
        SizedBox(
          height: 1.h,
        ),
        Expanded(
            child: Obx(() => controller.noData.value
                ? Center(
                    child: MyText(
                      text: 'noData'.tr,
                      fontSize: 12.sp,
                      type: FontType.semibold,
                    ),
                  )
                : ListView(children: [
                    for (var reserve in controller.reserves)
                      ReservesWidget(
                        reserve: reserve,
                        rate: controller.rate,
                        cancel: controller.cancel,
                      )
                  ])))
      ],
    );
  }
}

class ReservesWidget extends StatelessWidget {
  final Reserve reserve;
  final void Function(int id) rate;
  final void Function(int id) cancel;
  const ReservesWidget({
    super.key,
    required this.reserve,
    required this.rate,
    required this.cancel,
  });

  @override
  Widget build(BuildContext context) {
    Widget getReserve(Reserve reserve, {bool last = false}) {
      Widget getRow(String name, String value, {bool black = false}) => Padding(
            padding: EdgeInsets.only(top: 1.h, left: 3.w, right: 3.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 1.w),
                      child: MyText(
                        type: FontType.semibold,
                        fontSize: 12.sp,
                        color: AppThemes().secondary,
                        text: '$name:',
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: MyText(
                      type: FontType.semibold,
                      fontSize: 12.sp,
                      color: black ? null : AppThemes().green,
                      text: value,
                    ))
              ],
            ),
          );
      return Column(
        children: [
          ...[
            (AppLocalizations.of(context)!.fonda, reserve.establishment),
            (
              AppLocalizations.of(context)!.appPayment,
              '${reserve.appPayment} Bz coins:'
            ),
            // (
            //   AppLocalizations.of(context)!.pendingPayment,
            //   '\$${LocalizationFormatters.numberFormat(reserve.cashPayment)} MXN ${AppLocalizations.of(context)!.inCash}'
            // ),
            // (
            //   AppLocalizations.of(context)!.deliveryAddress,
            //   reserve.deliveryAddress
            // ),
          ].map(
            (e) => getRow(e.$1, e.$2,
                black: e.$1 == AppLocalizations.of(context)!.cashPayment),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: 1.h),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           flex: 1,
          //           child: Center(
          //             child: reserve.status == ReserveStatus.pending
          //                 ? BizneElevatedButton(
          //                     onPressed: () => cancel(reserve.id),
          //                     title:
          //                         AppLocalizations.of(context)!.cancelReserve,
          //                     secondary: true,
          //                     autoWidth: true,
          //                     textSize: 12.sp,
          //                     heightFactor: 0.04,
          //                   )
          //                 : const SizedBox(),
          //           )),
          //       Expanded(
          //           flex: 1,
          //           child: Center(
          //             child: BizneElevatedButton(
          //               autoWidth: true,
          //               heightFactor: 0.04,
          //               textSize: 12.sp,
          //               onPressed: () => rate(reserve.id),
          //               title: AppLocalizations.of(context)!.rateReserve,
          //             ),
          //           ))
          //     ],
          //   ),
          // ),
          if (!last) ...[
            SizedBox(
              height: 1.h,
            ),
            Divider(color: AppThemes().grey, height: 1, thickness: 0.3)
          ]
        ],
      );
    }

    Widget getStatus(ReserveStatus status) => switch (status) {
          ReserveStatus.accepted => MyText(
              type: FontType.bold,
              color: AppThemes().secondary,
              fontSize: 12.sp,
              text: AppLocalizations.of(context)!.accepted),
          ReserveStatus.deliver => MyText(
              type: FontType.bold,
              color: AppThemes().green,
              fontSize: 12.sp,
              text: AppLocalizations.of(context)!.deliver),
          ReserveStatus.rejected => MyText(
              type: FontType.bold,
              color: AppThemes().negative,
              fontSize: 12.sp,
              text: AppLocalizations.of(context)!.rejected),
          ReserveStatus.pending => MyText(
              type: FontType.bold,
              color: AppThemes().orange,
              fontSize: 12.sp,
              text: AppLocalizations.of(context)!.pending),
        };

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
            color: AppThemes().whiteInputs,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  fontSize: 12.sp,
                  text: reserve.date,
                  type: FontType.bold,
                ),
                getStatus(reserve.status)
              ],
            ),
          ),
          getReserve(reserve, last: true)
        ],
      ),
    );
  }
}
