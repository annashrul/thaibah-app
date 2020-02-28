// To parse this JSON data, do
//
//     final listLikeSosmedModel = listLikeSosmedModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListLikeSosmedModel listLikeSosmedModelFromJson(String str) => ListLikeSosmedModel.fromJson(json.decode(str));

String listLikeSosmedModelToJson(ListLikeSosmedModel data) => json.encode(data.toJson());

class ListLikeSosmedModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  ListLikeSosmedModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListLikeSosmedModel.fromJson(Map<String, dynamic> json) => ListLikeSosmedModel(
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
  String likers;
  String picture;
  DateTime createdAt;

  Result({
    this.likers,
    this.picture,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    likers: json["likers"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "likers": likers,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
  };
}
