import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class AmountToPayRepo {
  Future<ResponseRepository> buyBzCoins(int total, int cardId) async {
    final response = await Api.service.post(EndPoints.payTicket, {
      "option": 2,
      "tip": 0,
      "card": true,
      "card_id": cardId,
      "imei": "12345",
      "total": total,
      "total_with_discount": total,
      "pay_with_points": total,
      "ticket": "6988050",
      "establishment": 277,
      "matrix": "171",
      "diners": 1
    });

    return response.toResponseRepository();
  }
}
