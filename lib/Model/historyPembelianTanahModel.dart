// To parse this JSON data, do
//
//     final historyPembelianTanahModel = historyPembelianTanahModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryPembelianTanahModel historyPembelianTanahModelFromJson(String str) => HistoryPembelianTanahModel.fromJson(json.decode(str));

String historyPembelianTanahModelToJson(HistoryPembelianTanahModel data) => json.encode(data.toJson());

class HistoryPembelianTanahModel extends BaseModel {
  Result result;
  String msg;
  String status;

  HistoryPembelianTanahModel({
    this.result,
    this.msg,
    this.status,
  });

  factory HistoryPembelianTanahModel.fromJson(Map<String, dynamic> json) => HistoryPembelianTanahModel(
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
  String idMember;
  String idProduct;
  String name;
  String namaProduk;
  String price;
  int status;
  String namaPembeli;
  String nohpPembeli;
  String pekerjaanPembeli;
  String alamatPembeli;
  String ktpPembeli;
  String kkPembeli;
  String npwpPembeli;
  DateTime createdAt;
  String kdReferral;
  String picture;

  Datum({
    this.id,
    this.idMember,
    this.idProduct,
    this.name,
    this.namaProduk,
    this.price,
    this.status,
    this.namaPembeli,
    this.nohpPembeli,
    this.pekerjaanPembeli,
    this.alamatPembeli,
    this.ktpPembeli,
    this.kkPembeli,
    this.npwpPembeli,
    this.createdAt,
    this.kdReferral,
    this.picture,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idMember: json["id_member"],
    idProduct: json["id_product"],
    name: json["name"],
    namaProduk: json["nama_produk"],
    price: json["price"],
    status: json["status"],
    namaPembeli: json["nama_pembeli"],
    nohpPembeli: json["nohp_pembeli"],
    pekerjaanPembeli: json["pekerjaan_pembeli"],
    alamatPembeli: json["alamat_pembeli"],
    ktpPembeli: json["ktp_pembeli"],
    kkPembeli: json["kk_pembeli"],
    npwpPembeli: json["npwp_pembeli"],
    createdAt: DateTime.parse(json["created_at"]),
    kdReferral: json["kd_referral"],
    picture: json["picture"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "id_product": idProduct,
    "name": name,
    "nama_produk": namaProduk,
    "price": price,
    "status": status,
    "nama_pembeli": namaPembeli,
    "nohp_pembeli": nohpPembeli,
    "pekerjaan_pembeli": pekerjaanPembeli,
    "alamat_pembeli": alamatPembeli,
    "ktp_pembeli": ktpPembeli,
    "kk_pembeli": kkPembeli,
    "npwp_pembeli": npwpPembeli,
    "created_at": createdAt.toIso8601String(),
    "kd_referral": kdReferral,
    "picture": picture,
  };
}
