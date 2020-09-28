// To parse this JSON data, do
//
//     final historyDonasiModel = historyDonasiModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryDonasiModel historyDonasiModelFromJson(String str) => HistoryDonasiModel.fromJson(json.decode(str));

String historyDonasiModelToJson(HistoryDonasiModel data) => json.encode(data.toJson());

class HistoryDonasiModel extends BaseModel {
  HistoryDonasiModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryDonasiModel.fromJson(Map<String, dynamic> json) => HistoryDonasiModel(
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
    this.total,
    this.perPage,
    this.offset,
    this.to,
    this.lastPage,
    this.currentPage,
    this.from,
    this.data,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "offset": offset,
    "to": to,
    "last_page": lastPage,
    "current_page": currentPage,
    "from": from,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.id,
    this.idMember,
    this.name,
    this.deviceid,
    this.idPendonasi,
    this.bankTujuan,
    this.bankName,
    this.amount,
    this.bukti,
    this.status,
    this.createdAt,
    this.idDonasi,
    this.title,
    this.gambar,
  });

  String totalrecords;
  String id;
  String idMember;
  String name;
  String deviceid;
  String idPendonasi;
  String bankTujuan;
  String bankName;
  int amount;
  String bukti;
  int status;
  DateTime createdAt;
  String idDonasi;
  String title;
  String gambar;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    idMember: json["id_member"],
    name: json["name"],
    deviceid: json["deviceid"],
    idPendonasi: json["id_pendonasi"],
    bankTujuan: json["bank_tujuan"],
    bankName: json["bank_name"],
    amount: json["amount"],
    bukti: json["bukti"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    idDonasi: json["id_donasi"],
    title: json["title"],
    gambar: json["gambar"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "id_member": idMember,
    "name": name,
    "deviceid": deviceid,
    "id_pendonasi": idPendonasi,
    "bank_tujuan": bankTujuan,
    "bank_name": bankName,
    "amount": amount,
    "bukti": bukti,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "id_donasi": idDonasi,
    "title": title,
    "gambar": gambar,
  };
}
