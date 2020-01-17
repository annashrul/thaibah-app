// To parse this JSON data, do
//
//     final ongkirModel = ongkirModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

OngkirModel ongkirModelFromJson(String str) => OngkirModel.fromJson(json.decode(str));

String ongkirModelToJson(OngkirModel data) => json.encode(data.toJson());

class OngkirModel extends BaseModel {
  Result result;
  String msg;
  String status;

  OngkirModel({
    this.result,
    this.msg,
    this.status,
  });

  factory OngkirModel.fromJson(Map<String, dynamic> json) => OngkirModel(
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
  String asal;
  String tujuan;
  String kurir;
  String name;
  List<Ongkir> ongkir;

  Result({
    this.asal,
    this.tujuan,
    this.kurir,
    this.name,
    this.ongkir,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    asal: json["asal"],
    tujuan: json["tujuan"],
    kurir: json["kurir"],
    name: json["name"],
    ongkir: List<Ongkir>.from(json["ongkir"].map((x) => Ongkir.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "asal": asal,
    "tujuan": tujuan,
    "kurir": kurir,
    "name": name,
    "ongkir": List<dynamic>.from(ongkir.map((x) => x.toJson())),
  };

//  map(Function(Ongkir items) param0) {}
}

class Ongkir {
  String service;
  String description;
  int cost;
  String estimasi;

  Ongkir({
    this.service,
    this.description,
    this.cost,
    this.estimasi,
  });

  factory Ongkir.fromJson(Map<String, dynamic> json) => Ongkir(
    service: json["service"],
    description: json["description"],
    cost: json["cost"],
    estimasi: json["estimasi"],
  );

  Map<String, dynamic> toJson() => {
    "service": service,
    "description": description,
    "cost": cost,
    "estimasi": estimasi,
  };
}
