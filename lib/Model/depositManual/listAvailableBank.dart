// To parse this JSON data, do
//
//     final listAvailableBankModel = listAvailableBankModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListAvailableBankModel listAvailableBankModelFromJson(String str) => ListAvailableBankModel.fromJson(json.decode(str));

String listAvailableBankModelToJson(ListAvailableBankModel data) => json.encode(data.toJson());

class ListAvailableBankModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  ListAvailableBankModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListAvailableBankModel.fromJson(Map<String, dynamic> json) => ListAvailableBankModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class Result {
  String idBank;
  String name;
  String code;
  int bankCode;
  String noRekening;
  String atasNama;
  String picture;

  Result({
    this.idBank,
    this.name,
    this.code,
    this.bankCode,
    this.noRekening,
    this.atasNama,
    this.picture,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    idBank: json["id_bank"],
    name: json["name"],
    code: json["code"],
    bankCode: json["bank_code"],
    noRekening: json["no_rekening"],
    atasNama: json["atas_nama"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id_bank": idBank,
    "name": name,
    "code": code,
    "bank_code": bankCode,
    "no_rekening": noRekening,
    "atas_nama": atasNama,
    "picture": picture,
  };
}
