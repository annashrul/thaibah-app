// To parse this JSON data, do
//
//     final productMlmSuplemenModel = productMlmSuplemenModelFromJson(jsonString);

import 'dart:convert';

import 'base_model.dart';

ProductMlmSuplemenModel productMlmSuplemenModelFromJson(String str) => ProductMlmSuplemenModel.fromJson(json.decode(str));

String productMlmSuplemenModelToJson(ProductMlmSuplemenModel data) => json.encode(data.toJson());

class ProductMlmSuplemenModel extends BaseModel {
    Result result;
    var msg;
    var status;

    ProductMlmSuplemenModel({
        this.result,
        this.msg,
        this.status,
    });

    factory ProductMlmSuplemenModel.fromJson(Map<String, dynamic> json) => ProductMlmSuplemenModel(
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
    var count;
    var currentPage;
    var perpage;
    var lastPage;

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
    var id;
    var penjual;
    var title;
    var type;
    var ppn;
    var price;
    var satuan;
    var totalPrice;
    var rawPrice;
    var totalPpn;
    var weight;
    var qty;
    var picture;
    var descriptions;
    var idCategory;
    var category;
    DateTime createdAt;
    DateTime updatedAt;
    var status;
    var satuanBarang;
    var isplatinum;
    var detail;

    Datum({
        this.id,
        this.penjual,
        this.title,
        this.type,
        this.ppn,
        this.price,
        this.satuan,
        this.totalPrice,
        this.rawPrice,
        this.totalPpn,
        this.weight,
        this.qty,
        this.picture,
        this.descriptions,
        this.idCategory,
        this.category,
        this.createdAt,
        this.updatedAt,
        this.status,
        this.satuanBarang,
        this.isplatinum,
        this.detail,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        penjual: json["penjual"],
        title: json["title"],
        type: json["type"],
        ppn: json["ppn"],
        price: json["price"],
        satuan: json["satuan"],
        totalPrice: json["total_price"],
        rawPrice: json["raw_price"],
        totalPpn: json["total_ppn"],
        weight: json["weight"],
        qty: json["qty"],
        picture: json["picture"],
        descriptions: json["descriptions"],
        idCategory: json["id_category"],
        category: json["category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        status: json["status"],
        satuanBarang: json["satuan_barang"],
        isplatinum: json["isplatinum"],
        detail: json["detail"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "penjual": penjual,
        "title": title,
        "type": type,
        "ppn": ppn,
        "price": price,
        "satuan": satuan,
        "total_price": totalPrice,
        "raw_price": rawPrice,
        "total_ppn": totalPpn,
        "weight": weight,
        "qty": qty,
        "picture": picture,
        "descriptions": descriptions,
        "id_category": idCategory,
        "category": category,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "status": status,
        "satuan_barang": satuanBarang,
        "isplatinum": isplatinum,
        "detail": detail,
    };
}
