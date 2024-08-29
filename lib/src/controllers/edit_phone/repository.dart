import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class EditPhoneRepo {
  Future<ResponseRepository> updatePhone(String phone) async {
    final response =
        await Api.service.post(EndPoints.sendVerificationCode, {'phone': phone});

    return response.toResponseRepository();
  }
}
