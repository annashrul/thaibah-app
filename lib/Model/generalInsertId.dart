// To parse this JSON data, do
//
//     final generalInsertId = generalInsertIdFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

GeneralInsertId generalInsertIdFromJson(String str) => GeneralInsertId.fromJson(json.decode(str));

String generalInsertIdToJson(GeneralInsertId data) => json.encode(data.toJson());

class GeneralInsertId extends BaseModel {
  Result result;
  String msg;
  String status;

  GeneralInsertId({
    this.result,
    this.msg,
    this.status,
  });

  factory GeneralInsertId.fromJson(Map<String, dynamic> json) => GeneralInsertId(
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
  List<String> insertId;

  Result({
    this.insertId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    insertId: List<String>.from(json["insertId"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "insertId": List<dynamic>.from(insertId.map((x) => x)),
  };
}
