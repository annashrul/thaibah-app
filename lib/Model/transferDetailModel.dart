// To parse this JSON data, do
//
//     final transferDetailModel = transferDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

TransferDetailModel transferDetailModelFromJson(String str) => TransferDetailModel.fromJson(json.decode(str));

String transferDetailModelToJson(TransferDetailModel data) => json.encode(data.toJson());

class TransferDetailModel extends BaseModel {
    Result result;
    String msg;
    String status;

    TransferDetailModel({
        this.result,
        this.msg,
        this.status,
    });

    factory TransferDetailModel.fromJson(Map<String, dynamic> json) => TransferDetailModel(
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
    var nominal;
    var feeCharge;
    bool statusFeecharge;
    var totalBayar;
    var penerima;
    var picture;
    var referralpenerima;

    Result({
        this.nominal,
        this.feeCharge,
        this.statusFeecharge,
        this.totalBayar,
        this.penerima,
        this.picture,
        this.referralpenerima,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        nominal: json["nominal"],
        feeCharge: json["fee_charge"],
        statusFeecharge: json["status_feecharge"],
        totalBayar: json["total_bayar"],
        penerima: json["penerima"],
        picture: json["picture"],
        referralpenerima: json["referralpenerima"],
    );

    Map<String, dynamic> toJson() => {
        "nominal": nominal,
        "fee_charge": feeCharge,
        "status_feecharge": statusFeecharge,
        "total_bayar": totalBayar,
        "penerima": penerima,
        "picture": picture,
        "referralpenerima": referralpenerima,
    };
}
