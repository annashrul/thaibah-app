// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

import 'base_model.dart';

HistoryModel historyModelFromJson(String str) => HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel extends BaseModel {
    Result result;
    String msg;
    String status;

    HistoryModel({
        this.result,
        this.msg,
        this.status,
    });

    factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
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
    String kdTrx;
    String idMember;
    String trxIn;
    String trxOut;
    String note;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        this.id,
        this.kdTrx,
        this.idMember,
        this.trxIn,
        this.trxOut,
        this.note,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        kdTrx: json["kd_trx"],
        idMember: json["id_member"],
        trxIn: json["trx_in"],
        trxOut: json["trx_out"],
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "kd_trx": kdTrx,
        "id_member": idMember,
        "trx_in": trxIn,
        "trx_out": trxOut,
        "note": note,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
