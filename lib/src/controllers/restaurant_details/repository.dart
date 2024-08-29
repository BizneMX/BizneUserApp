import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class RestaurantDetailsRepo {
  Future<ResponseRepository> getSchedule(int id) async {
    final response = await Api.service.getById(EndPoints.schedule, id, {});

    return response.toResponseRepository(fromJson: (data) => data);
  }
}
