// To parse this JSON data, do
//
//     final historyPenarikanModel = historyPenarikanModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryPenarikanModel historyPenarikanModelFromJson(String str) => HistoryPenarikanModel.fromJson(json.decode(str));

String historyPenarikanModelToJson(HistoryPenarikanModel data) => json.encode(data.toJson());

class HistoryPenarikanModel extends BaseModel {
  Result result;
  String msg;
  String status;

  HistoryPenarikanModel({
    this.result,
    this.msg,
    this.status,
  });

  factory HistoryPenarikanModel.fromJson(Map<String, dynamic> json) => HistoryPenarikanModel(
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
  String name;
  String idMember;
  String amount;
  int charge;
  String accHolderName;
  String accNumber;
  String bankcode;
  DateTime createdAt;
  int status;

  Datum({
    this.id,
    this.name,
    this.idMember,
    this.amount,
    this.charge,
    this.accHolderName,
    this.accNumber,
    this.bankcode,
    this.createdAt,
    this.status,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    idMember: json["id_member"],
    amount: json["amount"],
    charge: json["charge"],
    accHolderName: json["acc_holder_name"],
    accNumber: json["acc_number"],
    bankcode: json["bankcode"],
    createdAt: DateTime.parse(json["created_at"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "id_member": idMember,
    "amount": amount,
    "charge": charge,
    "acc_holder_name": accHolderName,
    "acc_number": accNumber,
    "bankcode": bankcode,
    "created_at": createdAt.toIso8601String(),
    "status": status,
  };
}
