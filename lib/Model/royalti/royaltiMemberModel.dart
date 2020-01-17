// To parse this JSON data, do
//
//     final royaltiMemberModel = royaltiMemberModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

RoyaltiMemberModel royaltiMemberModelFromJson(String str) => RoyaltiMemberModel.fromJson(json.decode(str));

String royaltiMemberModelToJson(RoyaltiMemberModel data) => json.encode(data.toJson());

class RoyaltiMemberModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  RoyaltiMemberModel({
    this.result,
    this.msg,
    this.status,
  });

  factory RoyaltiMemberModel.fromJson(Map<String, dynamic> json) => RoyaltiMemberModel(
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
  String memberName;
  String referral;
  String level;
  double royalti;
  String kdTrx;
  List<Downline> downline;
  DateTime createdAt;
  DateTime updatedAt;
  String memberPicture;

  Result({
    this.id,
    this.idMember,
    this.memberName,
    this.referral,
    this.level,
    this.royalti,
    this.kdTrx,
    this.downline,
    this.createdAt,
    this.updatedAt,
    this.memberPicture,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    memberName: json["member_name"],
    referral: json["referral"],
    level: json["level"],
    royalti: json["royalti"].toDouble(),
    kdTrx: json["kd_trx"],
    downline: List<Downline>.from(json["downline"].map((x) => Downline.fromJson(x))),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    memberPicture: json["member_picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "member_name": memberName,
    "referral": referral,
    "level": level,
    "royalti": royalti,
    "kd_trx": kdTrx,
    "downline": List<dynamic>.from(downline.map((x) => x.toJson())),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "member_picture": memberPicture,
  };
}

class Downline {
  String omset;
  String downlineName;
  String downlineReferral;
  String downlinePicture;
  String level;
  String minOmset;

  Downline({
    this.omset,
    this.downlineName,
    this.downlineReferral,
    this.downlinePicture,
    this.level,
    this.minOmset,
  });

  factory Downline.fromJson(Map<String, dynamic> json) => Downline(
    omset: json["omset"],
    downlineName: json["downline_name"],
    downlineReferral: json["downline_referral"],
    downlinePicture: json["downline_picture"],
    level: json["level"],
    minOmset: json["min_omset"],
  );

  Map<String, dynamic> toJson() => {
    "omset": omset,
    "downline_name": downlineName,
    "downline_referral": downlineReferral,
    "downline_picture": downlinePicture,
    "level": level,
    "min_omset": minOmset,
  };
}
