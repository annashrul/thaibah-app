// To parse this JSON data, do
//
//     final plnModel = plnModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

PlnModel plnModelFromJson(String str) => PlnModel.fromJson(json.decode(str));

String plnModelToJson(PlnModel data) => json.encode(data.toJson());

class PlnModel extends BaseModel {
  Result result;
  String msg;
  String status;

  PlnModel({
    this.result,
    this.msg,
    this.status,
  });

  factory PlnModel.fromJson(Map<String, dynamic> json) => PlnModel(
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
  String cmd;
  List<Datum> data;

  Result({
    this.cmd,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    cmd: json["cmd"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cmd": cmd,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String code;
  String type;
  String provider;
  int nominal;
  int basicPrice;
  int sellingPrice;
  int status;
  String note;
  DateTime createdAt;
  DateTime updatedAt;
  String category;

  Datum({
    this.id,
    this.code,
    this.type,
    this.provider,
    this.nominal,
    this.basicPrice,
    this.sellingPrice,
    this.status,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    code: json["code"],
    type: json["type"],
    provider: json["provider"],
    nominal: json["nominal"],
    basicPrice: json["basic_price"],
    sellingPrice: json["selling_price"],
    status: json["status"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    category: json["category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "type": type,
    "provider": provider,
    "nominal": nominal,
    "basic_price": basicPrice,
    "selling_price": sellingPrice,
    "status": status,
    "note": note,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "category": category,
  };
}
