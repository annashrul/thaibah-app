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
  String picture;

  Result({
    this.amount,
    this.rawAmount,
    this.unique,
    this.bankName,
    this.atasNama,
    this.noRekening,
    this.idDeposit,
    this.picture,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    amount: json["amount"],
    rawAmount: json["raw_amount"],
    unique: json["unique"],
    bankName: json["bank_name"],
    atasNama: json["atas_nama"],
    noRekening: json["no_rekening"],
    idDeposit: json["id_deposit"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "raw_amount": rawAmount,
    "unique": unique,
    "bank_name": bankName,
    "atas_nama": atasNama,
    "no_rekening": noRekening,
    "id_deposit": idDeposit,
    "picture": picture,
  };
}
