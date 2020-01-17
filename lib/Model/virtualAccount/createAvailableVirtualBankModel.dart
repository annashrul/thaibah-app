// To parse this JSON data, do
//
//     final createAvailableVirtualModel = createAvailableVirtualModelFromJson(jsonString);

import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

CreateAvailableVirtualModel createAvailableVirtualModelFromJson(String str) => CreateAvailableVirtualModel.fromJson(json.decode(str));

String createAvailableVirtualModelToJson(CreateAvailableVirtualModel data) => json.encode(data.toJson());

class CreateAvailableVirtualModel extends BaseModel {
  Result result;
  String msg;
  String status;

  CreateAvailableVirtualModel({
    this.result,
    this.msg,
    this.status,
  });

  factory CreateAvailableVirtualModel.fromJson(Map<String, dynamic> json) => CreateAvailableVirtualModel(
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
  String ownerId;
  String externalId;
  String bankCode;
  String merchantCode;
  String name;
  String accountNumber;
  int expectedAmount;
  bool isSingleUse;
  String description;
  String currency;
  String status;
  DateTime expirationDate;
  bool isClosed;
  String id;
  int adminFee;

  Result({
    this.ownerId,
    this.externalId,
    this.bankCode,
    this.merchantCode,
    this.name,
    this.accountNumber,
    this.expectedAmount,
    this.isSingleUse,
    this.description,
    this.currency,
    this.status,
    this.expirationDate,
    this.isClosed,
    this.id,
    this.adminFee,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    ownerId: json["owner_id"],
    externalId: json["external_id"],
    bankCode: json["bank_code"],
    merchantCode: json["merchant_code"],
    name: json["name"],
    accountNumber: json["account_number"],
    expectedAmount: json["expected_amount"],
    isSingleUse: json["is_single_use"],
    description: json["description"],
    currency: json["currency"],
    status: json["status"],
    expirationDate: DateTime.parse(json["expiration_date"]),
    isClosed: json["is_closed"],
    id: json["id"],
    adminFee: json["adminFee"],
  );

  Map<String, dynamic> toJson() => {
    "owner_id": ownerId,
    "external_id": externalId,
    "bank_code": bankCode,
    "merchant_code": merchantCode,
    "name": name,
    "account_number": accountNumber,
    "expected_amount": expectedAmount,
    "is_single_use": isSingleUse,
    "description": description,
    "currency": currency,
    "status": status,
    "expiration_date": expirationDate.toIso8601String(),
    "is_closed": isClosed,
    "id": id,
    "adminFee": adminFee,
  };
}
