import 'package:json_annotation/json_annotation.dart';

part 'lesson_model.g.dart';

@JsonSerializable()
class Lesson {
  final int id;
  final String title;
  final String content;
  @JsonKey(name: 'videoId')
  final String? videoId;
  final int courseId;
  final int? sequence;
  final bool? isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lesson({
    required this.id,
    required this.title,
    required this.content,
    this.videoId,
    required this.courseId,
    this.isCompleted,
    this.sequence,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}
