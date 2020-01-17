// To parse this JSON data, do
//
//     final doaModel = doaModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

DoaModel doaModelFromJson(String str) => DoaModel.fromJson(json.decode(str));

String doaModelToJson(DoaModel data) => json.encode(data.toJson());

class DoaModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  DoaModel({
    this.result,
    this.msg,
    this.status,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) => DoaModel(
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
  int idSub;
  String title;
  String sub;
  String arabic;
  String latin;
  String terjemahan;
  int type;
  bool checked;
  bool fav;
  bool note;
  String noteContent;

  Result({
    this.id,
    this.idSub,
    this.title,
    this.sub,
    this.arabic,
    this.latin,
    this.terjemahan,
    this.type,
    this.checked,
    this.fav,
    this.note,
    this.noteContent,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idSub: json["id_sub"],
    title: json["title"],
    sub: json["sub"],
    arabic: json["arabic"],
    latin: json["latin"],
    terjemahan: json["terjemahan"],
    type: json["type"],
    checked: json["checked"],
    fav: json["fav"],
    note: json["note"],
    noteContent: json["note_content"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_sub": idSub,
    "title": title,
    "sub": sub,
    "arabic": arabic,
    "latin": latin,
    "terjemahan": terjemahan,
    "type": type,
    "checked": checked,
    "fav": fav,
    "note": note,
    "note_content": noteContent,
  };
}
