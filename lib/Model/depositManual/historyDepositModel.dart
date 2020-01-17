// To parse this JSON data, do
//
//     final historyDepositModel = historyDepositModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryDepositModel historyDepositModelFromJson(String str) => HistoryDepositModel.fromJson(json.decode(str));

String historyDepositModelToJson(HistoryDepositModel data) => json.encode(data.toJson());

class HistoryDepositModel extends BaseModel {
  Result result;
  String msg;
  String status;

  HistoryDepositModel({
    this.result,
    this.msg,
    this.status,
  });

  factory HistoryDepositModel.fromJson(Map<String, dynamic> json) => HistoryDepositModel(
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
  String amount;
  String bankName;
  String atasNama;
  String noRekening;
  String idDeposit;
  String picture;
  int status;
  DateTime createdAt;
  String name;
  String bukti;

  Datum({
    this.amount,
    this.bankName,
    this.atasNama,
    this.noRekening,
    this.idDeposit,
    this.picture,
    this.status,
    this.createdAt,
    this.name,
    this.bukti,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    amount: json["amount"],
    bankName: json["bank_name"],
    atasNama: json["atas_nama"],
    noRekening: json["no_rekening"],
    idDeposit: json["id_deposit"],
    picture: json["picture"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    name: json["name"],
    bukti: json["bukti"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "bank_name": bankName,
    "atas_nama": atasNama,
    "no_rekening": noRekening,
    "id_deposit": idDeposit,
    "picture": picture,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "name": name,
    "bukti": bukti,
  };
}
