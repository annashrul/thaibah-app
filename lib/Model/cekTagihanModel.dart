// To parse this JSON data, do
//
//     final cekTagihanModel = cekTagihanModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CekTagihanModel cekTagihanModelFromJson(String str) => CekTagihanModel.fromJson(json.decode(str));

String cekTagihanModelToJson(CekTagihanModel data) => json.encode(data.toJson());

class CekTagihanModel extends BaseModel {
  Result result;
  String msg;
  String status;

  CekTagihanModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CekTagihanModel.fromJson(Map<String, dynamic> json) => CekTagihanModel(
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
  String tagihanId;
  String code;
  String productName;
  String type;
  String phone;
  String noPelanggan;
  String nama;
  String periode;
  int jumlahTagihan;
  int admin;
  int jumlahBayar;
  String status;

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
