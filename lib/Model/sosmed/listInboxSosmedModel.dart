// To parse this JSON data, do
//
//     final listInboxModel = listInboxModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListInboxModel listInboxModelFromJson(String str) => ListInboxModel.fromJson(json.decode(str));

String listInboxModelToJson(ListInboxModel data) => json.encode(data.toJson());

class ListInboxModel extends BaseModel {
  ListInboxModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ListInboxModel.fromJson(Map<String, dynamic> json) => ListInboxModel(
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
    this.data,
    this.count,
    this.currentPage,
    this.perpage,
    this.lastPage,
  });

  List<Datum> data;
  int count;
  int currentPage;
  int perpage;
  int lastPage;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    count: json["count"],
    currentPage: json["current_page"],
    perpage: json["perpage"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "count": count,
    "current_page": currentPage,
    "perpage": perpage,
    "last_page": lastPage,
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.caption,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.data,
    this.idMember,
    this.status,
  });

  String id;
  String title;
  String caption;
  String type;
  DateTime createdAt;
  DateTime updatedAt;
  DatumData data;
  String idMember;
  int status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    caption: json["caption"],
    type: json["type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    data: DatumData.fromJson(json["data"]),
    idMember: json["id_member"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "caption": caption,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "data": data.toJson(),
    "id_member": idMember,
    "status": status,
  };
}

class DatumData {
  DatumData({
    this.appId,
    this.data,
    this.headings,
    this.contents,
    this.priority,
    this.includePlayerIds,
  });

  String appId;
  DataData data;
  Contents headings;
  Contents contents;
  int priority;
  List<String> includePlayerIds;

  factory DatumData.fromJson(Map<String, dynamic> json) => DatumData(
    appId: json["app_id"],
    data: DataData.fromJson(json["data"]),
    headings: Contents.fromJson(json["headings"]),
    contents: Contents.fromJson(json["contents"]),
    priority: json["priority"],
    includePlayerIds: List<String>.from(json["include_player_ids"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "app_id": appId,
    "data": data.toJson(),
    "headings": headings.toJson(),
    "contents": contents.toJson(),
    "priority": priority,
    "include_player_ids": List<dynamic>.from(includePlayerIds.map((x) => x)),
  };
}

class Contents {
  Contents({
    this.en,
  });

  String en;

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class DataData {
  DataData({
    this.type,
  });

  String type;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
  };
}
