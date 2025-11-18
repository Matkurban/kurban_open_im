import 'dart:convert';
import 'dart:developer' as developer;

import 'package:kurban_open_im/constant/constants.dart';

const String name = "com.kurban.kurban_open_im";

void info(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "info ${nowTimeString()} : $message",
    name: name,
    error: error != null ? jsonEncode(error) : null,
    stackTrace: stackTrace,
  );
}

void warn(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "warn ${nowTimeString()} : $message",
    name: name,
    error: error != null ? jsonEncode(error) : null,
    stackTrace: stackTrace,
  );
}

void error(String message, {Object? error, StackTrace? stackTrace}) {
  developer.log(
    "error ${nowTimeString()} : $message",
    name: name,
    error: error != null ? jsonEncode(error) : null,
    stackTrace: stackTrace,
  );
}
