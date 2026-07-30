// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Enrollment _$EnrollmentFromJson(Map<String, dynamic> json) => Enrollment(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  courseId: (json['courseId'] as num).toInt(),
  approved: json['approved'] as bool,
  status: json['status'] as String,
  course: json['course'] == null
      ? null
      : CourseModel.fromJson(json['course'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$EnrollmentToJson(Enrollment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'approved': instance.approved,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

Quizzes _$QuizzesFromJson(Map<String, dynamic> json) => Quizzes(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  courseId: (json['courseId'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  questions: (json['questions'] as List<dynamic>?)
      ?.map((e) => Questions.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuizzesToJson(Quizzes instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'courseId': instance.courseId,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'questions': instance.questions,
};

Questions _$QuestionsFromJson(Map<String, dynamic> json) => Questions(
  id: (json['id'] as num).toInt(),
  question: json['question'] as String,
  quizId: (json['quizId'] as num).toInt(),
  sequence: (json['sequence'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  answers: json['answers'] != null
      ? (json['answers'] as List)
            .map((e) => Answers.fromJson(e as Map<String, dynamic>))
            .toList()
      : null,
);

Map<String, dynamic> _$QuestionsToJson(Questions instance) => <String, dynamic>{
  'id': instance.id,
  'question': instance.question,
  'quizId': instance.quizId,
  'sequence': instance.sequence,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'answers': instance.answers,
};

Answers _$AnswersFromJson(Map<String, dynamic> json) => Answers(
  id: (json['id'] as num).toInt(),
  answer: json['answer'] as String,
  questionId: (json['questionId'] as num).toInt(),
  correct: json['correct'] as bool,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$AnswersToJson(Answers instance) => <String, dynamic>{
  'id': instance.id,
  'answer': instance.answer,
  'questionId': instance.questionId,
  'correct': instance.correct,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => CourseModel(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String?,
  price: (json['price'] as num).toDouble(),
  published: json['published'] as bool,
  isEnrolled: json['isEnrolled'] as bool?,
  enrollmentStatus: json['enrollmentStatus'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  lessons: (json['lessons'] as List<dynamic>?)
      ?.map((e) => Lesson.fromJson(e as Map<String, dynamic>))
      .toList(),
  enrollments: (json['enrollments'] as List<dynamic>?)
      ?.map((e) => Enrollment.fromJson(e as Map<String, dynamic>))
      .toList(),
  quizzes: (json['quizzes'] as List<dynamic>?)
      ?.map((e) => Quizzes.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CourseModelToJson(CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'price': instance.price,
      'published': instance.published,
      'isEnrolled': instance.isEnrolled,
      'enrollmentStatus': instance.enrollmentStatus,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'lessons': instance.lessons,
      'enrollments': instance.enrollments,
      'quizzes': instance.quizzes,
    };
