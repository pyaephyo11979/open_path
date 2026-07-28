import 'package:json_annotation/json_annotation.dart';
import 'lesson_model.dart';

part 'course_model.g.dart';

@JsonSerializable()
class Enrollment {
  final int id;
  final int userId;
  final int courseId;
  final bool approved;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CourseModel? course;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.approved,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.course,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentFromJson(json);
  Map<String, dynamic> toJson() => _$EnrollmentToJson(this);
}

@JsonSerializable()
class Quizzes {
  final int id;
  final String title;
  final int courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Questions>? questions;
  Quizzes({
    required this.id,
    required this.title,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    this.questions,
  });

  factory Quizzes.fromJson(Map<String, dynamic> json) =>
      _$QuizzesFromJson(json);
  Map<String, dynamic> toJson() => _$QuizzesToJson(this);
}

@JsonSerializable()
class Questions {
  final int id;
  final String question;
  final int quizId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Answers>? answers;

  Questions({
    required this.id,
    required this.question,
    required this.quizId,
    required this.createdAt,
    required this.updatedAt,
    this.answers,
  });

  factory Questions.fromJson(Map<String, dynamic> json) =>
      _$QuestionsFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionsToJson(this);
}

@JsonSerializable()
class Answers {
  final int id;
  final String answer;
  final bool correct;
  final int questionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Answers({
    required this.id,
    required this.answer,
    required this.correct,
    required this.questionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Answers.fromJson(Map<String, dynamic> json) =>
      _$AnswersFromJson(json);
  Map<String, dynamic> toJson() => _$AnswersToJson(this);
}

@JsonSerializable()
class CourseModel {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;
  final double price;
  final bool published;
  final bool? isEnrolled;
  final String? enrollmentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Lesson>? lessons;
  final List<Enrollment>? enrollments;
  final List<Quizzes>? quizzes;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.price,
    required this.published,
    required this.createdAt,
    this.isEnrolled,
    this.enrollmentStatus,
    required this.updatedAt,
    this.lessons,
    this.enrollments,
    this.quizzes,
  });

  CourseModel copyWith({bool? isEnrolled, String? enrollmentStatus}) {
    return CourseModel(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      price: price,
      published: published,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      enrollmentStatus: enrollmentStatus ?? this.enrollmentStatus,
      lessons: lessons,
      enrollments: enrollments,
      quizzes: quizzes,
    );
  }

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CourseModelToJson(this);
}
