import 'package:bizne_flutter_app/src/models/consumption.dart';

import '../../constants/endpoints.dart';
import '../../models/response.dart';
import '../../services/api.dart';

class ConsumeHistoryRepo {
  Future<ResponseRepository> getConsumeHistory(int month, int year) async {
    final response = await Api.service
        .get(EndPoints.userHistory, {'month': '$month', 'year': '$year'});

    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Consumption>((e) => Consumption.fromJson(e)).toList());
  }
}
