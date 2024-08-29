import 'package:get/get.dart';

import 'controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController(phone: Get.arguments));
    Get.put(NameFormController());
    Get.put(EmailFormController());
    Get.put(BirthdateFormController());
    Get.put(OrganizationController(phone: Get.arguments));
  }
}
