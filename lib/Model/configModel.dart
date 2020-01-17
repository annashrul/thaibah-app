// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel extends BaseModel {
  Result result;
  String msg;
  String status;

  ConfigModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
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
  String transfer;

  Result({
    this.transfer,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    transfer: json["transfer"],
  );

  Map<String, dynamic> toJson() => {
    "transfer": transfer,
  };
}
