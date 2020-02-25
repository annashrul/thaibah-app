// To parse this JSON data, do
//
//     final listDetailSosmedModel = listDetailSosmedModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListDetailSosmedModel listDetailSosmedModelFromJson(String str) => ListDetailSosmedModel.fromJson(json.decode(str));

String listDetailSosmedModelToJson(ListDetailSosmedModel data) => json.encode(data.toJson());

class ListDetailSosmedModel extends BaseModel {
  Result result;
  String msg;
  String status;

  ListDetailSosmedModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListDetailSosmedModel.fromJson(Map<String, dynamic> json) => ListDetailSosmedModel(
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
  String id;
  String idMember;
  String penulisPicture;
  String penulis;
  String caption;
  String picture;
  String thumbnail;
  List<Comment> comment;
  String comments;
  String likes;
  bool isLike;
  String createdAt;
  DateTime updatedAt;

  Result({
    this.id,
    this.idMember,
    this.penulisPicture,
    this.penulis,
    this.caption,
    this.picture,
    this.thumbnail,
    this.comment,
    this.comments,
    this.likes,
    this.isLike,
    this.createdAt,
    this.updatedAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    penulisPicture: json["penulis_picture"],
    penulis: json["penulis"],
    caption: json["caption"],
    picture: json["picture"],
    thumbnail: json["thumbnail"],
    comment: List<Comment>.from(json["comment"].map((x) => Comment.fromJson(x))),
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
    "comment": List<dynamic>.from(comment.map((x) => x.toJson())),
    "comments": comments,
    "likes": likes,
    "isLike": isLike,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Comment {
  String id;
  String idContent;
  String idMember;
  String name;
  String profilePicture;
  String caption;
  String createdAt;

  Comment({
    this.id,
    this.idContent,
    this.idMember,
    this.name,
    this.profilePicture,
    this.caption,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json["id"],
    idContent: json["id_content"],
    idMember: json["id_member"],
    name: json["name"],
    profilePicture: json["profile_picture"],
    caption: json["caption"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_content": idContent,
    "id_member": idMember,
    "name": name,
    "profile_picture": profilePicture,
    "caption": caption,
    "created_at": createdAt,
  };
}
