// To parse this JSON data, do
//
//     final subCategoryDoaModel = subCategoryDoaModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

SubCategoryDoaModel subCategoryDoaModelFromJson(String str) => SubCategoryDoaModel.fromJson(json.decode(str));

String subCategoryDoaModelToJson(SubCategoryDoaModel data) => json.encode(data.toJson());

class SubCategoryDoaModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  SubCategoryDoaModel({
    this.result,
    this.msg,
    this.status,
  });

  factory SubCategoryDoaModel.fromJson(Map<String, dynamic> json) => SubCategoryDoaModel(
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
  int id;
  String title;
  String image;
  DateTime createdAt;
  DateTime updatedAt;
  int idCategory;

  Result({
    this.id,
    this.title,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.idCategory,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    idCategory: json["id_category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "id_category": idCategory,
  };
}
