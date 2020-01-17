// To parse this JSON data, do
//
//     final detailHistoryPembelianSuplemenModel = detailHistoryPembelianSuplemenModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

DetailHistoryPembelianSuplemenModel detailHistoryPembelianSuplemenModelFromJson(String str) => DetailHistoryPembelianSuplemenModel.fromJson(json.decode(str));

String detailHistoryPembelianSuplemenModelToJson(DetailHistoryPembelianSuplemenModel data) => json.encode(data.toJson());

class DetailHistoryPembelianSuplemenModel extends BaseModel {
  Result result;
  String msg;
  String status;

  DetailHistoryPembelianSuplemenModel({
    this.result,
    this.msg,
    this.status,
  });

  factory DetailHistoryPembelianSuplemenModel.fromJson(Map<String, dynamic> json) => DetailHistoryPembelianSuplemenModel(
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
  List<Pembelian> pembelian;
  Detail detail;
  Pembayaran pembayaran;

  Result({
    this.pembelian,
    this.detail,
    this.pembayaran,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    pembelian: List<Pembelian>.from(json["pembelian"].map((x) => Pembelian.fromJson(x))),
    detail: Detail.fromJson(json["detail"]),
    pembayaran: Pembayaran.fromJson(json["pembayaran"]),
  );

  Map<String, dynamic> toJson() => {
    "pembelian": List<dynamic>.from(pembelian.map((x) => x.toJson())),
    "detail": detail.toJson(),
    "pembayaran": pembayaran.toJson(),
  };
}

class Detail {
  int status;
  String statusText;
  String kdTrx;
  String createdAt;

  Detail({
    this.status,
    this.statusText,
    this.kdTrx,
    this.createdAt,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    status: json["status"],
    statusText: json["status_text"],
    kdTrx: json["kd_trx"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_text": statusText,
    "kd_trx": kdTrx,
    "created_at": createdAt,
  };
}

class Pembayaran {
  String metode;
  String price;
  String rawPrice;
  int jmlItem;
  String weight;
  String kurir;
  String layanan;
  String ongkir;
  int rawOngkir;
  String resi;
  String alamatPengiriman;

  Pembayaran({
    this.metode,
    this.price,
    this.rawPrice,
    this.jmlItem,
    this.weight,
    this.kurir,
    this.layanan,
    this.ongkir,
    this.rawOngkir,
    this.resi,
    this.alamatPengiriman,
  });

  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    metode: json["metode"],
    price: json["price"],
    rawPrice: json["raw_price"],
    jmlItem: json["jml_item"],
    weight: json["weight"],
    kurir: json["kurir"],
    layanan: json["layanan"],
    ongkir: json["ongkir"],
    rawOngkir: json["raw_ongkir"],
    resi: json["resi"],
    alamatPengiriman: json["alamat_pengiriman"],
  );

  Map<String, dynamic> toJson() => {
    "metode": metode,
    "price": price,
    "raw_price": rawPrice,
    "jml_item": jmlItem,
    "weight": weight,
    "kurir": kurir,
    "layanan": layanan,
    "ongkir": ongkir,
    "raw_ongkir": rawOngkir,
    "resi": resi,
    "alamat_pengiriman": alamatPengiriman,
  };
}

class Pembelian {
  String id;
  String idProduk;
  String title;
  int weight;
  String price;
  int qty;
  DateTime createdAt;
  String picture;

  Pembelian({
    this.id,
    this.idProduk,
    this.title,
    this.weight,
    this.price,
    this.qty,
    this.createdAt,
    this.picture,
  });

  factory Pembelian.fromJson(Map<String, dynamic> json) => Pembelian(
    id: json["id"],
    idProduk: json["id_produk"],
    title: json["title"],
    weight: json["weight"],
    price: json["price"],
    qty: json["qty"],
    createdAt: DateTime.parse(json["created_at"]),
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_produk": idProduk,
    "title": title,
    "weight": weight,
    "price": price,
    "qty": qty,
    "created_at": createdAt.toIso8601String(),
    "picture": picture,
  };
}
