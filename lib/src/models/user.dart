import 'package:bizne_flutter_app/src/models/organization.dart';

class User {
  int id;
  int sectorId;
  String name;
  String lastName;
  String phone;
  String email;
  String pic;
  bool validated;
  String? birthdate;
  String gender;
  Organization? organization;
  bool employeeValidated;
  String? employeeNumber;
  String? sector;

  User(
      {required this.id,
      required this.name,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.pic,
      required this.validated,
      required this.birthdate,
      required this.gender,
      required this.employeeValidated,
      required this.sectorId,
      this.sector,
      this.organization,
      this.employeeNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        employeeNumber: json['num_empleado'],
        sectorId: json['type_id'],
        sector: json['type_name'],
        organization: json['organization'] is Map<String, dynamic>
            ? Organization.fromJson(json['organization'])
            : null,
        id: json['id'],
        name: json['name'],
        lastName: json['lastname'],
        phone: json['phone'],
        email: json['email'],
        pic: json['pic'],
        validated: json['validated'] == 1,
        birthdate: json['birthdate'],
        gender: json['gender'],
        employeeValidated: json['employee_validated'] == 1);
  }
}
