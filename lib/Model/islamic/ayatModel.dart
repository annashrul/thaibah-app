// To parse this JSON data, do
//
//     final ayatModel = ayatModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

AyatModel ayatModelFromJson(String str) => AyatModel.fromJson(json.decode(str));

String ayatModelToJson(AyatModel data) => json.encode(data.toJson());

class AyatModel extends BaseModel {
  Result result;
  String msg;
  String status;

  AyatModel({
    this.result,
    this.msg,
    this.status,
  });

  factory AyatModel.fromJson(Map<String, dynamic> json) => AyatModel(
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
  int surat;
  String surahNama;
  String surahArti;
  int ayat;
  String surahAyat;
  String arabic;
  String terjemahan;
  String audio;
  int audioDurasi;
  bool checked;
  bool fav;
  bool note;
  String noteContent;

  Datum({
    this.id,
    this.surat,
    this.surahNama,
    this.surahArti,
    this.ayat,
    this.surahAyat,
    this.arabic,
    this.terjemahan,
    this.audio,
    this.audioDurasi,
    this.checked,
    this.fav,
    this.note,
    this.noteContent,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    surat: json["surat"],
    surahNama: json["surah_nama"],
    surahArti: json["surah_arti"],
    ayat: json["ayat"],
    surahAyat: json["surah_ayat"],
    arabic: json["arabic"],
    terjemahan: json["terjemahan"],
    audio: json["audio"],
    audioDurasi: json["audio_durasi"],
    checked: json["checked"],
    fav: json["fav"],
    note: json["note"],
    noteContent: json["note_content"],
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
    "audio_durasi": audioDurasi,
    "checked": checked,
    "fav": fav,
    "note": note,
    "note_content": noteContent,
  };
}
