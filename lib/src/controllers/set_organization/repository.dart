import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/organization.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';

class SetOrganizationRepo {
  Future<ResponseRepository> getOrganizations() async {
    final response = await Api.service.get(EndPoints.getOrganizations, {});
    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Organization>((e) => Organization.fromJson(e)).toList());
  }

  Future<ResponseRepository> getSectors(int orgId) async {
    final response =
        await Api.service.get(EndPoints.getSectors, {'org': orgId.toString()});
    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<Sector>((e) => Sector.fromJson(e)).toList());
  }

  Future<ResponseRepository> postSetOrganization(
      int orgId, int typeId, String numEmployee) async {
    final response = await Api.service.post(EndPoints.setOrganization, {
      'organization_id': orgId,
      'type_id': typeId,
      'num_empleado': numEmployee
    });

    return response.toResponseRepository();
  }
}
