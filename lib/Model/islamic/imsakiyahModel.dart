// To parse this JSON data, do
//
//     final prayerModel = prayerModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

PrayerModel prayerModelFromJson(String str) => PrayerModel.fromJson(json.decode(str));

String prayerModelToJson(PrayerModel data) => json.encode(data.toJson());

class PrayerModel extends BaseModel {
    PrayerModel({
        this.result,
        this.msg,
        this.status,
    });

    Result result;
    String msg;
    String status;

    factory PrayerModel.fromJson(Map<String, dynamic> json) => PrayerModel(
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
        this.imsak,
        this.rawImsak,
        this.sunrise,
        this.rawSunrise,
        this.fajr,
        this.rawFajr,
        this.dhuhr,
        this.rawDhuhr,
        this.asr,
        this.rawAsr,
        this.sunset,
        this.rawSunset,
        this.maghrib,
        this.rawMaghrib,
        this.isha,
        this.rawIsha,
        this.midnight,
        this.rawMidnight,
        this.city,
    });

    DateTime imsak;
    String rawImsak;
    DateTime sunrise;
    String rawSunrise;
    DateTime fajr;
    String rawFajr;
    DateTime dhuhr;
    String rawDhuhr;
    DateTime asr;
    String rawAsr;
    DateTime sunset;
    String rawSunset;
    DateTime maghrib;
    String rawMaghrib;
    DateTime isha;
    String rawIsha;
    DateTime midnight;
    String rawMidnight;
    String city;

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        imsak: DateTime.parse(json["Imsak"]),
        rawImsak: json["raw_imsak"],
        sunrise: DateTime.parse(json["Sunrise"]),
        rawSunrise: json["raw_Sunrise"],
        fajr: DateTime.parse(json["Fajr"]),
        rawFajr: json["raw_Fajr"],
        dhuhr: DateTime.parse(json["Dhuhr"]),
        rawDhuhr: json["raw_Dhuhr"],
        asr: DateTime.parse(json["Asr"]),
        rawAsr: json["raw_Asr"],
        sunset: DateTime.parse(json["Sunset"]),
        rawSunset: json["raw_Sunset"],
        maghrib: DateTime.parse(json["Maghrib"]),
        rawMaghrib: json["raw_Maghrib"],
        isha: DateTime.parse(json["Isha"]),
        rawIsha: json["raw_Isha"],
        midnight: DateTime.parse(json["Midnight"]),
        rawMidnight: json["raw_Midnight"],
        city: json["city"],
    );

    Map<String, dynamic> toJson() => {
        "Imsak": imsak.toIso8601String(),
        "raw_imsak": rawImsak,
        "Sunrise": sunrise.toIso8601String(),
        "raw_Sunrise": rawSunrise,
        "Fajr": fajr.toIso8601String(),
        "raw_Fajr": rawFajr,
        "Dhuhr": dhuhr.toIso8601String(),
        "raw_Dhuhr": rawDhuhr,
        "Asr": asr.toIso8601String(),
        "raw_Asr": rawAsr,
        "Sunset": sunset.toIso8601String(),
        "raw_Sunset": rawSunset,
        "Maghrib": maghrib.toIso8601String(),
        "raw_Maghrib": rawMaghrib,
        "Isha": isha.toIso8601String(),
        "raw_Isha": rawIsha,
        "Midnight": midnight.toIso8601String(),
        "raw_Midnight": rawMidnight,
        "city": city,
    };
}
