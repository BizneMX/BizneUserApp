import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class PayFoodRepo {
  Future<ResponseRepository> transactionInit(int total) async {
    final response =
        await Api.service.post(EndPoints.transactionInit, {"total": total});

    return response.toResponseRepository();
  }
}
