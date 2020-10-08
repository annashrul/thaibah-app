// To parse this JSON data, do
//
//     final penarikanDetailModel = penarikanDetailModelFromJson(jsonString);

import 'dart:convert';

PenarikanDetailModel penarikanDetailModelFromJson(String str) => PenarikanDetailModel.fromJson(json.decode(str));

String penarikanDetailModelToJson(PenarikanDetailModel data) => json.encode(data.toJson());

class PenarikanDetailModel {
  PenarikanDetailModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory PenarikanDetailModel.fromJson(Map<String, dynamic> json) => PenarikanDetailModel(
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
    this.idMember,
    this.amount,
    this.accHolderName,
    this.accNumber,
    this.bankcode,
    this.memberEmail,
    this.charge,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String idMember;
  String amount;
  String accHolderName;
  String accNumber;
  String bankcode;
  String memberEmail;
  int charge;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    amount: json["amount"],
    accHolderName: json["acc_holder_name"],
    accNumber: json["acc_number"],
    bankcode: json["bankcode"],
    memberEmail: json["member_email"],
    charge: json["charge"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "amount": amount,
    "acc_holder_name": accHolderName,
    "acc_number": accNumber,
    "bankcode": bankcode,
    "member_email": memberEmail,
    "charge": charge,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
