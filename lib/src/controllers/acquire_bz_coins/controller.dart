import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/amount_to_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/view.dart';
import 'package:get/get.dart';

class AcquireBzCoinsController extends LayoutRouteController {
  var selected = 0.obs;
  var options = [(0, 500), (1, 300), (2, 100)];

  void continueButton() {
    navigate(amountToPay,
        params: AmountToPayParams(
            tip: false,
            successPaymentParams: SuccessPaymentParams(paragraphs: [
              getLocalizations()!
                  .youAcquiredBzCoins(options[selected.value].$2 * 110 ~/ 100),
              getLocalizations()!.useThemInBiZneAffiliated,
              getLocalizations()!.andEatWellEveryDay
            ], congratulations: true, routeToFinish: myBizne),
            amountToPay: options[selected.value].$2.toDouble()));
  }
}
