import 'dart:convert';

import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/myBizne/repository.dart';
import 'package:bizne_flutter_app/src/models/my_bizne.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyByzneController extends LayoutRouteController {
  @override
  void onInit() {
    super.onInit();

    connection() ? getMyBizne() : getMyBizneOffline();
    FirebaseAnalytics.instance.logEvent(
      name: 'user_app_main_menu',
      parameters: {
        'type': 'button',
        'name': 'my_balance'
      }
    );
    // if (!connection()) {
    //   Get.dialog(BizneDialog(
    //       text:
    //           '"No detectamos conexión a internet" Solo podrás pagar con QR, conéctate a una red de Internet para disfrutar de Bizne.',
    //       onOk: () => Get.back()));
    // }
  }

  RxList<MyBizne> data = <MyBizne>[].obs;
  final repo = MyBizneRepo();

  Future<String?> downloadAndSaveImage(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/$filename';

      final file = File(imagePath);
      await file.writeAsBytes(response.bodyBytes);

      return imagePath;
    }

    return null;
  }

  Future<void> getMyBizneOffline() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('myBizne');

    data.add(MyBizne.fromJson(jsonDecode(json!)));
    Get.dialog(const BizneOfflineDialog());
  }

  Future<void> getMyBizne() async {
    EasyLoading.show();
    final response = await repo.getMyBizne();
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(
        response: response,
      ));
      navigate(home);
    }

    var myBizne = response.data as MyBizne;

    myBizne.orgPath = myBizne.orgPic == null
        ? null
        : await downloadAndSaveImage(myBizne.orgPic!, 'orgPic.jpg');
    data.add(myBizne);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString('myBizne', jsonEncode(response.data));
  }

  void launchInfo() async {
    await Get.dialog(const BizneMyBizneDialog());
  }
}
