// To parse this JSON data, do
//
//     final kecamatanModel = kecamatanModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

KecamatanModel kecamatanModelFromJson(String str) => KecamatanModel.fromJson(json.decode(str));

String kecamatanModelToJson(KecamatanModel data) => json.encode(data.toJson());

class KecamatanModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  KecamatanModel({
    this.result,
    this.msg,
    this.status,
  });

  factory KecamatanModel.fromJson(Map<String, dynamic> json) => KecamatanModel(
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
  String subdistrictId;
  String provinceId;
  Province province;
  String cityId;
  City city;
  Type type;
  String subdistrictName;

  Result({
    this.subdistrictId,
    this.provinceId,
    this.province,
    this.cityId,
    this.city,
    this.type,
    this.subdistrictName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    subdistrictId: json["subdistrict_id"],
    provinceId: json["province_id"],
    province: provinceValues.map[json["province"]],
    cityId: json["city_id"],
    city: cityValues.map[json["city"]],
    type: typeValues.map[json["type"]],
    subdistrictName: json["subdistrict_name"],
  );

  Map<String, dynamic> toJson() => {
    "subdistrict_id": subdistrictId,
    "province_id": provinceId,
    "province": provinceValues.reverse[province],
    "city_id": cityId,
    "city": cityValues.reverse[city],
    "type": typeValues.reverse[type],
    "subdistrict_name": subdistrictName,
  };
}

enum City { BANDUNG_BARAT }

final cityValues = EnumValues({
  "Bandung Barat": City.BANDUNG_BARAT
});

enum Province { JAWA_BARAT }

final provinceValues = EnumValues({
  "Jawa Barat": Province.JAWA_BARAT
});

enum Type { KABUPATEN }

final typeValues = EnumValues({
  "Kabupaten": Type.KABUPATEN
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
