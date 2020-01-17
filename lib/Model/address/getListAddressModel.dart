// To parse this JSON data, do
//
//     final addressModel = addressModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

AddressModel addressModelFromJson(String str) => AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  AddressModel({
    this.result,
    this.msg,
    this.status,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
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
  String idMember;
  String title;
  String name;
  String mainAddress;
  String kdProv;
  String kdKota;
  String kdKec;
  String noHp;
  int ismain;
  DateTime createdAt;
  DateTime updatedAt;

  Result({
    this.id,
    this.idMember,
    this.title,
    this.name,
    this.mainAddress,
    this.kdProv,
    this.kdKota,
    this.kdKec,
    this.noHp,
    this.ismain,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    title: json["title"],
    name: json["name"],
    mainAddress: json["main_address"],
    kdProv: json["kd_prov"],
    kdKota: json["kd_kota"],
    kdKec: json["kd_kec"],
    noHp: json["no_hp"],
    ismain: json["ismain"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "title": title,
    "name": name,
    "main_address": mainAddress,
    "kd_prov": kdProv,
    "kd_kota": kdKota,
    "kd_kec": kdKec,
    "no_hp": noHp,
    "ismain": ismain,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
