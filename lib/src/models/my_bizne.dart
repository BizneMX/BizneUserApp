import '../components/utils.dart';

class MyBizne {
  String fullName;
  int bzCoins;
  int todayBzCoins;
  String? userType;
  String? organization;
  String? numEmployee;
  String? orgPic;
  String? orgPath;
  String shareCode;
  String expiryDate;
  bool validated;
  

  MyBizne(
      {required this.fullName,
      required this.bzCoins,
      required this.todayBzCoins,
      required this.userType,
      required this.organization,
      required this.numEmployee,
      required this.orgPic,
      required this.shareCode,
      required this.expiryDate,
      required this.validated});

  static MyBizne fromJson(Map<String, dynamic> json) {
    return MyBizne(
        fullName: json['fullname'],
        bzCoins: Utils.decodeInt(json['bzcoins'].toString()),
        todayBzCoins: json['today_bzcoins'] == null
            ? 0
            : Utils.decodeInt(json['today_bzcoins'].toString()),
        userType: json['user_type'],
        organization: json['organization'],
        numEmployee: json['num_empleado'],
        orgPic: json['org_pic'],
        shareCode: json['share_code'],
        expiryDate: json['expiryDate'],
        validated: json['validated'] == 1);
  }

  Map<String, dynamic> toJson() {
    return {
      'fullname': fullName,
      'bzcoins': bzCoins,
      'today_bzcoins': todayBzCoins,
      'user_type': userType,
      'organization': organization,
      'num_empleado': numEmployee,
      'org_pic': orgPic,
      'share_code': shareCode,
      'expiryDate': expiryDate,
      'validated': validated ? 1 : 0
    };
  }
}
