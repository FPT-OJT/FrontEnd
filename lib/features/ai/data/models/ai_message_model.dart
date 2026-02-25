import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_message_model.freezed.dart';
part 'ai_message_model.g.dart';

@freezed
abstract class AiMessageModel with _$AiMessageModel {
  const factory AiMessageModel({
    required String content,
    required bool isUser,
    required DateTime timestamp,
  }) = _AiMessageModel;

  factory AiMessageModel.fromJson(Map<String, dynamic> json) =>
      _$AiMessageModelFromJson(json);
}
