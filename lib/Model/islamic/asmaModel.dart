import 'dart:convert';

Asma asmaFromJson(String str) => Asma.fromJson(json.decode(str));

String asmaToJson(Asma data) => json.encode(data.toJson());

class Asma {
    List<Result> result = [];
    String msg;
    String status;

    Asma({
        this.result,
        this.msg,
        this.status,
    });

    factory Asma.fromJson(Map<String, dynamic> json) => Asma(
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
    String transliteration;
    int number;
    String meaning;

    Result({
        this.name,
        this.transliteration,
        this.number,
        this.meaning,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        transliteration: json["transliteration"],
        number: json["number"],
        meaning: json["meaning"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "transliteration": transliteration,
        "number": number,
        "meaning": meaning,
    };
}