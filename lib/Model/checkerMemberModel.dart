// To parse this JSON data, do
//
//     final checkerMember = checkerMemberFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CheckerMember checkerMemberFromJson(String str) => CheckerMember.fromJson(json.decode(str));

String checkerMemberToJson(CheckerMember data) => json.encode(data.toJson());

class CheckerMember extends BaseModel {
  CheckerMember({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory CheckerMember.fromJson(Map<String, dynamic> json) => CheckerMember(
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
    this.statusMember,
    this.transfer,
  });

  int statusMember;
  String transfer;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    statusMember: json["status_member"],
    transfer: json["transfer"],
  );

  Map<String, dynamic> toJson() => {
    "status_member": statusMember,
    "transfer": transfer,
  };
}
