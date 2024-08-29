import 'dart:io';

import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/controller.dart';
import 'package:bizne_flutter_app/src/controllers/pay_with_qr/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyByznePage extends LayoutRouteWidget<MyByzneController> {
  const MyByznePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (controller.connection()) {
      controller.getMyBizne();
    } else {
      controller.getMyBizneOffline();
    }

    final title = Container(
        decoration: BoxDecoration(
          color: AppThemes().white,
          boxShadow: [
            BoxShadow(
                color: AppThemes().grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0.0, 1.0)),
          ],
        ),
        height: 6.h,
        child: Stack(children: [
          Center(
              child: MyText(
                  text: AppLocalizations.of(context)!.myBizne,
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

    final organizationArea = Obx(() => controller.data.isEmpty
        ? const SizedBox()
        : Obx(() => Container(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              width: 100.w,
              decoration: BoxDecoration(color: AppThemes().white, boxShadow: [
                BoxShadow(
                    color: AppThemes().grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0.0, 1.0)),
              ]),
              child: OrganizationWidget(
                orgPath: controller.data.last.orgPath,
                connection: controller.connection(),
                navigate: controller.navigate,
                name: controller.data.last.fullName,
                orgName: controller.data.last.organization,
                orgPic: controller.data.last.orgPic,
                userType: controller.data.last.userType,
                employeeNum: controller.data.last.numEmployee,
                verified: controller.data.last.validated,
              ),
            )));

    final myBizneArea = Obx(() => controller.data.isEmpty
        ? const SizedBox()
        : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'BzCoins',
                      fontSize: 14.sp,
                      color: AppThemes().primary,
                      type: FontType.semibold,
                    ),
                    Obx(() => MyText(
                          fontSize: 40.sp,
                          fontFamily: FontFamily.rajdhani,
                          text: LocalizationFormatters.formatNumberBizne(
                              controller.data.last.bzCoins.toDouble()),
                          color: controller.data.last.bzCoins < 50
                              ? AppThemes().negativeNumber
                              : AppThemes().primary,
                          type: FontType.regular,
                        )),
                    SizedBox(
                      height: 1.h,
                    ),
                    Obx(() {
                      if (controller.data.last.expiryDate != '--') {
                        return MyText(
                            fontSize: 14.sp,
                            color: AppThemes().primary,
                            type: FontType.bold,
                            text:
                                '${AppLocalizations.of(context)!.expire} ${controller.data.last.expiryDate}');
                      }
                      return const MyText(text: '');
                    }),
                    Row(
                      children: [
                        Column(
                          children: [
                            IconButton(
                                onPressed: () => controller.navigate(payWithQR,
                                    params: PayWithQRParams(
                                        dailyDzCoins:
                                            controller.data.last.todayBzCoins,
                                        shareCode:
                                            controller.data.last.shareCode)),
                                icon: Image.asset(
                                  "assets/icons/pay_qr.png",
                                  width: 5.h,
                                )),
                            MyText(
                                color: AppThemes().primary,
                                type: FontType.semibold,
                                fontSize: 10.sp,
                                text: AppLocalizations.of(context)!.payWithQR)
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          children: [
                            IconButton(
                                onPressed: controller.connection()
                                    ? () => controller.navigate(consumeHistory)
                                    : null,
                                icon: Image.asset(
                                  "assets/icons/consume_history.png",
                                  width: 5.h,
                                )),
                            MyText(
                                color: AppThemes().primary,
                                type: FontType.semibold,
                                fontSize: 10.sp,
                                text:
                                    AppLocalizations.of(context)!.myConsumption)
                          ],
                        )
                      ],
                    )
                  ],
                )),
            Expanded(
                flex: 4,
                child: Card(
                    elevation: 5,
                    child: Container(
                        height: 12.h,
                        decoration: BoxDecoration(
                            color: AppThemes().white,
                            borderRadius: AppThemes().borderRadius),
                        child: Column(children: [
                          SizedBox(
                              height: 7.h,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(() => MyText(
                                        fontSize: 24.sp,
                                        color: AppThemes().primary,
                                        fontFamily: FontFamily.rajdhani,
                                        type: FontType.bold,
                                        text:
                                            LocalizationFormatters.numberFormat(
                                                (controller
                                                        .data.last.todayBzCoins)
                                                    .toDouble(),
                                                decimalDigits: 0))),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    MyText(
                                        fontSize: 16.sp,
                                        color: AppThemes().primary,
                                        type: FontType.bold,
                                        text: 'BZC'),
                                  ])),
                          Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                  color: AppThemes().myBizne,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(19),
                                      bottomRight: Radius.circular(19))),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                        child: MyText(
                                            type: FontType.semibold,
                                            fontFamily: FontFamily.rajdhani,
                                            color: AppThemes().primary,
                                            fontSize: 12.sp,
                                            text: AppLocalizations.of(context)!
                                                .youCanUseToday))
                                  ]))
                        ]))))
          ]));

    final rechargeArea = Container(
        height: 10.h,
        width: 90.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppThemes().primary, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: InkWell(
          onTap: controller.connection()
              ? () => controller.navigate(acquireBzCoins)
              : null,
          child: Row(children: [
            Expanded(
              flex: 2,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/recharge_bold.png",
                      height: 6.h,
                    )
                  ]),
            ),
            Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MyText(
                        text: AppLocalizations.of(context)!.rechargeBalance,
                        color: AppThemes().primary,
                        type: FontType.bold,
                        fontSize: 16.sp,
                      ),
                      MyText(
                        text: AppLocalizations.of(context)!.andGet(10),
                        color: AppThemes().primary,
                        type: FontType.bold,
                        fontSize: 14.sp,
                      )
                    ],
                  ),
                ))
          ]),
        ));

    return Column(
      children: [
        title,
        Container(
          height: 30.h,
          width: 100.w,
          color: AppThemes().myBizne,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
            child: myBizneArea,
          ),
        ),
        organizationArea,
        SizedBox(
          height: 3.h,
        ),
        MyText(
          text: AppLocalizations.of(context)!.weGiveYouBzCoins,
          type: FontType.bold,
          color: AppThemes().primary,
          fontSize: 16.sp,
        ),
        SizedBox(
          height: 3.h,
        ),
        rechargeArea,
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
          child: const BizneSupportMyBizneButton(),
        )
      ],
    );
  }
}

class OrganizationWidget extends StatelessWidget {
  final String name;
  final String? orgName;
  final String? orgPic;
  final String? orgPath;
  final String? userType;
  final String? employeeNum;
  final bool verified;
  final Function(String) navigate;
  final bool connection;
  const OrganizationWidget(
      {super.key,
      required this.name,
      required this.connection,
      this.orgName,
      this.orgPic,
      this.userType,
      this.employeeNum,
      this.verified = false,
      required this.orgPath,
      required this.navigate});

  @override
  Widget build(BuildContext context) {
    final withOrganization = Center(
        child: SizedBox(
      width: 96.w,
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: connection
                ? orgPic == null
                    ? const SizedBox()
                    : Image.network(orgPic!)
                : (orgPath == null
                    ? const SizedBox()
                    : Image.file(File(orgPath!))),
          ),
        ),
        Expanded(
            flex: 10,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyText(
                    type: FontType.bold,
                    fontSize: 14.sp,
                    text: name,
                    color: AppThemes().primary,
                  ),
                  MyText(
                    text: orgName ?? '',
                    fontSize: 12.sp,
                    color: AppThemes().primary,
                  ),
                  MyText(
                    fontSize: 12.sp,
                    text: '${userType ?? ''} ${employeeNum ?? ''}',
                    color: AppThemes().primary,
                  ),
                ])),
        Expanded(
          flex: 3,
          child: MyBizneVerified(
            verified: verified,
          ),
        )
      ]),
    ));

    final notOrganization = Center(
        child: SizedBox(
      width: 90.w,
      child: Row(children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: MyText(
              fontSize: 14.sp,
              color: AppThemes().primary,
              type: FontType.bold,
              text: name,
              align: TextAlign.center,
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: SizedBox(
              child: Padding(
                padding: EdgeInsets.only(left: 2.w, top: 2.h, bottom: 2.h),
                child: BizneElevatedButton(
                    onPressed:
                        connection ? () => navigate(setOrganizations) : null,
                    textSize: 10.sp,
                    secondary: true,
                    title: AppLocalizations.of(context)!.belongOrganization),
              ),
            ))
      ]),
    ));

    return orgName == null ? notOrganization : withOrganization;
  }
}

class MyBizneVerified extends StatelessWidget {
  final bool verified;
  const MyBizneVerified({super.key, required this.verified});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Image.asset(
        verified ? 'assets/icons/check.png' : 'assets/icons/input_error.png',
        height: 3.h,
      ),
      SizedBox(
        height: 0.5.h,
      ),
      MyText(
          color: verified ? AppThemes().green : AppThemes().negative,
          fontSize: 10.sp,
          text: verified
              ? AppLocalizations.of(context)!.verified
              : AppLocalizations.of(context)!.notVerified)
    ]);
  }
}
