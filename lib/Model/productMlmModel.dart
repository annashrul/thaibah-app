// To parse this JSON data, do
//
//     final productMlmModel = productMlmModelFromJson(jsonString);

import 'dart:convert';
import 'package:thaibah/Model/base_model.dart';

ProductMlmModel productMlmModelFromJson(String str) => ProductMlmModel.fromJson(json.decode(str));

String productMlmModelToJson(ProductMlmModel data) => json.encode(data.toJson());

class ProductMlmModel extends BaseModel {
    Result result;
    String msg;
    String status;

    ProductMlmModel({
        this.result,
        this.msg,
        this.status,
    });

    factory ProductMlmModel.fromJson(Map<String, dynamic> json) => ProductMlmModel(
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
    String penjual;
    String title;
    int type;
    String price;
    String satuan;
    String rawPrice;
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
        this.satuan,
        this.rawPrice,
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
        satuan: json["satuan"],
        rawPrice: json["raw_price"],
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
        "satuan": satuan,
        "raw_price": rawPrice,
        "qty": qty,
        "picture": picture,
        "descriptions": descriptions,
        "category": category,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
