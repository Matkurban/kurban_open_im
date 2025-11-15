import 'dart:convert';

class ApiResponse {
  final int errCode;
  final String errMsg;
  final String errDlt;
  final dynamic data;

  ApiResponse({
    required this.errCode,
    required this.errMsg,
    required this.errDlt,
    required this.data,
  });

  bool get isSuccess => errCode == 0;

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      errCode: json["errCode"],
      errMsg: json["errMsg"] ?? "",
      errDlt: json["errDlt"] ?? "",
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"errCode": errCode, "errMsg": errMsg, "errDlt": data, "data": data};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
