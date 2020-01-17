// To parse this JSON data, do
//
//     final productMlmDetailModel = productMlmDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ProductMlmDetailModel productMlmDetailModelFromJson(String str) => ProductMlmDetailModel.fromJson(json.decode(str));

String productMlmDetailModelToJson(ProductMlmDetailModel data) => json.encode(data.toJson());

class ProductMlmDetailModel extends BaseModel {
    Result result;
    String msg;
    String status;

    ProductMlmDetailModel({
        this.result,
        this.msg,
        this.status,
    });

    factory ProductMlmDetailModel.fromJson(Map<String, dynamic> json) => ProductMlmDetailModel(
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

    Result({
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

    factory Result.fromJson(Map<String, dynamic> json) => Result(
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
