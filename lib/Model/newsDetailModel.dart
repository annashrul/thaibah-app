// To parse this JSON data, do
//
//     final newsDetailModel = newsDetailModelFromJson(jsonString);

import 'dart:convert';

import 'base_model.dart';

NewsDetailModel newsDetailModelFromJson(String str) => NewsDetailModel.fromJson(json.decode(str));

String newsDetailModelToJson(NewsDetailModel data) => json.encode(data.toJson());

class NewsDetailModel extends BaseModel {
    Result result;
    String msg;
    String status;

    NewsDetailModel({
        this.result,
        this.msg,
        this.status,
    });

    factory NewsDetailModel.fromJson(Map<String, dynamic> json) => NewsDetailModel(
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
    String id;
    String idMember;
    int idCategory;
    String penulis;
    String title;
    String slug;
    String picture;
    String thumbnail;
    String caption;
    String category;
    String createdAt;

    Result({
        this.id,
        this.idMember,
        this.idCategory,
        this.penulis,
        this.title,
        this.slug,
        this.picture,
        this.thumbnail,
        this.caption,
        this.category,
        this.createdAt,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        idMember: json["id_member"],
        idCategory: json["id_category"],
        penulis: json["penulis"],
        title: json["title"],
        slug: json["slug"],
        picture: json["picture"],
        thumbnail: json["thumbnail"],
        caption: json["caption"],
        category: json["category"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_member": idMember,
        "id_category": idCategory,
        "penulis": penulis,
        "title": title,
        "slug": slug,
        "picture": picture,
        "thumbnail": thumbnail,
        "caption": caption,
        "category": category,
        "created_at": createdAt,
    };
}
