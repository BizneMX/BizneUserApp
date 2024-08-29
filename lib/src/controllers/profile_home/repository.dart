import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileHomeRepo {
  Future<ResponseRepository> getProfile() async {
    final response = await Api.service.get(EndPoints.userProfile, {});

    if (response.success) {
      String token = response.data['jwt_token'];

      Api.service.setToken(token);
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('token', token);
    }

    return response.toResponseRepository(
        fromJson: (data) => User.fromJson(data));
  }

  Future<ResponseRepository> checkApp() async {
    final response = await Api.service.get(EndPoints.checkApp, {});

    return response.toResponseRepository(
      fromJson: (data) => data,
    );
  }

  Future<ResponseRepository> logout() async {
    final response = await Api.service.post(EndPoints.userLogout, {});

    return response.toResponseRepository();
  }

  // Future<ResponseRepository> recoverToken(String fcmToken) async {
  //   final response =
  //       // await Api.service.post(EndPoints.recoverToken, {'google_id': fcmToken});
  //       await Api.service.post(EndPoints.recoverToken, {'uu_id': fcmToken});

  //   return response.toResponseRepository();
  // }
}
