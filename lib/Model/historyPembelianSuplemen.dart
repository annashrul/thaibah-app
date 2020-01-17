// To parse this JSON data, do
//
//     final historyPembelianSuplemenModel = historyPembelianSuplemenModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

HistoryPembelianSuplemenModel historyPembelianSuplemenModelFromJson(String str) => HistoryPembelianSuplemenModel.fromJson(json.decode(str));

String historyPembelianSuplemenModelToJson(HistoryPembelianSuplemenModel data) => json.encode(data.toJson());

class HistoryPembelianSuplemenModel extends BaseModel {
  Result result;
  String msg;
  String status;

  HistoryPembelianSuplemenModel({
    this.result,
    this.msg,
    this.status,
  });

  factory HistoryPembelianSuplemenModel.fromJson(Map<String, dynamic> json) => HistoryPembelianSuplemenModel(
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
  Detail detail;
  var count;
  var currentPage;
  var perpage;
  var lastPage;

  Result({
    this.data,
    this.detail,
    this.count,
    this.currentPage,
    this.perpage,
    this.lastPage,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    detail: Detail.fromJson(json["detail"]),
    count: json["count"],
    currentPage: json["current_page"],
    perpage: json["perpage"],
    lastPage: json["last_page"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "detail": detail.toJson(),
    "count": count,
    "current_page": currentPage,
    "perpage": perpage,
    "last_page": lastPage,
  };
}

class Datum {
  String id;
  String idMember;
  String name;
  String idProduct;
  String price;
  int qty;
  String jasper;
  int ongkir;
  String kdTrx;
  dynamic resi;
  DateTime createdAt;
  String deviceid;
  int status;
  String alamat;
  String noTlp;
  String rawPrice;
  dynamic validResi;
  dynamic createResi;
  int typeAlamat;
  dynamic tglTerima;

  Datum({
    this.id,
    this.idMember,
    this.name,
    this.idProduct,
    this.price,
    this.qty,
    this.jasper,
    this.ongkir,
    this.kdTrx,
    this.resi,
    this.createdAt,
    this.deviceid,
    this.status,
    this.alamat,
    this.noTlp,
    this.rawPrice,
    this.validResi,
    this.createResi,
    this.typeAlamat,
    this.tglTerima,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    idMember: json["id_member"],
    name: json["name"],
    idProduct: json["id_product"],
    price: json["price"],
    qty: json["qty"],
    jasper: json["jasper"],
    ongkir: json["ongkir"],
    kdTrx: json["kd_trx"],
    resi: json["resi"],
    createdAt: DateTime.parse(json["created_at"]),
    deviceid: json["deviceid"],
    status: json["status"],
    alamat: json["alamat"],
    noTlp: json["no_tlp"],
    rawPrice: json["raw_price"],
    validResi: json["valid_resi"],
    createResi: json["create_resi"],
    typeAlamat: json["type_alamat"],
    tglTerima: json["tgl_terima"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "name": name,
    "id_product": idProduct,
    "price": price,
    "qty": qty,
    "jasper": jasper,
    "ongkir": ongkir,
    "kd_trx": kdTrx,
    "resi": resi,
    "created_at": createdAt.toIso8601String(),
    "deviceid": deviceid,
    "status": status,
    "alamat": alamat,
    "no_tlp": noTlp,
    "raw_price": rawPrice,
    "valid_resi": validResi,
    "create_resi": createResi,
    "type_alamat": typeAlamat,
    "tgl_terima": tglTerima,
  };
}

class Detail {
  String jumlah;
  String proses;
  String kirim;
  String terima;
  String nonresi;
  String unvalidresi;

  Detail({
    this.jumlah,
    this.proses,
    this.kirim,
    this.terima,
    this.nonresi,
    this.unvalidresi,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    jumlah: json["jumlah"],
    proses: json["proses"],
    kirim: json["kirim"],
    terima: json["terima"],
    nonresi: json["nonresi"],
    unvalidresi: json["unvalidresi"],
  );

  Map<String, dynamic> toJson() => {
    "jumlah": jumlah,
    "proses": proses,
    "kirim": kirim,
    "terima": terima,
    "nonresi": nonresi,
    "unvalidresi": unvalidresi,
  };
}
