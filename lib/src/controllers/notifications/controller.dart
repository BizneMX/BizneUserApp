import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/notifications/repository.dart';
import 'package:bizne_flutter_app/src/models/notification.dart';
import 'package:bizne_flutter_app/src/models/pagination_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class NotificationsController extends LayoutRouteController {
  final repo = NotificationRepo();
  var count = 10;
  var page = 0;
  var total = 0.obs;
  var notNotifications = false.obs;
  var isLoading = false;
  var notifications = <NotificationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAnalytics.instance.logEvent(
      name: 'user_app_main_menu',
      parameters: {
        'type': 'button',
        'name': 'alerts'
      }
    );
  }

  void seeMore() {
    getNotifications();
  }

  Future<void> getNotifications({clear = false}) async {
    if (isLoading || (!clear && notifications.length == total.value)) {
      return;
    }

    if (clear) {
      page = 0;
      total.value = 0;
      notifications.clear();
    }

    isLoading = true;
    EasyLoading.show();
    final response = await repo.getNotifications(count, page + 1);
    EasyLoading.dismiss(animation: true);
    isLoading = false;

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final paginationData = response.data as PaginationData<NotificationModel>;

    notifications.addAll(paginationData.data);
    page = paginationData.page;
    total.value = paginationData.total;
    notNotifications.value = notifications.isEmpty;
  }
}
