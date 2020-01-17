// class response json
class Response {
  final String msg;
  final String status;
  Result result;

  Response({this.status, this.msg, this.result});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      result: Result.fromJson(json["result"]),
      status: json['status'],
      msg: json['msg'],
    );
  }
}

class Result {
    String id;
    String name;
    String address;
    String email;
    String picture;
    String cover;
    String socketid;
    String kdReferral;
    String kdUnique;
    String token;
    String otp;
    int pin;

    Result({
        this.id,
        this.name,
        this.address,
        this.email,
        this.picture,
        this.cover,
        this.socketid,
        this.kdReferral,
        this.kdUnique,
        this.token,
        this.otp,
        this.pin,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        email: json["email"],
        picture: json["picture"],
        cover: json["cover"],
        socketid: json["socketid"],
        kdReferral: json["kd_referral"],
        kdUnique: json["kd_unique"],
        token: json["token"],
        otp: json["otp"],
        pin: json["pin"],
    );
}