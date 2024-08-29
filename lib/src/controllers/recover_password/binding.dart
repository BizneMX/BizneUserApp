import 'package:bizne_flutter_app/src/controllers/recover_password/controller.dart';
import 'package:get/get.dart';

class RecoverPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RecoverPasswordController>(RecoverPasswordController());
  }
}
