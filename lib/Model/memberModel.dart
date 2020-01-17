// To parse this JSON data, do
//
//     final memberModel = memberModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

MemberModel memberModelFromJson(String str) => MemberModel.fromJson(json.decode(str));

String memberModelToJson(MemberModel data) => json.encode(data.toJson());

class MemberModel extends BaseModel {
  Result result;
  String msg;
  String status;

  MemberModel({
    this.result,
    this.msg,
    this.status,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) => MemberModel(
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
  String id;
  String name;
  String noHp;
  String picture;
  String cover;
  String kdReferral;
  String kdUnique;
  String gender;
  String saldo;
  String rawSaldo;
  String saldoMainRaw;
  String saldoMain;
  String saldoBonus;
  String saldoBonusRaw;
  String downline;

  Result({
    this.id,
    this.name,
    this.noHp,
    this.picture,
    this.cover,
    this.kdReferral,
    this.kdUnique,
    this.gender,
    this.saldo,
    this.rawSaldo,
    this.saldoMainRaw,
    this.saldoMain,
    this.saldoBonus,
    this.saldoBonusRaw,
    this.downline,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    noHp: json["no_hp"],
    picture: json["picture"],
    cover: json["cover"],
    kdReferral: json["kd_referral"],
    kdUnique: json["kd_unique"],
    gender: json["gender"],
    saldo: json["saldo"],
    rawSaldo: json["raw_saldo"],
    saldoMainRaw: json["saldo_main_raw"],
    saldoMain: json["saldo_main"],
    saldoBonus: json["saldo_bonus"],
    saldoBonusRaw: json["saldo_bonus_raw"],
    downline: json["downline"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "no_hp": noHp,
    "picture": picture,
    "cover": cover,
    "kd_referral": kdReferral,
    "kd_unique": kdUnique,
    "gender": gender,
    "saldo": saldo,
    "raw_saldo": rawSaldo,
    "saldo_main_raw": saldoMainRaw,
    "saldo_main": saldoMain,
    "saldo_bonus": saldoBonus,
    "saldo_bonus_raw": saldoBonusRaw,
    "downline": downline,
  };
}
