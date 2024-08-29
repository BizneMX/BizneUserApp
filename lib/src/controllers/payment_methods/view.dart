import 'package:bizne_flutter_app/src/components/buttons.dart';
import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/my_text.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/controller.dart';
import 'package:bizne_flutter_app/src/models/payment_method.dart';
import 'package:bizne_flutter_app/src/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentMethodsPage extends LayoutRouteWidget<PaymentMethodsController> {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getPaymentMethods();
    return Column(
      children: [
        Expanded(
            child: Obx(() => controller.noPaymentMethods.value
                ? Padding(
                    padding: EdgeInsets.only(top: 1.h, bottom: 3.h),
                    child: Center(
                      child: MyText(
                        fontSize: 12.sp,
                        color: AppThemes().primary,
                        text: 'No hay métodos de pago disponibles',
                        type: FontType.bold,
                      ),
                    ))
                : ListView.builder(
                    itemCount: controller.paymentMethods.length,
                    itemBuilder: (buildContext, index) {
                      final card = Obx(
                        () => PaymentMethodCard(
                          paymentMethod: controller.paymentMethods[index].$1,
                          onSelected: () => controller.selectedMethod(index),
                          isDismissible: controller.paymentMethods[index].$2,
                        ),
                      );
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        child: controller.paymentMethods[index].$1.type ==
                                "Card"
                            ? Dismissible(
                                key: Key(index.toString()),
                                direction: DismissDirection.endToStart,
                                onUpdate: (details) {
                                  if (details.progress > 0.033) {
                                    controller.paymentMethods[index] = (
                                      controller.paymentMethods[index].$1,
                                      true
                                    );
                                  } else {
                                    controller.paymentMethods[index] = (
                                      controller.paymentMethods[index].$1,
                                      false
                                    );
                                  }
                                },
                                onDismissed: (direction) async {
                                  await controller.removeFinal(index);
                                },
                                confirmDismiss: (direction) async {
                                  var w = false;
                                  await Get.dialog(
                                      BizneAreYouSureToDeleteCreditCardDialog(
                                    onOk: () {
                                      w = true;
                                      Get.back();
                                    },
                                    onCancel: () {
                                      w = false;
                                      Get.back();
                                    },
                                  ));
                                  if (!w) return false;
                                  return await controller.remove(index);
                                },
                                background: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.sp),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(19),
                                          bottomRight: Radius.circular(19)),
                                      color: AppThemes().negative,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.delete_outline_rounded,
                                          color: AppThemes().white,
                                          size: 24.sp,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                child: card)
                            : card,
                      );
                    }))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: BizneElevatedButton(
              title: AppLocalizations.of(context)!.addCreditCard,
              onPressed: () => controller.navigate(addPaymentMethod)),
        ),
        SizedBox(
          height: 4.h,
        )
      ],
    );
  }
}

enum PaymentMethodType { cash, bankTerminal, creditCard }

class PaymentMethodCard extends StatelessWidget {
  final Function() onSelected;
  final bool isDismissible;
  final PaymentMethod paymentMethod;
  const PaymentMethodCard(
      {super.key,
      required this.onSelected,
      required this.paymentMethod,
      this.isDismissible = false});

  @override
  Widget build(BuildContext context) {
    List<Widget> getTexts() {
      switch (paymentMethod.type) {
        case "Efectivo":
          return [
            MyText(
              fontSize: 13.sp,
              type: FontType.bold,
              text: AppLocalizations.of(context)!.cash,
              color: AppThemes().primary,
            )
          ];
        case "Terminal bancaria":
          return [
            MyText(
              fontSize: 13.sp,
              type: FontType.bold,
              text: AppLocalizations.of(context)!.bankTerminal,
              color: AppThemes().primary,
            )
          ];
        default:
          return [
            MyText(
              fontSize: 13.sp,
              type: FontType.bold,
              text: paymentMethod.user!,
              color: AppThemes().primary,
            ),
            MyText(
              fontSize: 13.sp,
              type: FontType.bold,
              text: "**** ${paymentMethod.last4}",
              color: AppThemes().primary,
            )
          ];
      }
    }

    Widget getImage() {
      switch (paymentMethod.type) {
        case "Efectivo":
          return Image.asset(
            'assets/icons/cash.png',
            width: 15.w,
          );
        case "Terminal bancaria":
          return Image.asset(
            'assets/icons/bank_terminal.png',
            height: 7.h,
          );
        default:
          return Image.asset(
            'assets/icons/${paymentMethod.brand == 'Visa' ? 'visa' : 'mastercard'}.png',
            width: 15.w,
          );
      }
    }

    return Stack(
      children: [
        if (isDismissible)
          Positioned(
            top: 4.sp,
            bottom: 4.sp,
            right: 0,
            child: Container(
              width: 10.w,
              color: AppThemes().negative,
            ),
          ),
        Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(borderRadius: AppThemes().borderRadius),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: AppThemes().borderRadius,
                color: AppThemes().white),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: Center(
                    child: getImage(),
                  )),
              Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    child: Column(
                      mainAxisAlignment: paymentMethod.type == "Card"
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [...getTexts()],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: BizneElevatedButton(
                      padding: false,
                      heightFactor: 0.03,
                      onPressed: onSelected,
                      title: paymentMethod.active
                          ? AppLocalizations.of(context)!.selected
                          : AppLocalizations.of(context)!.use,
                      textSize: 10.sp,
                    ),
                  ))
            ]),
          ),
        ),
      ],
    );
  }
}
