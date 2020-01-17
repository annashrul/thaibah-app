// To parse this JSON data, do
//
//     final checkFavModel = checkFavModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CheckFavModel checkFavModelFromJson(String str) => CheckFavModel.fromJson(json.decode(str));

String checkFavModelToJson(CheckFavModel data) => json.encode(data.toJson());

class CheckFavModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  CheckFavModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CheckFavModel.fromJson(Map<String, dynamic> json) => CheckFavModel(
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
  String idMember;
  String idAyat;
  int surat;
  String surahNama;
  String surahArti;
  int ayat;
  String surahAyat;
  String arabic;
  String terjemahan;
  String audio;
  String note;

  Result({
    this.id,
    this.idMember,
    this.idAyat,
    this.surat,
    this.surahNama,
    this.surahArti,
    this.ayat,
    this.surahAyat,
    this.arabic,
    this.terjemahan,
    this.audio,
    this.note,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    idAyat: json["id_ayat"],
    surat: json["surat"],
    surahNama: json["surah_nama"],
    surahArti: json["surah_arti"],
    ayat: json["ayat"],
    surahAyat: json["surah_ayat"],
    arabic: json["arabic"],
    terjemahan: json["terjemahan"],
    audio: json["audio"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "id_ayat": idAyat,
    "surat": surat,
    "surah_nama": surahNama,
    "surah_arti": surahArti,
    "ayat": ayat,
    "surah_ayat": surahAyat,
    "arabic": arabic,
    "terjemahan": terjemahan,
    "audio": audio,
    "note": note,
  };
}

