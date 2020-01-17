// To parse this JSON data, do
//
//     final levelModel = levelModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

LevelModel levelModelFromJson(String str) => LevelModel.fromJson(json.decode(str));

String levelModelToJson(LevelModel data) => json.encode(data.toJson());

class LevelModel extends BaseModel {
  Result result;
  String msg;
  String status;

  LevelModel({
    this.result,
    this.msg,
    this.status,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
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
  List<Datum> data;
  String saldoNasional;

  Result({
    this.data,
    this.saldoNasional,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    saldoNasional: json["saldo_nasional"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "saldo_nasional": saldoNasional,
  };
}

class Datum {
  int id;
  String name;
  int kaki;
  String omset;
  double royalti;
  DateTime createdAt;

  Datum({
    this.id,
    this.name,
    this.kaki,
    this.omset,
    this.royalti,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    kaki: json["kaki"],
    omset: json["omset"],
    royalti: json["royalti"].toDouble(),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "kaki": kaki,
    "omset": omset,
    "royalti": royalti,
    "created_at": createdAt.toIso8601String(),
  };
}
