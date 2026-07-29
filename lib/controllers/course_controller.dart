import 'package:open_path/models/course_model.dart';
import 'package:open_path/repositories/course_api.dart';

class CourseController {
  final CourseAPI _courseAPI = CourseAPI();

  Future<List<CourseModel>> fetchCourses() async {
    return await _courseAPI.getCourses();
  }

  Future<CourseModel> fetchCourseById(int id) async {
    return await _courseAPI.getCourseById(id);
  }

  Future<void> enrollInCourse(int courseId) async {
    await _courseAPI.enrollInCourse(courseId);
  }

  Future<List<Enrollment>> fetchMyEnrollments() async {
    return await _courseAPI.getMyEnrollments();
  }

  Future<List<CourseModel>> fetchTrendingCourses() async {
    return await _courseAPI.getTrendingCourses();
  }

  Future<Quizzes> fetchQuizzesByCourseId(int quizId) async {
    return await _courseAPI.getQuizzesByCourseId(quizId);
  }

  Future<Map<String, dynamic>> submitQuizAttempt({
    required int quizId,
    required List<Map<String, dynamic>> responses,
  }) async {
    return await _courseAPI.submitQuizAttempt(
      quizId: quizId,
      responses: responses,
    );
  }

  Future<List<CourseModel>> searchCourse({required String query}) async {
    return await _courseAPI.searchCourse(query: query);
  }
}
