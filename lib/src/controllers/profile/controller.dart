import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/utils.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile/repository.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends LayoutRouteController {
  final repo = ProfileRepo();
  var photoUrl = ''.obs;

  void updateProfilePhoto(CroppedFile file, User user) async {
    final base64 = await FileConverter.getBase64FormateFile(file.path);

    EasyLoading.show();
    final response = await repo.uploadFile(base64);
    EasyLoading.dismiss();

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    final userUpdated = response.data as User;
    photoUrl.value = userUpdated.pic;
    user.pic = userUpdated.pic;
  }

  void deleteAccount(User user) async {
    await Get.dialog(BizneDeleteAccountDialog(
      contactSupport: () async {
        Get.back();
        await Utils.contactSupport();
      },
      goToEditPhone: () {
        Get.back();
        navigate(editPhone, params: user);
      },
      gotToEditProfile: () {
        Get.back();
        navigate(editProfile, params: user);
      },
      onOk: () async {
        Get.back();
        EasyLoading.show();
        final response = await repo.deleteAccount();
        EasyLoading.dismiss(animation: true);

        if (!response.success) {
          await Get.dialog(BizneResponseErrorDialog(response: response));
        } else {
          final sharedPref = await SharedPreferences.getInstance();
          await sharedPref.remove('token');

          Get.offNamed(welcome, arguments: false);
        }
      },
      onCancel: () => Get.back(),
    ));
  }
}
