import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class AddPaymentMethodRepo {
  Future<ResponseRepository> addPaymentMethod(
      String token, String postalCode) async {
    final response = await Api.service.post(EndPoints.addCard,
        {'token': token, 'postalCode': postalCode, 'address': ''});

    return response.toResponseRepository();
  }
}
