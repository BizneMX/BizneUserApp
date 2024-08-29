import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class RecoverPasswordRepo {
  Future<ResponseRepository> recoverByEmail(String email) async {
    final response = await Api.service
        .post(EndPoints.recoverPasswordEmail, {"email": email});
    return response.toResponseRepository();
  }

  Future<ResponseRepository> recoverByPhone(String phoneNumber) async {
    final response = await Api.service
        .post(EndPoints.recoverPasswordPhone, {"phone": phoneNumber});
    return response.toResponseRepository();
  }
}
