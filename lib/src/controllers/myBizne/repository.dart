import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/my_bizne.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class MyBizneRepo {
  Future<ResponseRepository> getMyBizne() async {
    final response = await Api.service.get(EndPoints.myBizne, {});

    return response.toResponseRepository(
        fromJson: (data) => MyBizne.fromJson(data));
  }
}
