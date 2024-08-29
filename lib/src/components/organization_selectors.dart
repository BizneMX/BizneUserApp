// ignore_for_file: use_build_context_synchronously

import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/register/view.dart';
import 'package:bizne_flutter_app/src/models/organization.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget decisionButton(String text, String imagePath, Function() onPressed) {
  return Column(children: [
    ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: AppThemes().borderRadius),
            side: BorderSide(color: AppThemes().secondary, width: 1.w)),
        child: SizedBox(
            height: 20.h,
            width: 20.h,
            child: Center(child: Image.asset(imagePath, height: 60.sp)))),
    SizedBox(height: 1.h),
    MyText(
        text: text,
        color: AppThemes().secondary,
        fontSize: 18.sp,
        type: FontType.bold)
  ]);
}

Future<bool?> sectorDialog(BuildContext context, Function() getSectors,
    String selectedOrganizationName, Function(Sector) onChange) async {
  final sectors = await getSectors();
  return await Get.dialog(Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          decoration: BoxDecoration(
              color: AppThemes().background,
              borderRadius: AppThemes().borderRadius),
          width: 80.w,
          height: 60.h,
          child: Column(children: [
            MyText(
                align: TextAlign.center,
                text: AppLocalizations.of(context)!
                    .selectSector(selectedOrganizationName),
                color: AppThemes().primary,
                fontSize: 14.sp,
                type: FontType.bold),
            SizedBox(height: 1.h),
            Expanded(
              child: SectorSearcher(sectors: sectors, onChange: onChange),
            ),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                heightFactor: 0.04,
                onPressed: () => Get.back(result: true),
                title: AppLocalizations.of(context)!.select),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                secondary: true,
                heightFactor: 0.04,
                onPressed: () => Get.back(result: false),
                title: AppLocalizations.of(context)!.returnText)
          ]))));
}

Future<bool?> employeeNumberDialog(
    BuildContext context, Function(String) onChange,
    {String employeeNum = ''}) async {
  final textController = TextEditingController(text: employeeNum);
  return await Get.dialog(Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          decoration: BoxDecoration(
              color: AppThemes().background,
              borderRadius: AppThemes().borderRadius),
          width: 80.w,
          height: 35.h,
          child: Column(children: [
            MyText(
                align: TextAlign.center,
                text: AppLocalizations.of(context)!.employeeNumber,
                color: AppThemes().primary,
                fontSize: 16.sp,
                type: FontType.bold),
            SizedBox(height: 1.h),
            MyText(
                align: TextAlign.center,
                text: AppLocalizations.of(context)!.enterEmployeeNumber,
                color: AppThemes().primary,
                fontSize: 12.sp,
                type: FontType.bold),
            SizedBox(height: 2.h),
            BizneTextFormField(
                hint: AppLocalizations.of(context)!.employeeNumber,
                controller: textController,
                textAlign: TextAlign.center,
                validator: (value) => null,
                onSubmited: () {}),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                heightFactor: 0.04,
                onPressed: () {
                  onChange(textController.text);
                  Get.back(result: true);
                },
                title: AppLocalizations.of(context)!.confirm),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                secondary: true,
                heightFactor: 0.04,
                onPressed: () => Get.back(result: false),
                title: AppLocalizations.of(context)!.returnText)
          ]))));
}

Future<bool?> organizationDialog(BuildContext context,
    List<Organization> organizations, Function(Organization) setOrganization,
    {int selectedOrganization = -1}) async {
  return await Get.dialog(Center(
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
          decoration: BoxDecoration(
              color: AppThemes().background,
              borderRadius: AppThemes().borderRadius),
          width: 80.w,
          height: 80.h,
          child: Column(children: [
            MyText(
                text: 'Selecciona tu organización',
                color: AppThemes().primary,
                fontSize: 16.sp,
                type: FontType.bold),
            SizedBox(height: 1.h),
            Expanded(
                child: OrganizationSearcher(
                    selectedOrganization: selectedOrganization,
                    organizations: organizations,
                    onChange: setOrganization)),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                heightFactor: 0.04,
                onPressed: () => Get.back(result: true),
                title: AppLocalizations.of(context)!.select),
            SizedBox(height: 2.h),
            BizneElevatedButton(
                secondary: true,
                heightFactor: 0.04,
                onPressed: () => Get.back(result: false),
                title: AppLocalizations.of(context)!.returnText)
          ]))));
}
