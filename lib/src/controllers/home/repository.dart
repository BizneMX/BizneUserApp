import 'dart:io';

import 'package:bizne_flutter_app/src/constants/endpoints.dart';
import 'package:bizne_flutter_app/src/models/establishmet.dart';
import 'package:bizne_flutter_app/src/models/pagination_data.dart';
import 'package:bizne_flutter_app/src/models/response.dart';
import 'package:bizne_flutter_app/src/services/api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_uuid/device_uuid.dart';

import '../../models/marker.dart';

class HomeRepo {
  Future<ResponseRepository> getEstablishments(
      Map<String, dynamic> data, int page, int filter) async {
    final query = {'page': page.toString()};
    if (filter != 0) query['filter'] = filter.toString();

    final response =
        await Api.service.post(EndPoints.establishments, data, query: query);

    return response.toResponseRepository(
        fromJson: (data) => PaginationData<Establishment>.fromJson(
            data,
            (data) => data["data"]
                .map<Establishment>((e) => Establishment.fromJson(e))
                .toList()));
  }

  Future<ResponseRepository> transactionData(int establishment) async {
    final response = await Api.service
        .post(EndPoints.transactionData, {'establishment': establishment});

    return response.toResponseRepository();
  }

  Future<ResponseRepository> registerToken() async {
    Map<String, dynamic> data = {};

    final sharedPref = await SharedPreferences.getInstance();
    final token = sharedPref.getString('fcmToken');

    data['token'] = token;
    data['uuid'] = await DeviceUuid().getUUID();

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      data['modelo'] = info.model;
      data['marca'] = info.brand;
      data['deviceType'] = 1;
    }

    if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      data['modelo'] = info.model;
      data['marca'] = info.systemName;
      data['deviceType'] = 0;
    }

    final response = await Api.service.post(EndPoints.registerToken, data);

    return response.toResponseRepository();
  }

  Future<ResponseRepository> setFavorite(
      int establishment, bool favorite) async {
    final response = await Api.service.post(EndPoints.setFavorite,
        {'establishment': establishment, 'favorite': favorite});

    return response.toResponseRepository();
  }

  Future<ResponseRepository> getEstablishmentPins() async {
    final response = await Api.service.get(EndPoints.establishmentPins, {});

    return response.toResponseRepository(
        fromJson: (data) =>
            data.map<MarkerInfo>((e) => MarkerInfo.fromJson(e)).toList());
  }
}
