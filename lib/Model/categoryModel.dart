// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CategoryModel categoryModelFromJson(String str) => CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  CategoryModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
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
  String countcontent;
  String desc;
  String image;
  String thumbnail;
  DateTime createdAt;
  DateTime updatedAt;

  Result({
    this.id,
    this.title,
    this.countcontent,
    this.desc,
    this.image,
    this.thumbnail,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    countcontent: json["countcontent"],
    desc: json["desc"],
    image: json["image"],
    thumbnail: json["thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "countcontent": countcontent,
    "desc": desc,
    "image": image,
    "thumbnail": thumbnail,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
