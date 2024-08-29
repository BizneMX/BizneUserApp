import 'package:get/get.dart';

import 'controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PermissionController());
  }
}
