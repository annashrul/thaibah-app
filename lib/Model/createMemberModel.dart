// To parse this JSON data, do
//
//     final createMemberModel = createMemberModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CreateMemberModel createMemberModelFromJson(String str) => CreateMemberModel.fromJson(json.decode(str));

String createMemberModelToJson(CreateMemberModel data) => json.encode(data.toJson());

class CreateMemberModel extends BaseModel {
  Result result;
  String msg;
  String status;

  CreateMemberModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CreateMemberModel.fromJson(Map<String, dynamic> json) => CreateMemberModel(
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
  String insertId;

  Result({
    this.otp,
    this.statusOtp,
    this.insertId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    otp: json["otp"],
    statusOtp: json["status_otp"],
    insertId: json["insertId"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
    "status_otp": statusOtp,
    "insertId": insertId,
  };
}
