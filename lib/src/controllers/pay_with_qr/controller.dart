import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';

class PayWithQRController extends LayoutRouteController {}

class PayWithQRParams {
  final int dailyDzCoins;
  final String shareCode;

  const PayWithQRParams({required this.dailyDzCoins, required this.shareCode});
}
