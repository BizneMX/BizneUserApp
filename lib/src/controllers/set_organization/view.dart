import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/components/organization_selectors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/set_organization/controller.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class SetOrganizationPage extends LayoutRouteWidget<SetOrganizationController> {
  const SetOrganizationPage({super.key, super.params});

  @override
  Widget build(BuildContext context) {
    controller.initParams();

    final step = Obx(() => Column(children: [
          SizedBox(
              width: 80.w,
              child: MyText(
                  text: '1. ${AppLocalizations.of(context)!.organization}',
                  color: AppThemes().primary,
                  fontSize: 16.sp,
                  type: FontType.bold)),
          SizedBox(height: 1.h),
          Column(children: [
            Material(
                borderRadius: AppThemes().borderRadius,
                elevation: 4,
                child: Container(
                    padding: EdgeInsets.all(1.h),
                    decoration: BoxDecoration(
                        color: AppThemes().background,
                        border: Border.all(
                            color: AppThemes().secondary, width: 1.w),
                        borderRadius: AppThemes().borderRadius),
                    height: 15.h,
                    width: 15.h,
                    child: Center(
                        child: IconButton(
                            onPressed: () async {
                              await organizationDialog(
                                  context, controller.organizations, (org) {
                                controller.setOrganization(org);
                              },
                                  selectedOrganization:
                                      controller.selectedOrganization.value.id);
                            },
                            icon: controller.selectedOrganization.value.pic ==
                                    null
                                ? Image.asset(
                                    'assets/icons/organization_building.png')
                                : Image.network(controller
                                    .selectedOrganization.value.pic!))))),
            SizedBox(height: 1.h),
            MyText(
                text: controller.selectedOrganization.value.name,
                color: AppThemes().secondary,
                fontSize: 14.sp,
                type: FontType.bold)
          ]),
          SizedBox(height: 6.h),
          SizedBox(
            width: 80.w,
            child: MyText(
                text:
                    '2. ${AppLocalizations.of(context)!.sectorSeccionSucursal}',
                color: AppThemes().primary,
                fontSize: 16.sp,
                type: FontType.bold),
          ),
          SizedBox(height: 1.h),
          SizedBox(
              width: 70.w,
              child: ElevatedButton(
                  onPressed: controller.selectedOrganization.value.id == -1
                      ? null
                      : () => sectorDialog(
                          context,
                          controller.getSectors,
                          controller.selectedOrganization.value.name,
                          controller.setSector),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes().whiteInputs,
                      shape: RoundedRectangleBorder(
                          borderRadius: AppThemes().borderRadius)),
                  child: SizedBox(
                      width: 70.w,
                      child: Center(
                          child: MyText(
                              text: controller.sector.value.isEmpty
                                  ? AppLocalizations.of(context)!.sectorAsterisk
                                  : controller.sector.value,
                              color: AppThemes().grey,
                              fontSize: 12.sp,
                              type: FontType.bold))))),
          SizedBox(height: 6.h),
          ...controller.selectedOrganization.value.validateField != null
              ? [
                  SizedBox(
                      width: 80.w,
                      child: MyText(
                          text:
                              '3. ${AppLocalizations.of(context)!.employeeNumber}',
                          color: AppThemes().primary,
                          fontSize: 16.sp,
                          type: FontType.bold)),
                  SizedBox(height: 1.h),
                  SizedBox(
                    height: 6.h,
                    width: 70.w,
                    child: ElevatedButton(
                        onPressed: controller.selectedOrganization.value.id == -1
                            ? null
                            : () => employeeNumberDialog(
                                context, (s) => controller.employeeNumber.value = s,
                                employeeNum: controller.employeeNumber.value),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes().whiteInputs,
                            shape: RoundedRectangleBorder(
                                borderRadius: AppThemes().borderRadius)),
                        child: SizedBox(
                            width: 70.w,
                            child: Center(
                                child: MyText(
                                    text: controller.employeeNumber.value.isEmpty
                                        ? '${controller.selectedOrganization.value.validateField}*'
                                        : controller.employeeNumber.value,
                                    color: AppThemes().grey,
                                    fontSize: 12.sp,
                                    type: FontType.bold)))),
                  )
                ]
              : []
        ]));

    return SingleChildScrollView(
        child: SizedBox(
            height: 94.h,
            child: Column(children: [
              SizedBox(
                height: 10.h,
              ),
              step,
              const Expanded(child: SizedBox()),
              Obx(() => controller.canFinish()
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: BizneElevatedButton(
                        onPressed: () => controller.setPostOrganization(),
                        title: AppLocalizations.of(context)!.finish,
                      ),
                    )
                  : const SizedBox()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
                child: BizneElevatedButton(
                  onPressed: () => controller.popNavigate(),
                  title: AppLocalizations.of(context)!.cancel,
                  secondary: true,
                ),
              )
            ])));
  }
}
