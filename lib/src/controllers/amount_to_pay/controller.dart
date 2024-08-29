import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/selectors.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/payment_methods/repository.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/repository.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/view.dart';
import 'package:bizne_flutter_app/src/controllers/tip/controller.dart';
import 'package:bizne_flutter_app/src/models/payment_method.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AmountToPayController extends LayoutRouteController {
  final paymentMethodsRepo = PaymentMethodsRepo();
  final repo = AmountToPayRepo();
  final selectCardKey = GlobalKey<CreditCardSelectorState>();

  Future<void> getPaymentMethods() async {
    EasyLoading.show();
    final response = await paymentMethodsRepo.getPaymentMethods(1);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final data = response.data as List<PaymentMethod>;
    selectCardKey.currentState!.setCards(data);
  }

  Future<PaymentMethod?> getSelectedCard() async {
    final selectedCard = selectCardKey.currentState!.selectedCard;
    if (selectedCard == null) {
      await Get.dialog(BizneDialog(
          text: getLocalizations()!.youHaveNoCardsSaved,
          onOk: () => Get.back()));
    }

    return selectedCard;
  }

  Future<bool> buyBzCoins(int total) async {
    final selectedCard = await getSelectedCard();
    if (selectedCard == null) {
      return false;
    }

    EasyLoading.show();
    final response = await repo.buyBzCoins(total, selectedCard.cardId!);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return false;
    }

    return true;
  }

  Future<void> continueButton(AmountToPayParams params) async {
    if (params.tip) {
      final selectedCard = await getSelectedCard();
      if (selectedCard == null) return;
      navigate(tip,
          params: TipParams(
              cardId: selectedCard.cardId!,
              howYouWantPayParams: params.howYouWantPayParams!,
              amountToPay: params.amountToPay));
    } else {
      final success = await buyBzCoins(params.amountToPay.toInt());
      if (!success) return;

      navigate(successPayment, params: params.successPaymentParams);
    }
  }
}

class AmountToPayParams {
  final SuccessPaymentParams? successPaymentParams;
  final double amountToPay;
  final bool tip;
  final HowYouWantPayParams? howYouWantPayParams;

  const AmountToPayParams(
      {this.successPaymentParams,
      required this.amountToPay,
      this.tip = true,
      this.howYouWantPayParams});
}
