// To parse this JSON data, do
//
//     final inspirationModel = inspirationModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

InspirationModel inspirationModelFromJson(String str) => InspirationModel.fromJson(json.decode(str));

String inspirationModelToJson(InspirationModel data) => json.encode(data.toJson());

class InspirationModel extends BaseModel {
  Result result;
  String msg;
  String status;

  InspirationModel({
    this.result,
    this.msg,
    this.status,
  });

  factory InspirationModel.fromJson(Map<String, dynamic> json) => InspirationModel(
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
  var count;
  var currentPage;
  var perpage;
  var lastPage;

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
  String video;
  String thumbnail;

  Datum({
    this.video,
    this.thumbnail,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    video: json["video"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "video": video,
    "thumbnail": thumbnail,
  };
}
