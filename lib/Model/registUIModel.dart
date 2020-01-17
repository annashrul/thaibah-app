class Response {
  final String status;
  final String message;
  Result result;
 
  Response({this.status, this.message, this.result});
 
  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      status: json['status'],
      message: json['msg'],
      result: Result.fromJson(json["result"]),
    );
  }
}
class Result {
    String otp;
    String statusOtp;
    String insertId;

    Result({
        this.otp,
        this.statusOtp,
        this.insertId,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        otp: json["otp"],
        statusOtp: json["status_otp"],
        insertId: json["insertId"],
    );

    Map<String, dynamic> toJson() => {
        "otp": otp,
        "status_otp": statusOtp,
        "insertId": insertId,
    };
}