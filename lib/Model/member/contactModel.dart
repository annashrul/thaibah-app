// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  ContactModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
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
  String id;
  String name;
  String picture;
  String socketid;
  String referral;
  String status;

  Result({
    this.id,
    this.name,
    this.picture,
    this.socketid,
    this.referral,
    this.status,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    picture: json["picture"],
    socketid: json["socketid"],
    referral: json["referral"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "picture": picture,
    "socketid": socketid,
    "referral": referral,
    "status": status,
  };
}
