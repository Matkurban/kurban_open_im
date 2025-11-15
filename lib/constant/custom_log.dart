import 'dart:convert';
import 'dart:developer' as developer;

const String name = "com.kurban.kurban_open_im";

void info(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "IM  Info  ${DateTime.now().millisecondsSinceEpoch} : $message",
    name: name,
    error: jsonEncode(error),
    stackTrace: stackTrace,
  );
}

void warn(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "IM  Warn  ${DateTime.now().millisecondsSinceEpoch} : $message",
    name: name,
    error: jsonEncode(error),
    stackTrace: stackTrace,
  );
}

void error(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "IM  Error  ${DateTime.now().millisecondsSinceEpoch} : $message",
    name: name,
    error: jsonEncode(error),
    stackTrace: stackTrace,
  );
}
