import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/reserve.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class MyReservesRepo {
  Future<ResponseRepository> getMyReserves() async {
    final response = await Api.service.get(EndPoints.myReserves, {});

    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Reserve>((e) => Reserve.fromJson(e)).toList());
  }
}
