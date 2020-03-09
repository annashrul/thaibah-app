import 'dart:convert';


RequestTimeOutModel requestTimeOutModelFromJson(String str) => RequestTimeOutModel.fromJson(json.decode(str));

String requestTimeOutModelToJson(RequestTimeOutModel data) => json.encode(data.toJson());

class RequestTimeOutModel{
  var result;
  String msg;
  String status;

  RequestTimeOutModel({
    this.result,
    this.msg,
    this.status,
  });

  factory RequestTimeOutModel.fromJson(Map<String, dynamic> json) => RequestTimeOutModel(
    result: List<dynamic>.from(json["result"].map((x) => x)),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x)),
    "msg": msg,
    "status": status,
  };
}
