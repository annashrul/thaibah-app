// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel extends BaseModel {
  Result result;
  String msg;
  String status;

  LoginModel({
    this.result,
    this.msg,
    this.status,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
  String address;
  String email;
  String picture;
  String cover;
  String socketid;
  int pin;
  String kdReferral;
  String kdUnique;
  String token;
  String noHp;
  String otp;
  String statusOtp;

  Result({
    this.id,
    this.name,
    this.address,
    this.email,
    this.picture,
    this.cover,
    this.socketid,
    this.pin,
    this.kdReferral,
    this.kdUnique,
    this.token,
    this.noHp,
    this.otp,
    this.statusOtp,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    email: json["email"],
    picture: json["picture"],
    cover: json["cover"],
    socketid: json["socketid"],
    pin: json["pin"],
    kdReferral: json["kd_referral"],
    kdUnique: json["kd_unique"],
    token: json["token"],
    noHp: json["no_hp"],
    otp: json["otp"],
    statusOtp: json["status_otp"],
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
    "kd_referral": kdReferral,
    "kd_unique": kdUnique,
    "token": token,
    "no_hp": noHp,
    "otp": otp,
    "status_otp": statusOtp,
  };
}
