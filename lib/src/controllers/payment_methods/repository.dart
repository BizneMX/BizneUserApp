import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/payment_method.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class PaymentMethodsRepo {
  Future<ResponseRepository> getPaymentMethods(int type) async {
    final response = await Api.service
        .get(EndPoints.getPaymentMethods, {'type': type.toString()});

    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<PaymentMethod>((e) => PaymentMethod.fromJson(e)).toList());
  }

  Future<ResponseRepository> selectPaymentMethod(
      Map<String, String> data) async {
    final response =
        await Api.service.post(EndPoints.selectPaymentMethod, data);

    return response.toResponseRepository();
  }

  Future<ResponseRepository> deletePaymentMethod(int id) async {
    final response = await Api.service
        .delete(EndPoints.deleteCard, {'cardId': id.toString()});

    return response.toResponseRepository();
  }
}
