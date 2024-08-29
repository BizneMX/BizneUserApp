import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/organization.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

class RegisterRepo {
  Future<ResponseRepository> getOrganizations() async {
    final response = await Api.service.get(EndPoints.getOrganizations, {});
    print(response.data);
    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Organization>((e) => Organization.fromJson(e)).toList());
  }

  Future<ResponseRepository> getSectors(int orgId) async {
    final response =
        await Api.service.get(EndPoints.getSectors, {'org': orgId.toString()});
    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Sector>((e) => Sector.fromJson(e)).toList());
  }

  Future<ResponseRepository> register(Map<String, dynamic> data) async {
    final response = await Api.service.post(EndPoints.register, data);

    if (!response.success || response.data == null) {
      return response.toResponseRepository();
    }

    String token = response.data['token'];
    Api.service.setToken(token);
    final sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setString('token', token);
    return response.toResponseRepository(
        fromJson: (data) => User.fromJson(response.data));
  }

  Future<ResponseRepository> checkEmail(String email) async {
    final response =
        await Api.service.post(EndPoints.checkEmail, {'email': email});
    return response.toResponseRepository();
  }
}
