import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/components/form.dart';
import 'package:bizne_flutter_app/src/components/text_filed.dart';
import 'package:bizne_flutter_app/src/constants/routes.dart';
import 'package:bizne_flutter_app/src/controllers/register/repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../models/organization.dart';
import '../../models/user.dart';

class RegisterController extends GetxController {
  final RegisterRepo repo = RegisterRepo();
  final String phone;

  RxInt selectedPage = 0.obs;

  RegisterController({required this.phone});

  void nextPage() async {
    final formController = getFormController();
    if (formController.validateAndSave()) {
      if (selectedPage.value == 1) {
        final values = formController.getValues();
        EasyLoading.show();
        final response = await repo.checkEmail(values['email']!);
        EasyLoading.dismiss(animation: true);
        if (!response.success) {
          await Get.dialog(BizneResponseErrorDialog(response: response));
          return;
        }
      }
      if (selectedPage.value < 3) {
        selectedPage.value++;
      }
    }
  }

  void previousPage() {
    if (selectedPage.value > 0) {
      if (selectedPage.value == 3) {
        Get.find<OrganizationController>().restart();
      }
      selectedPage.value--;
    } else {
      Get.offAllNamed(welcome);
    }
  }

  bool lastPage() => Get.find<OrganizationController>().lastPage();

  FormController getFormController() {
    switch (selectedPage.value) {
      case 0:
        return Get.find<NameFormController>();
      case 1:
        return Get.find<EmailFormController>();
      case 2:
        return Get.find<BirthdateFormController>();
      default:
        return Get.find<NameFormController>();
    }
  }

  void goToLogin() {
    Get.toNamed(login, arguments: false);
  }

  void register() async {
    final nameController = Get.find<NameFormController>();
    final emailController = Get.find<EmailFormController>();
    final birthdateController = Get.find<BirthdateFormController>();
    final organizationController = Get.find<OrganizationController>();

    if (!organizationController.isOk()) {
      await Get.dialog(const RegisterCompleteDialog());
      return;
    }

    final data = {
      ...nameController.getValues(),
      ...emailController.getValues(),
      ...birthdateController.getValues(),
      ...organizationController.getValues(),
    };

    data.addAll({'phone': phone});

    EasyLoading.show();
    final response = await repo.register(data);
    EasyLoading.dismiss(animation: true);

    if (!response.success || response.data == null) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }
    User user = response.data;
    Get.offAllNamed(permissions, arguments: user);
  }
}

class NameFormController extends FormController {
  final name = 'name';
  final lastname = 'lastname';

  @override
  void onInit() {
    addController(name, null);
    addController(lastname, null);
    super.onInit();
  }
}

class EmailFormController extends FormController {
  final email = 'email';
  final password = 'password';
  final confirmPassword = 'confirmPassword';

  bool get isPasswordValid =>
      controllers[password]!.text == controllers[confirmPassword]!.text;

  @override
  void onInit() {
    addController(email, null);
    addController(password, null);
    addController(confirmPassword, null);
    super.onInit();
  }

  @override
  Map<String, String> getValues() {
    final Map<String, String> values = {};
    values[email] = controllers[email]!.text;
    values[password] = controllers[password]!.text;
    return values;
  }
}

class BirthdateFormController extends FormController {
  final birthdate = 'birthdate';

  bool validDate() {
    final date = controllers[birthdate]!.text;
    if (date.isEmpty) return true;
    final dateParts = date.split('/');
    if (dateParts.length != 3) {
      return false;
    }
    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);
    if (day == null || month == null || year == null) {
      return false;
    }
    if (year < 1900) return false;
    DateTime date_;
    try {
      date_ = DateTime(year, month, day);
    } catch (e) {
      return false;
    }
    return date_.day == day && date_.month == month && date_.year == year;
  }

  String correctFormat(String notFormatedDate) {
    if (notFormatedDate.isEmpty) return '';
    final dateParts = notFormatedDate.split('/');
    final day = int.tryParse(dateParts[0]);
    final month = int.tryParse(dateParts[1]);
    final year = int.tryParse(dateParts[2]);
    return '$year-$month-$day';
  }

  String getFormat(String format) {
    format = format.split(' ')[0];
    final dateParts = format.split('-');
    final day = dateParts[2];
    final month = dateParts[1];
    final year = dateParts[0];

    return '$day/$month/$year';
  }

  @override
  void onInit() {
    Get.put(GenreController());
    addController(birthdate, DateTextEditingController());
    super.onInit();
  }

  @override
  Map<String, String> getValues() {
    final date = controllers[birthdate]!.text;
    final Map<String, String> values = {};
    if (date.isNotEmpty) {
      values.addAll({'birthdate': correctFormat(date)});
    }
    values.addAll(Get.find<GenreController>().getValues());
    return values;
  }
}

class GenreController extends FormController {
  RxInt selectedGenre = (-1).obs;

  String genre = "OTHER";

  void setGenreValue(String? genre) {
    int value = -1;
    switch (genre) {
      case "female":
        value = 0;
      case "male":
        value = 1;
      case "other":
        value = 2;
      default:
        value = -1;
    }

    setGenre(value);
  }

  void setGenre(int genre) {
    selectedGenre.value = genre;
    switch (genre) {
      case 0:
        this.genre = "female";
      case 1:
        this.genre = "male";
      default:
        this.genre = "other";
    }
  }

  int genreIndex() {
    switch (genre) {
      case "female":
        return 0;
      case "male":
        return 1;
      default:
        return 2;
    }
  }

  @override
  void clear() {
    selectedGenre.value = 2;
  }

  @override
  Map<String, String> getValues() {
    return selectedGenre.value == -1 ? {} : {"genre": genre};
  }
}

class OrganizationController extends GetxController {
  RegisterRepo repo = RegisterRepo();
  final String phone;

  OrganizationController({required this.phone});

  RxBool isOrganization = false.obs;
  RxBool decision = false.obs;
  RxList<Organization> organizations = <Organization>[].obs;
  Rx<Organization> selectedOrganization = Organization(id: -1, name: '').obs;
  RxString sector = ''.obs;
  RxString employeeNumber = ''.obs;
  Sector selectedSector = Sector(id: -1, name: '');

  @override
  void onInit() {
    getOrganizations();
    super.onInit();
  }

  Map<String, String> getValues() {
    return {
      'organization_id': selectedOrganization.value.id.toString(),
      'type_id': selectedSector.id.toString(),
      'num_empleado': employeeNumber.value,
    };
  }

  void restart() {
    isOrganization.value = false;
    decision.value = false;
    selectedOrganization.value = Organization(id: -1, name: '');
    sector.value = '';
    employeeNumber.value = '';
  }

  bool lastPage() => decision.value;

  void setOrganization(Organization organization) =>
      selectedOrganization.value = organization;

  void setSector(Sector sector) {
    selectedSector = sector;
    this.sector.value = sector.name;
  }

  bool organizationIsSelected() => selectedOrganization.value.id != -1;

  Future<void> getOrganizations() async {
    EasyLoading.show();
    final response = await repo.getOrganizations();
    EasyLoading.dismiss(animation: true);
    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }
    organizations.value = response.data as List<Organization>;
  }

  Future<List<Sector>> getSectors() async {
    EasyLoading.show();
    final response = await repo.getSectors(selectedOrganization.value.id);
    EasyLoading.dismiss(animation: true);
    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return [];
    }
    return response.data;
  }

  bool isOk() {
    return selectedOrganization.value.id != -1 &&
        selectedSector.id != -1 &&
        (employeeNumber.value.isNotEmpty ||
            selectedOrganization.value.validateField == null);
  }

  void makeDecision() => decision.value = !decision.value;

  void setIsOrganization(bool value) {
    if (!value) {
      register();
    } else {
      isOrganization.value = value;
      makeDecision();
    }
  }

  void register() async {
    EasyLoading.show();
    final nameController = Get.find<NameFormController>();
    final emailController = Get.find<EmailFormController>();
    final birthdateController = Get.find<BirthdateFormController>();

    final Map<String, dynamic> data = {
      ...nameController.getValues(),
      ...emailController.getValues(),
      ...birthdateController.getValues()
    };
    data.addAll({
      'phone': phone,
      'organization_id': null,
      'type_id': null,
      'num_empleado': null,
    });

    EasyLoading.show();
    final response = await repo.register(data);
    EasyLoading.dismiss(animation: true);

    if (!response.success) {
      await Get.dialog(BizneResponseErrorDialog(response: response));
      return;
    }

    Get.offAllNamed(permissions);
  }
}
