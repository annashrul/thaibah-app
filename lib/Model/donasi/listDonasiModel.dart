// To parse this JSON data, do
//
//     final listDonasiModel = listDonasiModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

ListDonasiModel listDonasiModelFromJson(String str) => ListDonasiModel.fromJson(json.decode(str));

String listDonasiModelToJson(ListDonasiModel data) => json.encode(data.toJson());

class ListDonasiModel extends BaseModel {
  ListDonasiModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ListDonasiModel.fromJson(Map<String, dynamic> json) => ListDonasiModel(
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
  Result({
    this.total,
    this.perPage,
    this.offset,
    this.to,
    this.lastPage,
    this.currentPage,
    this.from,
    this.data,
  });

  dynamic total;
  int perPage;
  int offset;
  int to;
  dynamic lastPage;
  int currentPage;
  int from;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "offset": offset,
    "to": to,
    "last_page": lastPage,
    "current_page": currentPage,
    "from": from,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.slug,
    this.target,
    this.deadline,
    this.deskripsi,
    this.gambar,
    this.video,
    this.status,
    this.nodeadline,
    this.idPenggalangDana,
    this.terkumpul,
    this.createdAt,
    this.persentase,
    this.todeadline,
    this.penggalang,
    this.pictPenggalang,
    this.verifikasiPenggalang,
  });

  String id;
  String title;
  String slug;
  String target;
  DateTime deadline;
  String deskripsi;
  String gambar;
  String video;
  int status;
  int nodeadline;
  String idPenggalangDana;
  String terkumpul;
  DateTime createdAt;
  double persentase;
  String todeadline;
  String penggalang;
  String pictPenggalang;
  int verifikasiPenggalang;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    slug: json["slug"],
    target: json["target"],
    deadline: DateTime.parse(json["deadline"]),
    deskripsi: json["deskripsi"],
    gambar: json["gambar"],
    video: json["video"],
    status: json["status"],
    nodeadline: json["nodeadline"],
    idPenggalangDana: json["id_penggalang_dana"],
    terkumpul: json["terkumpul"],
    createdAt: DateTime.parse(json["created_at"]),
    persentase: json["persentase"].toDouble(),
    todeadline: json["todeadline"],
    penggalang: json["penggalang"],
    pictPenggalang: json["pict_penggalang"],
    verifikasiPenggalang: json["verifikasi_penggalang"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "slug": slug,
    "target": target,
    "deadline": deadline.toIso8601String(),
    "deskripsi": deskripsi,
    "gambar": gambar,
    "video": video,
    "status": status,
    "nodeadline": nodeadline,
    "id_penggalang_dana": idPenggalangDana,
    "terkumpul": terkumpul,
    "created_at": createdAt.toIso8601String(),
    "persentase": persentase,
    "todeadline": todeadline,
    "penggalang": penggalang,
    "pict_penggalang": pictPenggalang,
    "verifikasi_penggalang": verifikasiPenggalang,
  };
}
