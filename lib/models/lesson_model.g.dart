// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lesson _$LessonFromJson(Map<String, dynamic> json) => Lesson(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  content: json['content'] as String,
  videoId: json['videoId'] as String?,
  courseId: (json['courseId'] as num).toInt(),
  sequence: (json['sequence'] as num?)?.toInt(),
  isCompleted: json['isCompleted'] as bool?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'videoId': instance.videoId,
  'courseId': instance.courseId,
  'isCompleted': instance.isCompleted,
  'sequence': instance.sequence,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
