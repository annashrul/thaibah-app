// To parse this JSON data, do
//
//     final myBankModel = myBankModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

MyBankModel myBankModelFromJson(String str) => MyBankModel.fromJson(json.decode(str));

String myBankModelToJson(MyBankModel data) => json.encode(data.toJson());

class MyBankModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  MyBankModel({
    this.result,
    this.msg,
    this.status,
  });

  factory MyBankModel.fromJson(Map<String, dynamic> json) => MyBankModel(
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
  String bankname;
  String bankcode;
  String picture;
  String accNo;
  String accName;
  int ismain;
  DateTime createdAt;
  DateTime updatedAt;

  Result({
    this.id,
    this.idMember,
    this.bankname,
    this.bankcode,
    this.picture,
    this.accNo,
    this.accName,
    this.ismain,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    bankname: json["bankname"],
    bankcode: json["bankcode"],
    picture: json["picture"],
    accNo: json["acc_no"],
    accName: json["acc_name"],
    ismain: json["ismain"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "bankname": bankname,
    "bankcode": bankcode,
    "picture": picture,
    "acc_no": accNo,
    "acc_name": accName,
    "ismain": ismain,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
