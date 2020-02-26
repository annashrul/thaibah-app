// To parse this JSON data, do
//
//     final listSosmedModel = listSosmedModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListSosmedModel listSosmedModelFromJson(String str) => ListSosmedModel.fromJson(json.decode(str));

String listSosmedModelToJson(ListSosmedModel data) => json.encode(data.toJson());

class ListSosmedModel extends BaseModel {
  Result result;
  String msg;
  String status;

  ListSosmedModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListSosmedModel.fromJson(Map<String, dynamic> json) => ListSosmedModel(
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
  int notif;
  int count;
  int currentPage;
  String perpage;
  int lastPage;

  Result({
    this.data,
    this.notif,
    this.count,
    this.currentPage,
    this.perpage,
    this.lastPage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    notif: json["notif"],
    count: json["count"],
    currentPage: json["current_page"],
    perpage: json["perpage"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "notif": notif,
    "count": count,
    "current_page": currentPage,
    "perpage": perpage,
    "last_page": lastPage,
  };
}

class Datum {
  String id;
  String idMember;
  String penulisPicture;
  String penulis;
  String caption;
  String picture;
  String thumbnail;
  String comments;
  String likes;
  bool isLike;
  String createdAt;
  DateTime updatedAt;

  Datum({
    this.id,
    this.idMember,
    this.penulisPicture,
    this.penulis,
    this.caption,
    this.picture,
    this.thumbnail,
    this.comments,
    this.likes,
    this.isLike,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idMember: json["id_member"],
    penulisPicture: json["penulis_picture"],
    penulis: json["penulis"],
    caption: json["caption"],
    picture: json["picture"],
    thumbnail: json["thumbnail"],
    comments: json["comments"],
    likes: json["likes"],
    isLike: json["isLike"],
    createdAt: json["created_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "penulis_picture": penulisPicture,
    "penulis": penulis,
    "caption": caption,
    "picture": picture,
    "thumbnail": thumbnail,
    "comments": comments,
    "likes": likes,
    "isLike": isLike,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}
