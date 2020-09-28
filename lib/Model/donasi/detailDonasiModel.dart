// To parse this JSON data, do
//
//     final detailDonasiModel = detailDonasiModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

DetailDonasiModel detailDonasiModelFromJson(String str) => DetailDonasiModel.fromJson(json.decode(str));

String detailDonasiModelToJson(DetailDonasiModel data) => json.encode(data.toJson());

class DetailDonasiModel extends BaseModel {
  DetailDonasiModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DetailDonasiModel.fromJson(Map<String, dynamic> json) => DetailDonasiModel(
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
    this.penggalang,
    this.pictPenggalang,
    this.verifikasiPenggalang,
    this.terkumpul,
    this.persentase,
    this.todeadline,
    this.donatur,
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
  String penggalang;
  String pictPenggalang;
  int verifikasiPenggalang;
  int terkumpul;
  double persentase;
  String todeadline;
  List<Donatur> donatur;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
    penggalang: json["penggalang"],
    pictPenggalang: json["pict_penggalang"],
    verifikasiPenggalang: json["verifikasi_penggalang"],
    terkumpul: json["terkumpul"],
    persentase: json["persentase"].toDouble(),
    todeadline: json["todeadline"],
    donatur: List<Donatur>.from(json["donatur"].map((x) => Donatur.fromJson(x))),
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
    "penggalang": penggalang,
    "pict_penggalang": pictPenggalang,
    "verifikasi_penggalang": verifikasiPenggalang,
    "terkumpul": terkumpul,
    "persentase": persentase,
    "todeadline": todeadline,
    "donatur": List<dynamic>.from(donatur.map((x) => x.toJson())),
  };
}

class Donatur {
  Donatur({
    this.id,
    this.name,
    this.picture,
    this.nominal,
    this.rawNominal,
    this.nohp,
    this.pesan,
    this.createdAt,
    this.time,
  });

  String id;
  String name;
  String picture;
  String nominal;
  String rawNominal;
  String nohp;
  String pesan;
  DateTime createdAt;
  String time;

  factory Donatur.fromJson(Map<String, dynamic> json) => Donatur(
    id: json["id"],
    name: json["name"],
    picture: json["picture"],
    nominal: json["nominal"],
    rawNominal: json["raw_nominal"],
    nohp: json["nohp"],
    pesan: json["pesan"],
    createdAt: DateTime.parse(json["created_at"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "picture": picture,
    "nominal": nominal,
    "raw_nominal": rawNominal,
    "nohp": nohp,
    "pesan": pesan,
    "created_at": createdAt.toIso8601String(),
    "time": time,
  };
}
