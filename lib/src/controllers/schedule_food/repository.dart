import '../../constants/endpoints.dart';
import '../../models/response.dart';
import '../../services/api.dart';

class ScheduleFoodRepo {
  Future<ResponseRepository> initBooking(int establishmentId) async {
    final response = await Api.service.post(
        EndPoints.initBooking, {'establishment': establishmentId.toString()});

    return response.toResponseRepository(fromJson: (data) => data);
  }

  Future<ResponseRepository> confirmBooking(Map<String, dynamic> data) async {
    final response = await Api.service.post(EndPoints.confirmBooking, data);

    return response.toResponseRepository(fromJson: (data) => data);
  }
}
