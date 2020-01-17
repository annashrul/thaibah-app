// To parse this JSON data, do
//
//     final ppobPraModel = ppobPraModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

PpobPraModel ppobPraModelFromJson(String str) => PpobPraModel.fromJson(json.decode(str));

String ppobPraModelToJson(PpobPraModel data) => json.encode(data.toJson());

class PpobPraModel extends BaseModel {
  Result result;
  String msg;
  String status;

  PpobPraModel({
    this.result,
    this.msg,
    this.status,
  });

  factory PpobPraModel.fromJson(Map<String, dynamic> json) => PpobPraModel(
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
  var cmd;
  var no;
  List<Datum> data;

  Result({
    this.cmd,
    this.no,
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    cmd: json["cmd"],
    no: json["no"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "cmd": cmd,
    "no": no,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  var code;
  var prov;
  var imgProv;
  var nominal;
  var price;
  var rawPrice;
  var beforePrice;
  var feeCharge;
  var note;

  Datum({
    this.code,
    this.prov,
    this.imgProv,
    this.nominal,
    this.price,
    this.rawPrice,
    this.beforePrice,
    this.feeCharge,
    this.note,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    code: json["code"],
    prov: json["prov"],
    imgProv: json["img_prov"],
    nominal: json["nominal"],
    price: json["price"],
    rawPrice: json["raw_price"],
    beforePrice: json["before_price"],
    feeCharge: json["fee_charge"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "prov": prov,
    "img_prov": imgProv,
    "nominal": nominal,
    "price": price,
    "raw_price": rawPrice,
    "before_price": beforePrice,
    "fee_charge": feeCharge,
    "note": note,
  };
}
