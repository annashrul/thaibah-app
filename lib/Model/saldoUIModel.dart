// To parse this JSON data, do
//
//     final saldoResponse = saldoResponseFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

SaldoResponse saldoResponseFromJson(String str) => SaldoResponse.fromJson(json.decode(str));

String saldoResponseToJson(SaldoResponse data) => json.encode(data.toJson());

class SaldoResponse extends BaseModel {
    Result result;
    String msg;
    String status;

    SaldoResponse({
        this.result,
        this.msg,
        this.status,
    });

    factory SaldoResponse.fromJson(Map<String, dynamic> json) => SaldoResponse(
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
    List<String> insertId;

    Result({
        this.insertId,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        insertId: List<String>.from(json["insertId"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "insertId": List<dynamic>.from(insertId.map((x) => x)),
    };
}
