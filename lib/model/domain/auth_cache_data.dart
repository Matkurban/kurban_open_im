import 'dart:convert';

class AuthCacheData {
  final String userID;

  final String imToken;

  AuthCacheData({required this.userID, required this.imToken});

  factory AuthCacheData.fromJson(Map<String, dynamic> json) {
    return AuthCacheData(userID: json["userID"], imToken: json["imToken"]);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"userID": userID, "imToken": imToken};
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
