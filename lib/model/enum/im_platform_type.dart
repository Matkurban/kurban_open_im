import 'dart:io';

enum ImPlatformType {
  ios(value: 1, platform: "ios"),
  android(value: 2, platform: "android"),
  windows(value: 3, platform: "windows"),
  linux(value: 7, platform: "linux"),
  macos(value: 4, platform: "macos");
  // web(value: 5, platform: "web");

  final int value;
  final String platform;

  const ImPlatformType({required this.value, required this.platform});

  factory ImPlatformType.current() {
    var operatingSystem = Platform.operatingSystem;
    return ImPlatformType.values.firstWhere((value) {
      return value.platform == operatingSystem;
    }, orElse: () => ios);
  }
}
