// To parse this JSON data, do
//
//     final testimoniModel = testimoniModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

TestimoniModel testimoniModelFromJson(String str) => TestimoniModel.fromJson(json.decode(str));

String testimoniModelToJson(TestimoniModel data) => json.encode(data.toJson());

class TestimoniModel extends BaseModel {
    Result result;
    String msg;
    String status;

    TestimoniModel({
        this.result,
        this.msg,
        this.status,
    });

    factory TestimoniModel.fromJson(Map<String, dynamic> json) => TestimoniModel(
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
    String name;
    String caption;
    String thumbnail;
    DateTime createdAt;
    DateTime updatedAt;
    int rating;
    String video;
    int type;

    Datum({
        this.id,
        this.name,
        this.caption,
        this.thumbnail,
        this.createdAt,
        this.updatedAt,
        this.rating,
        this.video,
        this.type,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        caption: json["caption"],
        thumbnail: json["thumbnail"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        rating: json["rating"],
        video: json["video"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "caption": caption,
        "thumbnail": thumbnail,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "rating": rating,
        "video": video,
        "type": type,
    };
}
