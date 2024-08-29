import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/environment.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  Future<ResponseRepository> preLogin(String phone) async {
    final response = await Api.service.post(EndPoints.preLogin,
        {'api_key': Environment.apiKey, 'phone': phone, 'sms': true});

    return response.toResponseRepository();
  }

  Future<ResponseRepository> login(String phone, String password) async {
    final response = await Api.service
        .post(EndPoints.login, {'phone': phone, 'password': password});

    if (!response.ok) return response.toResponseRepository();

    String token = response.data['token'];
    await Api.service.init(token);
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('token', token);

    return response.toResponseRepository(
        fromJson: (data) => User.fromJson(response.data));
  }

  void getCountries() {}
}
