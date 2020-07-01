// To parse this JSON data, do
//
//     final authModel = authModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel extends BaseModel {
  AuthModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
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
    this.address,
    this.email,
    this.picture,
    this.cover,
    this.socketid,
    this.pin,
    this.ktp,
    this.kdReferral,
    this.kdUnique,
    this.token,
    this.noHp,
    this.otp,
    this.statusOtp,
    this.levelStatus,
    this.tema,
  });

  String id;
  String name;
  dynamic address;
  dynamic email;
  String picture;
  String cover;
  String socketid;
  int pin;
  String ktp;
  String kdReferral;
  String kdUnique;
  String token;
  String noHp;
  String otp;
  String statusOtp;
  int levelStatus;
  Tema tema;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    email: json["email"],
    picture: json["picture"],
    cover: json["cover"],
    socketid: json["socketid"],
    pin: json["pin"],
    ktp: json["ktp"],
    kdReferral: json["kd_referral"],
    kdUnique: json["kd_unique"],
    token: json["token"],
    noHp: json["no_hp"],
    otp: json["otp"],
    statusOtp: json["status_otp"],
    levelStatus: json["level_status"],
    tema: Tema.fromJson(json["tema"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "email": email,
    "picture": picture,
    "cover": cover,
    "socketid": socketid,
    "pin": pin,
    "ktp": ktp,
    "kd_referral": kdReferral,
    "kd_unique": kdUnique,
    "token": token,
    "no_hp": noHp,
    "otp": otp,
    "status_otp": statusOtp,
    "level_status": levelStatus,
    "tema": tema.toJson(),
  };
}

class Tema {
  Tema({
    this.warna1,
    this.warna2,
  });

  String warna1;
  String warna2;

  factory Tema.fromJson(Map<String, dynamic> json) => Tema(
    warna1: json["warna1"],
    warna2: json["warna2"],
  );

  Map<String, dynamic> toJson() => {
    "warna1": warna1,
    "warna2": warna2,
  };
}
