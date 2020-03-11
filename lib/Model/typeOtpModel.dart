// To parse this JSON data, do
//
//     final typeOtpModel = typeOtpModelFromJson(jsonString);

import 'dart:convert';

TypeOtpModel typeOtpModelFromJson(String str) => TypeOtpModel.fromJson(json.decode(str));

String typeOtpModelToJson(TypeOtpModel data) => json.encode(data.toJson());

class TypeOtpModel {
  Result result;
  String msg;
  String status;

  TypeOtpModel({
    this.result,
    this.msg,
    this.status,
  });

  factory TypeOtpModel.fromJson(Map<String, dynamic> json) => TypeOtpModel(
    result: Result.fromJson(json["result"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "msg": msg,
    "status": status,
  };
}

class Result {
  bool typeOtp;

  Result({
    this.typeOtp,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    typeOtp: json["type_otp"],
  );

  Map<String, dynamic> toJson() => {
    "type_otp": typeOtp,
  };
}
