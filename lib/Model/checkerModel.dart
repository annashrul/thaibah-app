// To parse this JSON data, do
//
//     final checker = checkerFromJson(jsonString);

import 'dart:convert';

Checker checkerFromJson(String str) => Checker.fromJson(json.decode(str));

String checkerToJson(Checker data) => json.encode(data.toJson());

class Checker {
  Result result;
  String msg;
  String status;

  Checker({
    this.result,
    this.msg,
    this.status,
  });

  factory Checker.fromJson(Map<String, dynamic> json) => Checker(
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
  String versionCode;
  int statusMember;

  Result({
    this.versionCode,
    this.statusMember,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    versionCode: json["version_code"],
    statusMember: json["status_member"],
  );

  Map<String, dynamic> toJson() => {
    "version_code": versionCode,
    "status_member": statusMember,
  };
}
