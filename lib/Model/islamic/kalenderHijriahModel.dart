// To parse this JSON data, do
//
//     final kalenderHijriahModel = kalenderHijriahModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

KalenderHijriahModel kalenderHijriahModelFromJson(String str) => KalenderHijriahModel.fromJson(json.decode(str));

String kalenderHijriahModelToJson(KalenderHijriahModel data) => json.encode(data.toJson());

class KalenderHijriahModel extends BaseModel {
  Result result;
  String msg;
  String status;

  KalenderHijriahModel({
    this.result,
    this.msg,
    this.status,
  });

  factory KalenderHijriahModel.fromJson(Map<String, dynamic> json) => KalenderHijriahModel(
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
  List<Holiday> holiday;

  Result({
    this.data,
    this.holiday,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    holiday: List<Holiday>.from(json["holiday"].map((x) => Holiday.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "holiday": List<dynamic>.from(holiday.map((x) => x.toJson())),
  };
}

class Datum {
  Hijri hijri;
  Gregorian gregorian;

  Datum({
    this.hijri,
    this.gregorian,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    hijri: Hijri.fromJson(json["hijri"]),
    gregorian: Gregorian.fromJson(json["gregorian"]),
  );

  Map<String, dynamic> toJson() => {
    "hijri": hijri.toJson(),
    "gregorian": gregorian.toJson(),
  };
}

class Gregorian {
  String date;
  String format;
  String day;
  GregorianWeekday weekday;
  GregorianMonth month;
  String year;
  Designation designation;

  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
    date: json["date"],
    format: json["format"],
    day: json["day"],
    weekday: GregorianWeekday.fromJson(json["weekday"]),
    month: GregorianMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": format,
    "day": day,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
  };
}

class Designation {
  String abbreviated;
  String expanded;

  Designation({
    this.abbreviated,
    this.expanded,
  });

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
    abbreviated: json["abbreviated"],
    expanded: json["expanded"],
  );

  Map<String, dynamic> toJson() => {
    "abbreviated": abbreviated,
    "expanded": expanded,
  };
}

class GregorianMonth {
  int number;
  String en;

  GregorianMonth({
    this.number,
    this.en,
  });

  factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
    number: json["number"],
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": en,
  };
}

class GregorianWeekday {
  String en;

  GregorianWeekday({
    this.en,
  });

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) => GregorianWeekday(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class Hijri {
  String date;
  String format;
  String day;
  String dayArabic;
  String monthArabic;
  String yearArabic;
  HijriWeekday weekday;
  HijriMonth month;
  String year;
  Designation designation;

  Hijri({
    this.date,
    this.format,
    this.day,
    this.dayArabic,
    this.monthArabic,
    this.yearArabic,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
    date: json["date"],
    format: json["format"],
    day: json["day"],
    dayArabic: json["day_arabic"],
    monthArabic: json["month_arabic"],
    yearArabic: json["year_arabic"],
    weekday: HijriWeekday.fromJson(json["weekday"]),
    month: HijriMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": format,
    "day": day,
    "day_arabic": dayArabic,
    "month_arabic": monthArabic,
    "year_arabic": yearArabic,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
  };
}

class HijriMonth {
  int number;
  String en;
  String ar;

  HijriMonth({
    this.number,
    this.en,
    this.ar,
  });

  factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
    number: json["number"],
    en: json["en"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": en,
    "ar": ar,
  };
}

class HijriWeekday {
  String en;
  String ar;

  HijriWeekday({
    this.en,
    this.ar,
  });

  factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
    en: json["en"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}

class Holiday {
  String title;
  String date;
  String hijri;

  Holiday({
    this.title,
    this.date,
    this.hijri,
  });

  factory Holiday.fromJson(Map<String, dynamic> json) => Holiday(
    title: json["title"],
    date: json["date"],
    hijri: json["hijri"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "date": date,
    "hijri": hijri,
  };
}
