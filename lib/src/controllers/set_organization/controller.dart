import 'package:bizne_flutter_app/src/components/dialog.dart';
import 'package:bizne_flutter_app/src/controllers/layout/controller.dart';
import 'package:bizne_flutter_app/src/controllers/profile_home/controller.dart';
import 'package:bizne_flutter_app/src/controllers/set_organization/repository.dart';
import 'package:bizne_flutter_app/src/models/organization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SetOrganizationController extends LayoutRouteController {
  SetOrganizationRepo repo = SetOrganizationRepo();

  RxList<Organization> organizations = <Organization>[].obs;
  Rx<Organization> selectedOrganization = Organization(id: -1, name: '').obs;
  RxString sector = ''.obs;
  RxString employeeNumber = ''.obs;
  Sector selectedSector = Sector(id: -1, name: '');

  @override
  void onInit() {
    if (!connection()) return;

    getOrganizations();
    super.onInit();
  }

  void initParams() {
    final user = Get.find<ProfileHomeController>().user[0];

    if (user.organization != null) {
      selectedOrganization.value = user.organization!;
    }

    if (user.employeeNumber != null && user.employeeNumber!.isNotEmpty) {
      employeeNumber.value = user.employeeNumber!;
    }

    if (user.sector != null && user.sector!.isNotEmpty) {
      sector.value = user.sector!;
      selectedSector = Sector(id: user.sectorId, name: user.sector!);
    }
  }

  void setOrganization(Organization organization) {
    if (selectedOrganization.value.id != organization.id) {
      employeeNumber.value = '';
      sector.value = '';
      selectedSector = Sector(id: -1, name: '');
    }
    selectedOrganization.value = organization;
  }

  void setSector(Sector sector) {
    selectedSector = sector;
    this.sector.value = sector.name;
  }

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

  bool canFinish() {
    return selectedOrganization.value.id != -1 &&
        sector.value.isNotEmpty &&
        (employeeNumber.value.isNotEmpty ||
            selectedOrganization.value.validateField == null);
  }

  Future<void> setPostOrganization() async {
    EasyLoading.show();
    final response = await repo.postSetOrganization(
        selectedOrganization.value.id, selectedSector.id, employeeNumber.value);
    EasyLoading.dismiss(animation: true);

    await Get.dialog(BizneResponseErrorDialog(response: response));

    if (response.success) {
      final user = Get.find<ProfileHomeController>().user[0];
      user.employeeNumber = employeeNumber.value;
      user.organization = selectedOrganization.value;
      user.sector = sector.value;
      user.sectorId = selectedSector.id;

      popNavigate();
    }
  }

  @override
  void clear() {
    selectedOrganization.value = Organization(id: -1, name: '');
    sector.value = '';
    employeeNumber.value = '';
  }
}
