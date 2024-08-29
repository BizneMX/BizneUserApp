import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/form.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/add_payment_method/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

class AddPaymentMethodController extends LayoutRouteController {
  final formController = Get.put(PaymentMethodFormController());
  final repo = AddPaymentMethodRepo();

  @override
  void clear() {
    formController.clear();
    super.onClose();
  }

  Future<(TokenData?, String)> createStripe(
      String card, int month, int year, String cvv, String ownerName) async {
    try {
      final cardDetails = CardDetails(
        number: card,
        expirationMonth: month,
        expirationYear: year, // Asegúrate de usar el año correcto
        cvc: cvv,
      );
      Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

      TokenData token = await Stripe.instance.createToken(
          CreateTokenParams.card(
              params: CardTokenParams(type: TokenType.Card, name: ownerName)));

      return (token, '');
    } catch (e) {
      String message = getLocalizations()!.errorLoadingCreditCard;
      if (e is StripeException &&
          e.error.localizedMessage != null &&
          e.error.localizedMessage!.isNotEmpty) {
        message = e.error.localizedMessage!;
      }

      return (null, message);
    }
  }

  void save() async {
    if (formController.validateAndSave()) {
      final values = formController.getValues();
      final card = values[formController.cardNumber]!.split(' ').join('');
      final month =
          int.parse(values[formController.expirationDate]!.split('/')[0]);
      final year =
          int.parse(values[formController.expirationDate]!.split('/')[1]);
      final ownerName = values[formController.ownerName]!;
      final cvv = values[formController.cvv]!;
      final postalCode = values[formController.postalCode];

      EasyLoading.show();
      final (paymentMethod, message) =
          await createStripe(card, month, year, cvv, ownerName);
      if (paymentMethod == null) {
        EasyLoading.dismiss(animation: true);
        await Get.dialog(BizneDialog(text: message, onOk: () => Get.back()));

        return;
      }

      final response =
          await repo.addPaymentMethod(paymentMethod.id, postalCode!);
      EasyLoading.dismiss(animation: true);

      if (response.success) {
        await Get.dialog(const BizneAddedCreditCardDialog());
        popNavigate();
      } else {
        await Get.dialog(BizneResponseErrorDialog(response: response));
      }
    }
  }
}

class PaymentMethodFormController extends FormController {
  final cardNumber = 'cardNumber';
  final ownerName = 'ownerName';
  final expirationDate = 'expirationDate';
  final cvv = 'cvv';
  final postalCode = 'postalCode';

  @override
  void onInit() {
    addController(cardNumber, CreditCardTextEditingController());
    addController(ownerName, null);
    addController(expirationDate, MonthYearTextEditingController());
    addController(cvv, CountTextEditingController(count: 4));
    addController(postalCode, CountTextEditingController(count: 5));

    super.onInit();
  }
}
