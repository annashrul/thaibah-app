// To parse this JSON data, do
//
//     final suratModel = suratModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

SuratModel suratModelFromJson(String str) => SuratModel.fromJson(json.decode(str));

String suratModelToJson(SuratModel data) => json.encode(data.toJson());

class SuratModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  SuratModel({
    this.result,
    this.msg,
    this.status,
  });

  factory SuratModel.fromJson(Map<String, dynamic> json) => SuratModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class Result {
  String id;
  String suratIndonesia;
  String suratArab;
  String arti;
  int jumlahAyat;
  String tempatTurun;
  int urutanPewahyuan;
  String suratAudio;

  Result({
    this.id,
    this.suratIndonesia,
    this.suratArab,
    this.arti,
    this.jumlahAyat,
    this.tempatTurun,
    this.urutanPewahyuan,
    this.suratAudio,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    suratIndonesia: json["surat_indonesia"],
    suratArab: json["surat_arab"],
    arti: json["arti"],
    jumlahAyat: json["jumlah_ayat"],
    tempatTurun: json["tempat_turun"],
    urutanPewahyuan: json["urutan_pewahyuan"],
    suratAudio: json["surat_audio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surat_indonesia": suratIndonesia,
    "surat_arab": suratArab,
    "arti": arti,
    "jumlah_ayat": jumlahAyat,
    "tempat_turun": tempatTurun,
    "urutan_pewahyuan": urutanPewahyuan,
    "surat_audio": suratAudio,
  };
}
