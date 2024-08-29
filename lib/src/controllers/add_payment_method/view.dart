import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/controllers/add_payment_method/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';

class AddPaymentMethodPage
    extends LayoutRouteWidget<AddPaymentMethodController> {
  const AddPaymentMethodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 92.h,
        width: 90.w,
        child: Column(
          children: [
            SizedBox(
              height: 5.h,
            ),
            BizneTextFormField(
                hint: AppLocalizations.of(context)!.ownerName,
                key: controller.formController.formKeys['ownerName']!,
                controller: controller.formController.controllers['ownerName']!,
                validator: BizneTextFormField.getRequiredValidator(context),
                onSubmited: () {}),
            SizedBox(
              height: 3.h,
            ),
            BizneTextFormField(
                isNumber: true,
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 10.sp),
                  child: Image.asset(
                    'assets/icons/visa.png',
                    width: 30.sp,
                  ),
                ),
                hint: AppLocalizations.of(context)!.cardNumber,
                key: controller.formController.formKeys['cardNumber']!,
                controller:
                    controller.formController.controllers['cardNumber']!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  if (!Utils.validCreditCard(value)) {
                    return AppLocalizations.of(context)!.invalidCreditCard;
                  }
                  return null;
                },
                onSubmited: () {}),
            SizedBox(
              height: 3.h,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 5,
                    child: BizneTextFormField(
                        isNumber: true,
                        hint: AppLocalizations.of(context)!.monthYear,
                        key: controller
                            .formController.formKeys['expirationDate']!,
                        controller: controller
                            .formController.controllers['expirationDate']!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.requiredField;
                          }
                          if (!Utils.validMonthYear(value)) {
                            return AppLocalizations.of(context)!
                                .invalidExpirationDate;
                          }
                          return null;
                        },
                        onSubmited: () {})),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                    flex: 5,
                    child: BizneTextFormField(
                        isNumber: true,
                        hint: 'CVV',
                        key: controller.formController.formKeys['cvv']!,
                        controller:
                            controller.formController.controllers['cvv']!,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.requiredField;
                          }
                          if (value.length != 4 && value.length != 3) {
                            return AppLocalizations.of(context)!.invalidCVV;
                          }

                          return null;
                        },
                        onSubmited: () {}))
              ],
            ),
            SizedBox(
              height: 3.h,
            ),
            BizneTextFormField(
                hint: AppLocalizations.of(context)!.postalCode,
                key: controller.formController.formKeys['postalCode']!,
                controller:
                    controller.formController.controllers['postalCode']!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.requiredField;
                  }
                  if (value.length != 5) {
                    return AppLocalizations.of(context)!.invalidPostalCode;
                  }

                  return null;
                },
                onSubmited: () {}),
            const Expanded(child: SizedBox()),
            BizneElevatedButton(
                onPressed: controller.save,
                title: AppLocalizations.of(context)!.save),
            SizedBox(
              height: 4.h,
            )
          ],
        ),
      ),
    );
  }
}
