// To parse this JSON data, do
//
//     final mlmList = mlmListFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

MlmList mlmListFromJson(String str) => MlmList.fromJson(json.decode(str));

String mlmListToJson(MlmList data) => json.encode(data.toJson());

class MlmList extends BaseModel{
    Result result;
    String msg;
    String status;

    MlmList({
        this.result,
        this.msg,
        this.status,
    });

    factory MlmList.fromJson(Map<String, dynamic> json) => MlmList(
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
    int perpage;
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
    String penjual;
    String title;
    int type;
    String price;
    int qty;
    String picture;
    String descriptions;
    String category;
    DateTime createdAt;
    DateTime updatedAt;

    Datum({
        this.id,
        this.penjual,
        this.title,
        this.type,
        this.price,
        this.qty,
        this.picture,
        this.descriptions,
        this.category,
        this.createdAt,
        this.updatedAt,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        penjual: json["penjual"],
        title: json["title"],
        type: json["type"],
        price: json["price"],
        qty: json["qty"],
        picture: json["picture"],
        descriptions: json["descriptions"],
        category: json["category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "penjual": penjual,
        "title": title,
        "type": type,
        "price": price,
        "qty": qty,
        "picture": picture,
        "descriptions": descriptions,
        "category": category,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
