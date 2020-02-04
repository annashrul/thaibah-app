// To parse this JSON data, do
//
//     final detailDepositModel = detailDepositModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

DetailDepositModel detailDepositModelFromJson(String str) => DetailDepositModel.fromJson(json.decode(str));

String detailDepositModelToJson(DetailDepositModel data) => json.encode(data.toJson());

class DetailDepositModel extends BaseModel {
  Result result;
  String msg;
  String status;

  DetailDepositModel({
    this.result,
    this.msg,
    this.status,
  });

  factory DetailDepositModel.fromJson(Map<String, dynamic> json) => DetailDepositModel(
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
  String amount;
  String rawAmount;
  String unique;
  String bankName;
  String atasNama;
  String noRekening;
  String idDeposit;
  int status;
  String picture;
  DateTime createdAt;
  String bukti;

  Result({
    this.amount,
    this.rawAmount,
    this.unique,
    this.bankName,
    this.atasNama,
    this.noRekening,
    this.idDeposit,
    this.status,
    this.picture,
    this.createdAt,
    this.bukti,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    amount: json["amount"],
    rawAmount: json["raw_amount"],
    unique: json["unique"],
    bankName: json["bank_name"],
    atasNama: json["atas_nama"],
    noRekening: json["no_rekening"],
    idDeposit: json["id_deposit"],
    status: json["status"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
    bukti: json["bukti"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "raw_amount": rawAmount,
    "unique": unique,
    "bank_name": bankName,
    "atas_nama": atasNama,
    "no_rekening": noRekening,
    "id_deposit": idDeposit,
    "status": status,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
    "bukti": bukti,
  };
}
