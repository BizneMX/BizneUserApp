import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/notification.dart';
import 'package:bizne_flutter_app/src/models/pagination_data.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class NotificationRepo {
  Future<ResponseRepository> getNotifications(int count, int page) async {
    final response = await Api.service.get(EndPoints.userNotifications,
        {'count': count.toString(), 'page': page.toString()});

    return response.toResponseRepository(
        fromJson: (data) => PaginationData<NotificationModel>.fromJson(
            data,
            (data) => data['data']
                .map<NotificationModel>((e) => NotificationModel.fromJson(e))
                .toList()));
  }
}
