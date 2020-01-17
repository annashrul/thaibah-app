// To parse this JSON data, do
//
//     final getDetailChekoutSuplemenModel = getDetailChekoutSuplemenModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

GetDetailChekoutSuplemenModel getDetailChekoutSuplemenModelFromJson(String str) => GetDetailChekoutSuplemenModel.fromJson(json.decode(str));

String getDetailChekoutSuplemenModelToJson(GetDetailChekoutSuplemenModel data) => json.encode(data.toJson());

class GetDetailChekoutSuplemenModel extends BaseModel {
  Result result;
  String msg;
  String status;

  GetDetailChekoutSuplemenModel({
    this.result,
    this.msg,
    this.status,
  });

  factory GetDetailChekoutSuplemenModel.fromJson(Map<String, dynamic> json) => GetDetailChekoutSuplemenModel(
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
  String address;
  String kdKec;
  String kecPengirim;
  List<Kurir> kurir;
  List<Produk> produk;
  int totalBayar;
  int totalQty;
  int jumlahBarang;
  String saldoMain;
  String saldoVoucher;
  bool masaVoucher;

  Result({
    this.address,
    this.kdKec,
    this.kecPengirim,
    this.kurir,
    this.produk,
    this.totalBayar,
    this.totalQty,
    this.jumlahBarang,
    this.saldoMain,
    this.saldoVoucher,
    this.masaVoucher,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    address: json["address"],
    kdKec: json["kd_kec"],
    kecPengirim: json["kec_pengirim"],
    kurir: List<Kurir>.from(json["kurir"].map((x) => Kurir.fromJson(x))),
    produk: List<Produk>.from(json["produk"].map((x) => Produk.fromJson(x))),
    totalBayar: json["total_bayar"],
    totalQty: json["total_qty"],
    jumlahBarang: json["jumlah_barang"],
    saldoMain: json["saldo_main"],
    saldoVoucher: json["saldo_voucher"],
    masaVoucher: json["masa_voucher"],
  );

  Map<String, dynamic> toJson() => {
    "address": address,
    "kd_kec": kdKec,
    "kec_pengirim": kecPengirim,
    "kurir": List<dynamic>.from(kurir.map((x) => x.toJson())),
    "produk": List<dynamic>.from(produk.map((x) => x.toJson())),
    "total_bayar": totalBayar,
    "total_qty": totalQty,
    "jumlah_barang": jumlahBarang,
    "saldo_main": saldoMain,
    "saldo_voucher": saldoVoucher,
    "masa_voucher": masaVoucher,
  };
}

class Kurir {
  String kurir;

  Kurir({
    this.kurir,
  });

  factory Kurir.fromJson(Map<String, dynamic> json) => Kurir(
    kurir: json["kurir"],
  );

  Map<String, dynamic> toJson() => {
    "kurir": kurir,
  };
}

class Produk {
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

  Produk({
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

  factory Produk.fromJson(Map<String, dynamic> json) => Produk(
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
