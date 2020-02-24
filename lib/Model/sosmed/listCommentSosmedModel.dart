// To parse this JSON data, do
//
//     final listCommentSosmedModel = listCommentSosmedModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListCommentSosmedModel listCommentSosmedModelFromJson(String str) => ListCommentSosmedModel.fromJson(json.decode(str));

String listCommentSosmedModelToJson(ListCommentSosmedModel data) => json.encode(data.toJson());

class ListCommentSosmedModel extends BaseModel {
  Result result;
  String msg;
  String status;

  ListCommentSosmedModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListCommentSosmedModel.fromJson(Map<String, dynamic> json) => ListCommentSosmedModel(
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

  Result({
    this.data,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String id;
  String idContent;
  String penulis;
  String caption;
  String idMember;
  String pengirim;
  String komen;
  DateTime createdAt;
  DateTime updatedAt;
  int type;

  Datum({
    this.id,
    this.idContent,
    this.penulis,
    this.caption,
    this.idMember,
    this.pengirim,
    this.komen,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idContent: json["id_content"],
    penulis: json["penulis"],
    caption: json["caption"],
    idMember: json["id_member"],
    pengirim: json["pengirim"],
    komen: json["komen"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_content": idContent,
    "penulis": penulis,
    "caption": caption,
    "id_member": idMember,
    "pengirim": pengirim,
    "komen": komen,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "type": type,
  };
}
