import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/repository.dart';
import 'package:bizne_flutter_app/src/models/payment_method.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PaymentMethodsController extends LayoutRouteController {
  var repo = PaymentMethodsRepo();
  var paymentMethods = <(PaymentMethod, bool)>[].obs;
  var noPaymentMethods = false.obs;

  Future<void> removeFinal(int index) async {
    paymentMethods.remove(paymentMethods[index]);
    noPaymentMethods.value = paymentMethods.isEmpty;

    await Get.dialog(const BizneRemovedCreditCardDialog());
  }

  Future<bool> remove(int index) async {
    EasyLoading.show();
    final response = await repo.deletePaymentMethod(
        paymentMethods[index].$1.type == 'Card'
            ? paymentMethods[index].$1.cardId!
            : paymentMethods[index].$1.id);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return false;
    }

    return true;
  }

  Future<void> getPaymentMethods() async {
    EasyLoading.show();
    final response = await repo.getPaymentMethods(1);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final data = response.data as List<PaymentMethod>;
    paymentMethods.value = data.map((e) => (e, false)).toList();
    noPaymentMethods.value = paymentMethods.isEmpty;
  }

  Future<void> selectedMethod(int index) async {
    final paymentMethod = paymentMethods[index];

    if (paymentMethod.$1.active) {
      return;
    }

    final data = paymentMethod.$1.type == 'Card'
        ? {
            'paymentId': paymentMethod.$1.id.toString(),
            'cardId': paymentMethod.$1.cardId.toString()
          }
        : {'paymentId': paymentMethod.$1.id.toString()};

    EasyLoading.show();
    final response = await repo.selectPaymentMethod(data);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final copy = <(PaymentMethod, bool)>[];

    for (var e in paymentMethods) {
      if (e.$1.type == 'Card') {
        e.$1.active = paymentMethod.$1.cardId == e.$1.cardId;
      } else {
        e.$1.active = paymentMethod.$1.id == e.$1.id;
      }
      copy.add(e);
    }

    paymentMethods.value = copy;
  }
}
