import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class AmountToPayRepo {
  Future<ResponseRepository> buyBzCoins(int total, int cardId) async {
    final response = await Api.service
        .post(EndPoints.buyBzCoins, {'total': total, 'card_id': cardId});

    return response.toResponseRepository();
  }
}
