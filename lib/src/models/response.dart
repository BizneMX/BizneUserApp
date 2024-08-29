import 'dart:convert';

class Response {
  late bool invalidToken;
  late bool success;
  late dynamic data;
  late String? message;
  late CustomError? error;

  Response(
      {required this.success,
      required this.invalidToken,
      this.data,
      this.error,
      this.message});

  bool get ok => success;

  Response.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'];
    message = json['message'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['success'] = success;
    json['data'] = data;
    json['error'] = error;
    return json;
  }

  ResponseRepository toResponseRepository(
      {dynamic Function(dynamic)? fromJson}) {
    return ResponseRepository(response: this, fromJson: fromJson);
  }
}

CustomError customErrorFromJson(String str) =>
    CustomError.fromJson(json.decode(str));

String customErrorToJson(CustomError data) => json.encode(data.toJson());

class CustomError {
  int? code;
  String? message;

  CustomError({
    this.code,
    this.message,
  });

  factory CustomError.fromJson(Map<String, dynamic> json) => CustomError(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}

class ResponseRepository {
  late bool success;
  late bool invalidToken;
  late String? message;
  late CustomError? error;
  late dynamic data;

  ResponseRepository(
      {required Response response, dynamic Function(dynamic)? fromJson}) {
    success = response.ok;
    error = response.error;
    message = response.message;
    data = fromJson != null && response.data != null
        ? fromJson(response.data)
        : response.data;
    invalidToken = response.invalidToken;
  }
}
