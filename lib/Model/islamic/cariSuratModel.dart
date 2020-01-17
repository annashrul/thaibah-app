// To parse this JSON data, do
//
//     final cariSuratModel = cariSuratModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CariSuratModel cariSuratModelFromJson(String str) => CariSuratModel.fromJson(json.decode(str));

String cariSuratModelToJson(CariSuratModel data) => json.encode(data.toJson());

class CariSuratModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  CariSuratModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CariSuratModel.fromJson(Map<String, dynamic> json) => CariSuratModel(
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
  int surat;
  String surahNama;
  String surahArti;
  int ayat;
  String surahAyat;
  String arabic;
  String terjemahan;
  String audio;

  Result({
    this.id,
    this.surat,
    this.surahNama,
    this.surahArti,
    this.ayat,
    this.surahAyat,
    this.arabic,
    this.terjemahan,
    this.audio,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    surat: json["surat"],
    surahNama: json["surah_nama"],
    surahArti: json["surah_arti"],
    ayat: json["ayat"],
    surahAyat: json["surah_ayat"],
    arabic: json["arabic"],
    terjemahan: json["terjemahan"],
    audio: json["audio"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "surat": surat,
    "surah_nama": surahNama,
    "surah_arti": surahArti,
    "ayat": ayat,
    "surah_ayat": surahAyat,
    "arabic": arabic,
    "terjemahan": terjemahan,
    "audio": audio,
  };
}
