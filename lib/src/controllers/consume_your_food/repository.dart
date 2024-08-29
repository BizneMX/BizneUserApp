import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class ConsumeYourFoodRepo {
  Future<ResponseRepository> transactionConfirm(
      int establishment, int total, String imei, int delivery) async {
    final response = await Api.service.post(EndPoints.transactionConfirm, {
      'establishment': establishment,
      'total': total,
      'imei': imei,
      'delivery': delivery
    });

    return response.toResponseRepository();
  }
}
