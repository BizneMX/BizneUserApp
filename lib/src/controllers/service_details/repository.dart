import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class ServiceDetailsRepo {
  Future<ResponseRepository> getMenu(int id) async {
    final response = await Api.service.getById(EndPoints.menu, id, {});

    return response.toResponseRepository();
  }
}
