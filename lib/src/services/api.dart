import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import '../environment.dart';
import '../models/response.dart' as resp;

class Api extends GetxService {
  static Api get service => Get.find();
  String? token;
  final String baseUrl = Environment.baseUrl;
  late Map<String, String> headers;

  Future<Api> init(String? token) async {
    this.token = token;
    setHeaders();

    return this;
  }

  void setHeaders() {
    headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': token ?? ''
    };
  }

  void setToken(String token) {
    this.token = token;
    setHeaders();
  }

  void forgetToken() {
    token = null;
    setHeaders();
  }

  Future<resp.Response> get(String url, Map<String, String> query) async {
    return _handleRequest(() async {
      return await Dio().get(
        '$baseUrl$url',
        queryParameters: query,
        options: Options(headers: headers),
      );
    }, url: '$baseUrl$url');
  }

  Future<resp.Response> getById(
      String url, int id, Map<String, String> query) async {
    return _handleRequest(() async {
      return await Dio().get(
        '$baseUrl$url/$id',
        queryParameters: query,
        options: Options(headers: headers),
      );
    }, url: '$baseUrl$url/$id');
  }

  Future<resp.Response> post(String url, Map<String, dynamic> data,
      {Map<String, String>? query}) async {
    return _handleRequest(() async {
      return await Dio().post(
        '$baseUrl$url',
        queryParameters: query ?? {},
        data: data,
        options: Options(headers: headers),
      );
    }, url: '$baseUrl$url', data: data);
  }

  Future<resp.Response> patch(String url, Map<String, String?> data) async {
    return _handleRequest(() async {
      return await Dio().patch(
        '$baseUrl$url',
        data: data,
        options: Options(headers: headers),
      );
    }, url: '$baseUrl$url', data: data);
  }

  Future<resp.Response> patchId(
      String url, String id, Map<String, String> data) async {
    return _handleRequest(() async {
      return await Dio().patch(
        '$baseUrl$url/$id',
        data: data,
        options: Options(headers: headers),
      );
    }, url: '$baseUrl$url/$id', data: data);
  }

  Future<resp.Response> delete(String url, Map<String, String> data) async {
    return _handleRequest(() async {
      return await Dio().delete(
        '$baseUrl$url',
        data: data,
        options: Options(headers: headers),
      );
    });
  }

  Future<resp.Response> deleteId(String url, String id) async {
    return _handleRequest(() async {
      return await Dio().delete(
        '$baseUrl$url/$id',
        options: Options(headers: headers),
      );
    });
  }

  Future<resp.Response> uploadFile(
      String url, String field, String path) async {
    return _handleRequest(() async {
      String fileName = path.split('/').last;
      var formData = dio.FormData.fromMap({
        field: await dio.MultipartFile.fromFile(path, filename: fileName),
      });
      return await Dio().patch(
        '$baseUrl$url',
        data: formData,
        options: Options(
            headers: headers,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
    });
  }

  Future<resp.Response> _handleRequest(Future<dio.Response> Function() request,
      {String url = '', Map<String, dynamic>? data}) async {
    final resp.Response res = resp.Response(success: true, invalidToken: false);
    try {
      final response = await request();
      res.success = true;
      res.data = response.data["data"];
      res.message = response.data["message"];
    } on DioException catch (e) {
      var response = e.response;

      res.success = false;

      if (response?.statusCode == 500) {
        res.message = "Internal Server Error\nurl:$url\npayload:$data";
      }

      if (response?.data is Map) {
        res.data = response?.data["data"];
        res.message = response?.data["message"].toString();
        res.error = response?.data["error"] == null
            ? null
            : resp.CustomError.fromJson(response?.data["error"]);

        res.success = false;
        res.invalidToken = response?.statusCode == 401;
      }
    }
    return res;
  }
}
