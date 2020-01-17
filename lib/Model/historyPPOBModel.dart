// To parse this JSON data, do
//
//     final historyPpobModel = historyPpobModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryPpobModel historyPpobModelFromJson(String str) => HistoryPpobModel.fromJson(json.decode(str));

String historyPpobModelToJson(HistoryPpobModel data) => json.encode(data.toJson());

class HistoryPpobModel extends BaseModel {
  Result result;
  String msg;
  String status;

  HistoryPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  factory HistoryPpobModel.fromJson(Map<String, dynamic> json) => HistoryPpobModel(
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
  int count;
  int currentPage;
  String perpage;
  int lastPage;

  Result({
    this.data,
    this.count,
    this.currentPage,
    this.perpage,
    this.lastPage,
  });

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
  String id;
  String idMember;
  String name;
  String kdTrx;
  String code;
  String target;
  String mtrpln;
  String token;
  int status;
  String note;
  DateTime createdAt;
  String trxid;

  Datum({
    this.id,
    this.idMember,
    this.name,
    this.kdTrx,
    this.code,
    this.target,
    this.mtrpln,
    this.token,
    this.status,
    this.note,
    this.createdAt,
    this.trxid,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idMember: json["id_member"],
    name: json["name"],
    kdTrx: json["kd_trx"],
    code: json["code"],
    target: json["target"],
    mtrpln: json["mtrpln"],
    token: json["token"],
    status: json["status"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    trxid: json["trxid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "name": name,
    "kd_trx": kdTrx,
    "code": code,
    "target": target,
    "mtrpln": mtrpln,
    "token": token,
    "status": status,
    "note": note,
    "created_at": createdAt.toIso8601String(),
    "trxid": trxid,
  };
}
