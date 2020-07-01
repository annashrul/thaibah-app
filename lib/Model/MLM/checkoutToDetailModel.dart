// To parse this JSON data, do
//
//     final checkoutToDetailModel = checkoutToDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CheckoutToDetailModel checkoutToDetailModelFromJson(String str) => CheckoutToDetailModel.fromJson(json.decode(str));

String checkoutToDetailModelToJson(CheckoutToDetailModel data) => json.encode(data.toJson());

class CheckoutToDetailModel extends BaseModel {
  CheckoutToDetailModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory CheckoutToDetailModel.fromJson(Map<String, dynamic> json) => CheckoutToDetailModel(
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
    this.tema,
    this.levelStatus,
  });

  String id;
  Tema tema;
  int levelStatus;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    tema: Tema.fromJson(json["tema"]),
    levelStatus: json["level_status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tema": tema.toJson(),
    "level_status": levelStatus,
  };
}

class Tema {
  Tema({
    this.warna1,
    this.warna2,
  });

  String warna1;
  String warna2;

  factory Tema.fromJson(Map<String, dynamic> json) => Tema(
    warna1: json["warna1"],
    warna2: json["warna2"],
  );

  Map<String, dynamic> toJson() => {
    "warna1": warna1,
    "warna2": warna2,
  };
}
