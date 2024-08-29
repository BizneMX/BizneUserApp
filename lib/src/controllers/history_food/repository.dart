import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/history_food.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class HistoryFoodRepo {
  Future<ResponseRepository> getHistoryFood() async {
    final response = await Api.service.get(EndPoints.userFoodHistory, {});

    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<HistoryFood>((e) => HistoryFood.fromJson(e)).toList());
  }
}
