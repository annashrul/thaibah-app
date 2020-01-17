// To parse this JSON data, do
//
//     final nearbyMosqueModel = nearbyMosqueModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

NearbyMosqueModel nearbyMosqueModelFromJson(String str) => NearbyMosqueModel.fromJson(json.decode(str));

String nearbyMosqueModelToJson(NearbyMosqueModel data) => json.encode(data.toJson());

class NearbyMosqueModel extends BaseModel {
  List<Result> result;
  String msg;
  String status;

  NearbyMosqueModel({
    this.result,
    this.msg,
    this.status,
  });

  factory NearbyMosqueModel.fromJson(Map<String, dynamic> json) => NearbyMosqueModel(
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
  String name;
  String address;
  double lat;
  double lng;
  String maps;
  String distance;
  int distanceMeters;
  String city;
  String state;
  String country;

  Result({
    this.name,
    this.address,
    this.lat,
    this.lng,
    this.maps,
    this.distance,
    this.distanceMeters,
    this.city,
    this.state,
    this.country,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    name: json["name"],
    address: json["address"],
    lat: json["lat"].toDouble(),
    lng: json["lng"].toDouble(),
    maps: json["maps"],
    distance: json["distance"],
    distanceMeters: json["distance_meters"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "lat": lat,
    "lng": lng,
    "maps": maps,
    "distance": distance,
    "distance_meters": distanceMeters,
    "city": city,
    "state": state,
    "country": country,
  };
}
