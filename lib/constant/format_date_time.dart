import 'package:intl/intl.dart';

///时间戳格式化为时间
String formatTimeToDate(int time) {
  return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateTime.fromMillisecondsSinceEpoch(time));
}

String nowTimeString() {
  return DateFormat("yyyy-MM-dd HH:mm:ss.SSS").format(DateTime.now());
}

///把时间戳格式化为今天，昨天，日期这样的时间显示文本
String formatTimestamp(int timestamp) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = DateTime(now.year, now.month, now.day - 1);
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (messageDate.isAtSameMomentAs(today)) {
    return DateFormat('HH:mm').format(dateTime);
  } else if (messageDate.isAtSameMomentAs(yesterday)) {
    return '昨天 ${DateFormat('HH:mm').format(dateTime)}';
  } else if (dateTime.year == now.year) {
    return DateFormat('MM-dd HH:mm').format(dateTime);
  } else {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }
}
