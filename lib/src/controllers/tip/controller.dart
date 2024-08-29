import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/controller.dart';
import 'package:bizne_flutter_app/src/controllers/how_you_want_pay/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/succes_payment/view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class TipController extends LayoutRouteController {
  final tips = ['10', '20', '30'];
  var tipSelected = '10';

  final repo = HowYouWantPayRepo();
  Future<void> payTicket(TipParams params) async {
    EasyLoading.show();
    final response = await repo.payTicket(
        int.parse(tipSelected),
        params.cardId != -1,
        params.cardId,
        '12345',
        params.howYouWantPayParams.option,
        params.howYouWantPayParams.scanTicket);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    navigate(successPayment,
        params: SuccessPaymentParams(
            paragraphs: (response.message ?? '')
                .split('\n')
                .where((element) => element.isNotEmpty)
                .toList(),
            routeToFinish: home,
            congratulations: false));
  }
}

class TipParams {
  final HowYouWantPayParams howYouWantPayParams;
  final int cardId;
  final double amountToPay;

  const TipParams(
      {required this.amountToPay,
      required this.howYouWantPayParams,
      required this.cardId});
}
