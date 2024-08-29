import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class EditProfileRepo {
  Future<ResponseRepository> editProfile(String name, String lastName,
      String email, String? birthdate, String genre) async {
    final response = await Api.service.patch(EndPoints.editProfile, {
      'name': name,
      'lastname': lastName,
      'email': email,
      'gender': genre,
      'birthdate': birthdate
    });

    return response.toResponseRepository(
        fromJson: (data) => User.fromJson(data));
  }
}
