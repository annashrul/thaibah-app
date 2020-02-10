// To parse this JSON data, do
//
//     final downlineModel = downlineModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

DownlineModel downlineModelFromJson(String str) => DownlineModel.fromJson(json.decode(str));

String downlineModelToJson(DownlineModel data) => json.encode(data.toJson());

class DownlineModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  DownlineModel({
    this.result,
    this.msg,
    this.status,
  });

  factory DownlineModel.fromJson(Map<String, dynamic> json) => DownlineModel(
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
  String kdReferral;
  String picture;
  String idDownline;
  String downlineName;
  String downlineKdFounder;
  String downlineOmset;
  String downlineStp;
  String downlineSocketid;
  String downlineReferral;
  String downlineReferralRaw;
  String downlinePicture;
  String downline;
  DateTime createdAt;
  int generasi;

  Result({
    this.id,
    this.name,
    this.kdReferral,
    this.picture,
    this.idDownline,
    this.downlineName,
    this.downlineKdFounder,
    this.downlineOmset,
    this.downlineStp,
    this.downlineSocketid,
    this.downlineReferral,
    this.downlineReferralRaw,
    this.downlinePicture,
    this.downline,
    this.createdAt,
    this.generasi,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    kdReferral: json["kd_referral"],
    picture: json["picture"],
    idDownline: json["id_downline"],
    downlineName: json["downline_name"],
    downlineKdFounder: json["downline_kd_founder"],
    downlineOmset: json["downline_omset"],
    downlineStp: json["downline_stp"],
    downlineSocketid: json["downline_socketid"],
    downlineReferral: json["downline_referral"],
    downlineReferralRaw: json["downline_referral_raw"],
    downlinePicture: json["downline_picture"],
    downline: json["downline"],
    createdAt: DateTime.parse(json["created_at"]),
    generasi: json["generasi"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "kd_referral": kdReferral,
    "picture": picture,
    "id_downline": idDownline,
    "downline_name": downlineName,
    "downline_kd_founder": downlineKdFounder,
    "downline_omset": downlineOmset,
    "downline_stp": downlineStp,
    "downline_socketid": downlineSocketid,
    "downline_referral": downlineReferral,
    "downline_referral_raw": downlineReferralRaw,
    "downline_picture": downlinePicture,
    "downline": downline,
    "created_at": createdAt.toIso8601String(),
    "generasi": generasi,
  };
}
