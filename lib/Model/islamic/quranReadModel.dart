
import 'dart:convert';

QuranRead quranReadFromJson(String str) => QuranRead.fromJson(json.decode(str));

String quranReadToJson(QuranRead data) => json.encode(data.toJson());

class QuranRead {
    List<Result> result;
    String msg;
    String status;

    QuranRead({
        this.result,
        this.msg,
        this.status,
    });

    factory QuranRead.fromJson(Map<String, dynamic> json) => QuranRead(
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
    String ar;
    String id;
    String nomor;
    String tr;

    Result({
        this.ar,
        this.id,
        this.nomor,
        this.tr,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        ar: json["ar"],
        id: json["id"],
        nomor: json["nomor"],
        tr: json["tr"],
    );

    Map<String, dynamic> toJson() => {
        "ar": ar,
        "id": id,
        "nomor": nomor,
        "tr": tr,
    };
}
