// To parse this JSON data, do
//
//     final checkoutPpobModel = checkoutPpobModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CheckoutPpobModel checkoutPpobModelFromJson(String str) => CheckoutPpobModel.fromJson(json.decode(str));

String checkoutPpobModelToJson(CheckoutPpobModel data) => json.encode(data.toJson());

class CheckoutPpobModel extends BaseModel {
  Result result;
  String msg;
  String status;

  CheckoutPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CheckoutPpobModel.fromJson(Map<String, dynamic> json) => CheckoutPpobModel(
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
  var target;
  var mtrpln;
  var note;
  var token;
  var status;

  Result({
    this.produk,
    this.target,
    this.mtrpln,
    this.note,
    this.token,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    produk: json["produk"],
    target: json["target"],
    mtrpln: json["mtrpln"],
    note: json["note"],
    token: json["token"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "produk": produk,
    "target": target,
    "mtrpln": mtrpln,
    "note": note,
    "token": token,
    "status": status,
  };
}
