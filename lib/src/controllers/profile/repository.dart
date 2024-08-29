import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class ProfileRepo {
  Future<ResponseRepository> deleteAccount() async {
    final response = await Api.service.delete(EndPoints.deleteAccount, {});

    return response.toResponseRepository();
  }

  Future<ResponseRepository> uploadFile(String base64) async {
    final response = await Api.service
        .patch(EndPoints.editProfile, {'pic': 'data:image/jpeg;base64$base64'});

    return response.toResponseRepository(
        fromJson: (data) => User.fromJson(data));
  }
}
