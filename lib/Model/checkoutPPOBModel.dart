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
  String idtrx;
  String no;
  String serial;
  String tanggal;

  Result({
    this.idtrx,
    this.no,
    this.serial,
    this.tanggal,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    idtrx: json["idtrx"],
    no: json["no"],
    serial: json["serial"],
    tanggal: json["tanggal"],
  );

  Map<String, dynamic> toJson() => {
    "idtrx": idtrx,
    "no": no,
    "serial": serial,
    "tanggal": tanggal,
  };
}
