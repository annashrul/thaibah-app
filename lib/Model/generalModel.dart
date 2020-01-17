import 'dart:convert';

import 'package:thaibah/Model/base_model.dart';

General generalFromJson(String str) => General.fromJson(json.decode(str));

String generalToJson(General data) => json.encode(data.toJson());

class General extends BaseModel{
    var result;
    String msg;
    String status;

    General({
        this.result,
        this.msg,
        this.status,
    });

    factory General.fromJson(Map<String, dynamic> json) => General(
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
