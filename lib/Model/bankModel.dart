// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';

import 'base_model.dart';

BankModel bankModelFromJson(String str) => BankModel.fromJson(json.decode(str));

String bankModelToJson(BankModel data) => json.encode(data.toJson());

class BankModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  BankModel({
    this.result,
    this.msg,
    this.status,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class Result {
  String name;
  String code;
  bool canDisburse;
  bool canNameValidate;

  Result({
    this.name,
    this.code,
    this.canDisburse,
    this.canNameValidate,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    name: json["name"],
    code: json["code"],
    canDisburse: json["can_disburse"],
    canNameValidate: json["can_name_validate"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "can_disburse": canDisburse,
    "can_name_validate": canNameValidate,
  };
}
