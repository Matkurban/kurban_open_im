import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

sealed class AppUtil {
  ///生成md5
  static String? generateMD5(String? data) {
    if (null == data) return null;
    var content = const Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return digest.toString();
  }

  static List<Message> calChatTimeInterval(List<Message> list, {bool calculate = true}) {
    if (!calculate) return list;
    var milliseconds = list.firstOrNull?.sendTime;
    if (null == milliseconds) return list;
    list.first.exMap['showTime'] = true;
    var lastShowTimeStamp = milliseconds;
    for (var i = 0; i < list.length; i++) {
      var index = i + 1;
      if (index <= list.length - 1) {
        var cur = getDateTimeByMs(lastShowTimeStamp);
        var milliseconds = list.elementAt(index).sendTime!;
        var next = getDateTimeByMs(milliseconds);
        if (next.difference(cur).inMinutes > 5) {
          lastShowTimeStamp = milliseconds;
          list.elementAt(index).exMap['showTime'] = true;
        }
      }
    }
    return list;
  }

  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }
}
