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
    String saldoPlatinum;
    String level;
    String levelPlatinum;
    int levelPlatinumRaw;

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
        this.saldoPlatinum,
        this.level,
        this.levelPlatinum,
        this.levelPlatinumRaw,
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
        saldoPlatinum: json["saldo_platinum"],
        level: json["level"],
        levelPlatinum: json["level_platinum"],
        levelPlatinumRaw: json["level_platinum_raw"],
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
        "saldo_platinum": saldoPlatinum,
        "level": level,
        "level_platinum": levelPlatinum,
        "level_platinum_raw": levelPlatinumRaw,
    };
}
