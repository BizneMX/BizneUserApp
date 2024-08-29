import 'package:bizne_flutter_app/src/controllers/chage_password/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../components/dialog.dart';
import '../../components/form.dart';

class ChangePasswordController extends LayoutRouteController {
  final changePasswordFormController = Get.put(ChangePasswordFormController());
  final repo = ChangePasswordRepo();

  @override
  void clear() {
    changePasswordFormController.clear();
    super.onClose();
  }

  void changePassword() async {
    if (changePasswordFormController.validateAndSave()) {
      final values = changePasswordFormController.getValues();

      EasyLoading.show();
      final response = await repo.changePassword(
          values[changePasswordFormController.currentPassword]!,
          values[changePasswordFormController.newPassword]!,
          values[changePasswordFormController.confirmPassword]!);
      EasyLoading.dismiss(animation: true);

      await Get.dialog(BizneResponseErrorDialog(response: response));

      if (response.success) {
        popNavigate();
      }
    }
  }
}

class ChangePasswordFormController extends FormController {
  final currentPassword = 'currentPassword';
  final newPassword = 'newPassword';
  final confirmPassword = 'confirmPassword';

  @override
  void onInit() {
    addController(currentPassword, null);
    addController(newPassword, null);
    addController(confirmPassword, null);
    super.onInit();
  }

  bool get isPasswordValid =>
      controllers[newPassword]!.text == controllers[confirmPassword]!.text;

  @override
  Map<String, String> getValues() {
    return {
      currentPassword: controllers[currentPassword]!.text,
      newPassword: controllers[newPassword]!.text,
      confirmPassword: controllers[confirmPassword]!.text,
    };
  }
}
