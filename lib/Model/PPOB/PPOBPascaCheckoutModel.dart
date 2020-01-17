// To parse this JSON data, do
//
//     final ppobPascaCheckoutModel = ppobPascaCheckoutModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

PpobPascaCheckoutModel ppobPascaCheckoutModelFromJson(String str) => PpobPascaCheckoutModel.fromJson(json.decode(str));

String ppobPascaCheckoutModelToJson(PpobPascaCheckoutModel data) => json.encode(data.toJson());

class PpobPascaCheckoutModel extends BaseModel {
  Result result;
  String msg;
  String status;

  PpobPascaCheckoutModel({
    this.result,
    this.msg,
    this.status,
  });

  factory PpobPascaCheckoutModel.fromJson(Map<String, dynamic> json) => PpobPascaCheckoutModel(
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
  var produk;
  var total;
  var target;
  var mtrpln;
  var note;
  var token;
  var status;

  Result({
    this.produk,
    this.total,
    this.target,
    this.mtrpln,
    this.note,
    this.token,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    produk: json["produk"],
    total: json["total"],
    target: json["target"],
    mtrpln: json["mtrpln"],
    note: json["note"],
    token: json["token"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "produk": produk,
    "total": total,
    "target": target,
    "mtrpln": mtrpln,
    "note": note,
    "token": token,
    "status": status,
  };
}
