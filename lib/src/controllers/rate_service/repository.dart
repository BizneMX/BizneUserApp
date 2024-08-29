import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class RateServiceRepo {
  Future<ResponseRepository> rateService(
      int rate, String comments, int establishment, int visit) async {
    final response = await Api.service.post(EndPoints.userRate, {
      'calification': rate,
      'comments': comments,
      'sucursal': establishment,
      'visit': visit
    });

    return response.toResponseRepository();
  }
}
