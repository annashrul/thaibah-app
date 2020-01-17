// To parse this JSON data, do
//
//     final categoryDoaModel = categoryDoaModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CategoryDoaModel categoryDoaModelFromJson(String str) => CategoryDoaModel.fromJson(json.decode(str));

String categoryDoaModelToJson(CategoryDoaModel data) => json.encode(data.toJson());

class CategoryDoaModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  CategoryDoaModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CategoryDoaModel.fromJson(Map<String, dynamic> json) => CategoryDoaModel(
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
  var id;
  var title;
  var countcontent;
  var desc;
  var image;
  var thumbnail;
  dynamic createdAt;
  dynamic updatedAt;

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
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "countcontent": countcontent,
    "desc": desc,
    "image": image,
    "thumbnail": thumbnail,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
