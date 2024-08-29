import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

import '../../models/support_item.dart';

class SupportRepo {
  Future<ResponseRepository> getData(String screen) async {
    final response =
        await Api.service.get(EndPoints.supportCategories, {'screen': screen});

    return response.toResponseRepository(
        fromJson: (data) => data.map<SupportItemModel>((e) {
              return SupportItemModel.fromJson(e);
            }).toList());
  }
}
