import 'package:open_path/models/course_model.dart';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final String? password;
  final List<EnrollmentModel>? enrollments;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.enrollments,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      enrollments: json['enrollments'] != null
          ? List<EnrollmentModel>.from(
              json['enrollments'].map((x) => EnrollmentModel.fromJson(x)),
            )
          : null,
    );
  }
}

class EnrollmentModel {
  final int? id;
  final int userId;
  final int courseId;
  final CourseModel? courses;

  EnrollmentModel({
    this.id,
    required this.userId,
    required this.courseId,
    this.courses,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      courses: json['courses'] != null
          ? CourseModel.fromJson(json['courses'] as Map<String, dynamic>)
          : null,
    );
  }
}
