import 'package:bizne_flutter_app/src/controllers/verification_code/controller.dart';
import 'package:get/get.dart';

class VerificationCodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<VerificationCodeController>(
        VerificationCodeController(currentParams: Get.arguments));
  }
}
