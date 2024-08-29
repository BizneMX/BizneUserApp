import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/tip/controller.dart';
import 'package:bizne_flutter_app/src/models/scan_ticket.dart';
import 'package:get/get.dart';

class HowYouWantPayController extends LayoutRouteController {
  var cashBankTerminalSelected = true.obs;

  void continueButton(HowYouWantPayParams params) async {
    if (cashBankTerminalSelected.value) {
      navigate(tip,
          params: TipParams(
              amountToPay: params.totalToPay.toDouble(),
              howYouWantPayParams: params,
              cardId: -1));
    } else {
      navigate(amountToPay,
          params: AmountToPayParams(
              howYouWantPayParams: params,
              amountToPay: params.totalToPay.toDouble()));
    }
  }
}

class HowYouWantPayParams {
  final int option;
  final double totalToPay;
  final ScanTicket scanTicket;

  const HowYouWantPayParams(
      {required this.option,
      required this.scanTicket,
      required this.totalToPay});
}
