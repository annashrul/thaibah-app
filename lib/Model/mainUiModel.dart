// To parse this JSON data, do
//
//     final info = infoFromJson(jsonString);

import 'dart:convert';

Info infoFromJson(String str) => Info.fromJson(json.decode(str));

String infoToJson(Info data) => json.encode(data.toJson());

class Info {
    Result result;
    String msg;
    String status;

    Info({
        this.result,
        this.msg,
        this.status,
    });

    factory Info.fromJson(Map<String, dynamic> json) => Info(
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
    String name;
    String kdReferral;
    String noHp;
    String picture;
    String qr;
    String saldo;
    String saldoRaw;
    String saldoMain;
    String saldoBonus;
    String saldoVoucher;
    String hijri;
    String masehi;
    Ayat ayat;
    String inspiration;
    String versionCode;
    String thumbnail;
    String level;
    List<Section> section;

    Result({
        this.name,
        this.kdReferral,
        this.noHp,
        this.picture,
        this.qr,
        this.saldo,
        this.saldoRaw,
        this.saldoMain,
        this.saldoBonus,
        this.saldoVoucher,
        this.hijri,
        this.masehi,
        this.ayat,
        this.inspiration,
        this.versionCode,
        this.thumbnail,
        this.level,
        this.section,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        kdReferral: json["kd_referral"],
        noHp: json["no_hp"],
        picture: json["picture"],
        qr: json["qr"],
        saldo: json["saldo"],
        saldoRaw: json["saldo_raw"],
        saldoMain: json["saldo_main"],
        saldoBonus: json["saldo_bonus"],
        saldoVoucher: json["saldo_voucher"],
        hijri: json["hijri"],
        masehi: json["masehi"],
        ayat: Ayat.fromJson(json["ayat"]),
        inspiration: json["inspiration"],
        versionCode: json["version_code"],
        thumbnail: json["thumbnail"],
        level: json["level"],
        section: List<Section>.from(json["section"].map((x) => Section.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "kd_referral": kdReferral,
        "no_hp": noHp,
        "picture": picture,
        "qr": qr,
        "saldo": saldo,
        "saldo_raw": saldoRaw,
        "saldo_main": saldoMain,
        "saldo_bonus": saldoBonus,
        "saldo_voucher": saldoVoucher,
        "hijri": hijri,
        "masehi": masehi,
        "ayat": ayat.toJson(),
        "inspiration": inspiration,
        "version_code": versionCode,
        "thumbnail": thumbnail,
        "level": level,
        "section": List<dynamic>.from(section.map((x) => x.toJson())),
    };
}

class Ayat {
    String id;
    int surat;
    String surahNama;
    String surahArti;
    int jumlahAyat;
    int ayat;
    String surahAyat;
    String arabic;
    String terjemahan;
    String audio;
    String pathAudio;

    Ayat({
        this.id,
        this.surat,
        this.surahNama,
        this.surahArti,
        this.jumlahAyat,
        this.ayat,
        this.surahAyat,
        this.arabic,
        this.terjemahan,
        this.audio,
        this.pathAudio,
    });

    factory Ayat.fromJson(Map<String, dynamic> json) => Ayat(
        id: json["id"],
        surat: json["surat"],
        surahNama: json["surah_nama"],
        surahArti: json["surah_arti"],
        jumlahAyat: json["jumlah_ayat"],
        ayat: json["ayat"],
        surahAyat: json["surah_ayat"],
        arabic: json["arabic"],
        terjemahan: json["terjemahan"],
        audio: json["audio"],
        pathAudio: json["path_audio"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "surat": surat,
        "surah_nama": surahNama,
        "surah_arti": surahArti,
        "jumlah_ayat": jumlahAyat,
        "ayat": ayat,
        "surah_ayat": surahAyat,
        "arabic": arabic,
        "terjemahan": terjemahan,
        "audio": audio,
        "path_audio": pathAudio,
    };
}

class Section {
    Inpiration inpiration;
    List<Berita> berita;
    List<Berita> feed;

    Section({
        this.inpiration,
        this.berita,
        this.feed,
    });

    factory Section.fromJson(Map<String, dynamic> json) => Section(
        inpiration: Inpiration.fromJson(json["inpiration"]),
        berita: List<Berita>.from(json["berita"].map((x) => Berita.fromJson(x))),
        feed: List<Berita>.from(json["feed"].map((x) => Berita.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inpiration": inpiration.toJson(),
        "berita": List<dynamic>.from(berita.map((x) => x.toJson())),
        "feed": List<dynamic>.from(feed.map((x) => x.toJson())),
    };
}

class Berita {
    String id;
    String idMember;
    String penulis;
    String title;
    String picture;
    String caption;
    int type;
    String category;
    DateTime createdAt;
    DateTime updatedAt;
    String slug;
    int idCategory;
    String penulisPicture;
    String likes;
    String comments;
    String link;

    Berita({
        this.id,
        this.idMember,
        this.penulis,
        this.title,
        this.picture,
        this.caption,
        this.type,
        this.category,
        this.createdAt,
        this.updatedAt,
        this.slug,
        this.idCategory,
        this.penulisPicture,
        this.likes,
        this.comments,
        this.link,
    });

    factory Berita.fromJson(Map<String, dynamic> json) => Berita(
        id: json["id"],
        idMember: json["id_member"],
        penulis: json["penulis"],
        title: json["title"] == null ? null : json["title"],
        picture: json["picture"],
        caption: json["caption"],
        type: json["type"],
        category: json["category"] == null ? null : json["category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        slug: json["slug"] == null ? null : json["slug"],
        idCategory: json["id_category"] == null ? null : json["id_category"],
        penulisPicture: json["penulis_picture"],
        likes: json["likes"],
        comments: json["comments"],
        link: json["link"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_member": idMember,
        "penulis": penulis,
        "title": title == null ? null : title,
        "picture": picture,
        "caption": caption,
        "type": type,
        "category": category == null ? null : category,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "slug": slug == null ? null : slug,
        "id_category": idCategory == null ? null : idCategory,
        "penulis_picture": penulisPicture,
        "likes": likes,
        "comments": comments,
        "link": link,
    };
}

class Inpiration {
    String video;
    String thumbnail;

    Inpiration({
        this.video,
        this.thumbnail,
    });

    factory Inpiration.fromJson(Map<String, dynamic> json) => Inpiration(
        video: json["video"],
        thumbnail: json["thumbnail"],
    );

    Map<String, dynamic> toJson() => {
        "video": video,
        "thumbnail": thumbnail,
    };
}
