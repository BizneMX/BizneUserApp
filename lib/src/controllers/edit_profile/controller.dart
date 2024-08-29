import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/form.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/controllers/edit_profile/repository.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/register/controller.dart';
import 'package:bizne_flutter_app/src/models/user.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditProfileController extends LayoutRouteController {
  final editProfileFormController = Get.put(EditProfileFormController());
  final repo = EditProfileRepo();

  Future<void> save(User user) async {
    if (editProfileFormController.validateAndSave()) {
      final values = editProfileFormController.getValues();

      EasyLoading.show();
      final response = await repo.editProfile(
          values[editProfileFormController.name]!,
          values[editProfileFormController.lastName]!,
          values[editProfileFormController.email]!,
          values[editProfileFormController.birthdate] == null ||
                  values[editProfileFormController.birthdate]!.isEmpty
              ? null
              : BirthdateFormController()
                  .correctFormat(values[editProfileFormController.birthdate]!),
          values[editProfileFormController.genre]!);
      EasyLoading.dismiss(animation: true);

      if (!response.success) {
        await Get.dialog(BizneResponseErrorDialog(response: response));
        return;
      }

      final updatedUser = response.data as User;
      user.birthdate = updatedUser.birthdate;
      user.email = updatedUser.email;
      user.gender = updatedUser.gender;
      user.name = updatedUser.name;
      user.lastName = updatedUser.lastName;

      popNavigate();
    }
  }

  void setValues(User user) {
    editProfileFormController.setValues({
      editProfileFormController.name: user.name,
      editProfileFormController.lastName: user.lastName,
      editProfileFormController.email: user.email,
      editProfileFormController.birthdate: user.birthdate == null
          ? ''
          : BirthdateFormController().getFormat(user.birthdate!),
      editProfileFormController.genre: user.gender
    });
  }

  @override
  void clear() {
    editProfileFormController.clear();
    super.onClose();
  }
}

class EditProfileFormController extends FormController {
  final name = 'name';
  final lastName = 'lastName';
  final email = 'email';
  final birthdate = 'birthdate';
  final genre = 'genre';

  @override
  void onInit() {
    addController(name, null);
    addController(lastName, null);
    addController(email, null);
    addController(birthdate, DateTextEditingController());
    Get.put(GenreController());
    super.onInit();
  }

  @override
  Map<String, String> getValues() {
    return {
      name: controllers[name]!.text,
      lastName: controllers[lastName]!.text,
      email: controllers[email]!.text,
      birthdate: controllers[birthdate]!.text,
      genre: Get.find<GenreController>().getValues()['genre'] ?? '',
    };
  }

  @override
  void setValues(Map<String, String?> values) {
    Get.find<GenreController>().setGenreValue(values[genre]);
    values.remove(genre);
    super.setValues(values);
  }

  @override
  void clear() {
    super.clear();
    Get.find<GenreController>().clear();
  }
}
