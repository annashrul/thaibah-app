// To parse this JSON data, do
//
//     final onboardingModel = onboardingModelFromJson(jsonString);

import 'dart:convert';

OnboardingModel onboardingModelFromJson(String str) => OnboardingModel.fromJson(json.decode(str));

String onboardingModelToJson(OnboardingModel data) => json.encode(data.toJson());

class OnboardingModel {
  List<Result> result;
  String msg;
  String status;

  OnboardingModel({
    this.result,
    this.msg,
    this.status,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) => OnboardingModel(
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
  String logo;
  String picture;
  String title;
  String description;

  Result({
    this.logo,
    this.picture,
    this.title,
    this.description,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    logo: json["logo"],
    picture: json["picture"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "logo": logo,
    "picture": picture,
    "title": title,
    "description": description,
  };
}
