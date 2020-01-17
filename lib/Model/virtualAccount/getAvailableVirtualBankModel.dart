// To parse this JSON data, do
//
//     final getAvailableVirtualModel = getAvailableVirtualModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

GetAvailableVirtualModel getAvailableVirtualModelFromJson(String str) => GetAvailableVirtualModel.fromJson(json.decode(str));

String getAvailableVirtualModelToJson(GetAvailableVirtualModel data) => json.encode(data.toJson());

class GetAvailableVirtualModel extends BaseModel {
  Result result;
  String msg;
  String status;

  GetAvailableVirtualModel({
    this.result,
    this.msg,
    this.status,
  });

  factory GetAvailableVirtualModel.fromJson(Map<String, dynamic> json) => GetAvailableVirtualModel(
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
  List<Datum> data;
  int adminFee;

  Result({
    this.data,
    this.adminFee,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    adminFee: json["adminFee"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "adminFee": adminFee,
  };
}

class Datum {
  String name;
  String code;
  String picture;

  Datum({
    this.name,
    this.code,
    this.picture,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    code: json["code"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "picture": picture,
  };
}
