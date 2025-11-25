import 'package:rxdart/rxdart.dart';

sealed class AppEvent {
  ///全局消息
  static PublishSubject<MessageDataModel> messages = PublishSubject();
}

class MessageDataModel {
  final bool openLoading;

  final String message;

  final MessageDataType type;

  MessageDataModel({required this.openLoading, required this.message, required this.type});
}

enum MessageDataType { message, loading }
