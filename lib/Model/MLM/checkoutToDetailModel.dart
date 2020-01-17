// To parse this JSON data, do
//
//     final checkoutToDetailModel = checkoutToDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CheckoutToDetailModel checkoutToDetailModelFromJson(String str) => CheckoutToDetailModel.fromJson(json.decode(str));

String checkoutToDetailModelToJson(CheckoutToDetailModel data) => json.encode(data.toJson());

class CheckoutToDetailModel extends BaseModel {
  var result;
  var msg;
  var status;

  CheckoutToDetailModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CheckoutToDetailModel.fromJson(Map<String, dynamic> json) => CheckoutToDetailModel(
    result: json["result"],
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "msg": msg,
    "status": status,
  };
}
