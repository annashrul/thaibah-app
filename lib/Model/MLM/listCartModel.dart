// To parse this JSON data, do
//
//     final listCartModel = listCartModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListCartModel listCartModelFromJson(String str) => ListCartModel.fromJson(json.decode(str));

String listCartModelToJson(ListCartModel data) => json.encode(data.toJson());

class ListCartModel extends BaseModel {
  Result result;
  String msg;
  String status;

  ListCartModel({
    this.result,
    this.msg,
    this.status,
  });

  factory ListCartModel.fromJson(Map<String, dynamic> json) => ListCartModel(
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
  String total;
  int rawTotal;
  int jumlah;

  Result({
    this.data,
    this.total,
    this.rawTotal,
    this.jumlah,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    total: json["total"],
    rawTotal: json["raw_total"],
    jumlah: json["jumlah"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total": total,
    "raw_total": rawTotal,
    "jumlah": jumlah,
  };
}

class Datum {
  String id;
  String title;
  String picture;
  String idMember;
  String idProduct;
  String price;
  String rawPrice;
  String totalPrice;
  int rawTotalPrice;
  String qty;
  String weight;
  DateTime createdAt;

  Datum({
    this.id,
    this.title,
    this.picture,
    this.idMember,
    this.idProduct,
    this.price,
    this.rawPrice,
    this.totalPrice,
    this.rawTotalPrice,
    this.qty,
    this.weight,
    this.createdAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    picture: json["picture"],
    idMember: json["id_member"],
    idProduct: json["id_product"],
    price: json["price"],
    rawPrice: json["raw_price"],
    totalPrice: json["total_price"],
    rawTotalPrice: json["raw_total_price"],
    qty: json["qty"],
    weight: json["weight"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "picture": picture,
    "id_member": idMember,
    "id_product": idProduct,
    "price": price,
    "raw_price": rawPrice,
    "total_price": totalPrice,
    "raw_total_price": rawTotalPrice,
    "qty": qty,
    "weight": weight,
    "created_at": createdAt.toIso8601String(),
  };
}
