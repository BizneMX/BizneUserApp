import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class ChangePasswordRepo {
  Future<ResponseRepository> changePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    final response = await Api.service.post(EndPoints.changePassword, {
      'current': currentPassword,
      'new': newPassword,
      'confirm': confirmPassword
    });

    return response.toResponseRepository();
  }
}
