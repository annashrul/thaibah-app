// To parse this JSON data, do
//
//     final kotaModel = kotaModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

KotaModel kotaModelFromJson(String str) => KotaModel.fromJson(json.decode(str));

String kotaModelToJson(KotaModel data) => json.encode(data.toJson());

class KotaModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  KotaModel({
    this.result,
    this.msg,
    this.status,
  });

  factory KotaModel.fromJson(Map<String, dynamic> json) => KotaModel(
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
  Provinsi provinsi;
  String name;
  String postalCode;

  Result({
    this.id,
    this.provinsi,
    this.name,
    this.postalCode,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    provinsi: provinsiValues.map[json["provinsi"]],
    name: json["name"],
    postalCode: json["postal_code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provinsi": provinsiValues.reverse[provinsi],
    "name": name,
    "postal_code": postalCode,
  };
}

enum Provinsi { THE_9 }

final provinsiValues = EnumValues({
  "9 ": Provinsi.THE_9
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
