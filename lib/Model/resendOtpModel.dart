// To parse this JSON data, do
//
//     final resendOtp = resendOtpFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ResendOtp resendOtpFromJson(String str) => ResendOtp.fromJson(json.decode(str));

String resendOtpToJson(ResendOtp data) => json.encode(data.toJson());

class ResendOtp extends BaseModel {
  Result result;
  String msg;
  String status;

  ResendOtp({
    this.result,
    this.msg,
    this.status,
  });

  factory ResendOtp.fromJson(Map<String, dynamic> json) => ResendOtp(
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
  String otp;
  String statusOtp;

  Result({
    this.otp,
    this.statusOtp,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    otp: json["otp"],
    statusOtp: json["status_otp"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "status_otp": statusOtp,
  };
}
