import 'dart:convert';

QuranResponse quranResponseFromJson(String str) => QuranResponse.fromJson(json.decode(str));

String quranResponseToJson(QuranResponse data) => json.encode(data.toJson());

class QuranResponse {
    List<Result> result;
    String msg;
    String status;

    QuranResponse({
        this.result,
        this.msg,
        this.status,
    });

    factory QuranResponse.fromJson(Map<String, dynamic> json) => QuranResponse(
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
    String id;
    String nama;
    String arti;
    String asma;
    int jmlAyat;
    String ket;
    String audio;
    Tipe tipe;
    String urut;

    Result({
        this.id,
        this.nama,
        this.arti,
        this.asma,
        this.jmlAyat,
        this.ket,
        this.audio,
        this.tipe,
        this.urut,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        nama: json["nama"],
        arti: json["arti"],
        asma: json["asma"],
        jmlAyat: json["jml_ayat"],
        ket: json["ket"],
        audio: json["audio"],
        tipe: tipeValues.map[json["tipe"]],
        urut: json["urut"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "arti": arti,
        "asma": asma,
        "jml_ayat": jmlAyat,
        "ket": ket,
        "audio": audio,
        "tipe": tipeValues.reverse[tipe],
        "urut": urut,
    };
}

enum Tipe { MEKAH, MADINAH }

final tipeValues = EnumValues({
    "madinah": Tipe.MADINAH,
    "mekah": Tipe.MEKAH
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}