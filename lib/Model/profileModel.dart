// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel extends BaseModel {
  ProfileModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  Result({
    this.id,
    this.name,
    this.noHp,
    this.picture,
    this.cover,
    this.kdReferral,
    this.kdUnique,
    this.gender,
    this.qr,
    this.saldo,
    this.rawSaldo,
    this.saldoMainRaw,
    this.saldoMain,
    this.saldoBonus,
    this.saldoBonusRaw,
    this.saldoVoucher,
    this.saldoPlatinum,
    this.level,
    this.levelPlatinum,
    this.levelPlatinumRaw,
    this.downline,
    this.omsetJaringan,
    this.jumlahJaringan,
    this.sponsor,
    this.createdAt,
    this.status,
    this.kaki1,
    this.kaki2,
    this.kaki3,
    this.privacy,
  });

  String id;
  String name;
  String noHp;
  String picture;
  String cover;
  String kdReferral;
  String kdUnique;
  dynamic gender;
  String qr;
  String saldo;
  String rawSaldo;
  String saldoMainRaw;
  String saldoMain;
  String saldoBonus;
  String saldoBonusRaw;
  String saldoVoucher;
  String saldoPlatinum;
  int level;
  String levelPlatinum;
  int levelPlatinumRaw;
  String downline;
  String omsetJaringan;
  int jumlahJaringan;
  String sponsor;
  DateTime createdAt;
  int status;
  String kaki1;
  String kaki2;
  String kaki3;
  String privacy;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    noHp: json["no_hp"],
    picture: json["picture"],
    cover: json["cover"],
    kdReferral: json["kd_referral"],
    kdUnique: json["kd_unique"],
    gender: json["gender"],
    qr: json["qr"],
    saldo: json["saldo"],
    rawSaldo: json["raw_saldo"],
    saldoMainRaw: json["saldo_main_raw"],
    saldoMain: json["saldo_main"],
    saldoBonus: json["saldo_bonus"],
    saldoBonusRaw: json["saldo_bonus_raw"],
    saldoVoucher: json["saldo_voucher"],
    saldoPlatinum: json["saldo_platinum"],
    level: json["level"],
    levelPlatinum: json["level_platinum"],
    levelPlatinumRaw: json["level_platinum_raw"],
    downline: json["downline"],
    omsetJaringan: json["omset_jaringan"],
    jumlahJaringan: json["jumlah_jaringan"],
    sponsor: json["sponsor"],
    createdAt: DateTime.parse(json["created_at"]),
    status: json["status"],
    kaki1: json["kaki1"],
    kaki2: json["kaki2"],
    kaki3: json["kaki3"],
    privacy: json["privacy"],
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
    "qr": qr,
    "saldo": saldo,
    "raw_saldo": rawSaldo,
    "saldo_main_raw": saldoMainRaw,
    "saldo_main": saldoMain,
    "saldo_bonus": saldoBonus,
    "saldo_bonus_raw": saldoBonusRaw,
    "saldo_voucher": saldoVoucher,
    "saldo_platinum": saldoPlatinum,
    "level": level,
    "level_platinum": levelPlatinum,
    "level_platinum_raw": levelPlatinumRaw,
    "downline": downline,
    "omset_jaringan": omsetJaringan,
    "jumlah_jaringan": jumlahJaringan,
    "sponsor": sponsor,
    "created_at": createdAt.toIso8601String(),
    "status": status,
    "kaki1": kaki1,
    "kaki2": kaki2,
    "kaki3": kaki3,
    "privacy": privacy,
  };
}
