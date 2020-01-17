// To parse this JSON data, do
//
//     final ppobPascaCekTagihanModel = ppobPascaCekTagihanModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

PpobPascaCekTagihanModel ppobPascaCekTagihanModelFromJson(String str) => PpobPascaCekTagihanModel.fromJson(json.decode(str));

String ppobPascaCekTagihanModelToJson(PpobPascaCekTagihanModel data) => json.encode(data.toJson());

class PpobPascaCekTagihanModel extends BaseModel {
  Result result;
  String msg;
  String status;

  PpobPascaCekTagihanModel({
    this.result,
    this.msg,
    this.status,
  });

  factory PpobPascaCekTagihanModel.fromJson(Map<String, dynamic> json) => PpobPascaCekTagihanModel(
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
  var tagihanId;
  var code;
  var productName;
  var type;
  var phone;
  var noPelanggan;
  var nama;
  var periode;
  var jumlahTagihan;
  var admin;
  var jumlahBayar;
  var status;

  Result({
    this.tagihanId,
    this.code,
    this.productName,
    this.type,
    this.phone,
    this.noPelanggan,
    this.nama,
    this.periode,
    this.jumlahTagihan,
    this.admin,
    this.jumlahBayar,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    tagihanId: json["tagihan_id"],
    code: json["code"],
    productName: json["product_name"],
    type: json["type"],
    phone: json["phone"],
    noPelanggan: json["no_pelanggan"],
    nama: json["nama"],
    periode: json["periode"],
    jumlahTagihan: json["jumlah_tagihan"],
    admin: json["admin"],
    jumlahBayar: json["jumlah_bayar"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "tagihan_id": tagihanId,
    "code": code,
    "product_name": productName,
    "type": type,
    "phone": phone,
    "no_pelanggan": noPelanggan,
    "nama": nama,
    "periode": periode,
    "jumlah_tagihan": jumlahTagihan,
    "admin": admin,
    "jumlah_bayar": jumlahBayar,
    "status": status,
  };
}
