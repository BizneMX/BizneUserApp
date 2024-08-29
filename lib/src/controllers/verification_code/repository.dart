import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class VerificationCodeRepo {
  Future<ResponseRepository> getCode(String phone) async {
    final response =
        await Api.service.post(EndPoints.getVerificationCode, {"phone": phone});
    return response.toResponseRepository();
  }

  Future<ResponseRepository> checkCode(String phone, String code) async {
    final response = await Api.service
        .post(EndPoints.checkVerificationCode, {"phone": phone, "code": code});
    return response.toResponseRepository();
  }

  Future<ResponseRepository> updatePhone(String phone, String code) async {
    final response = await Api.service
        .patch(EndPoints.updatePhone, {'phone': phone, 'code': code});

    return response.toResponseRepository();
  }
}
