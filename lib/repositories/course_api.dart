import 'package:open_path/core/services/api_service.dart';
import 'package:open_path/models/course_model.dart';

class CourseAPI {
  final APIService _apiService = APIService();

  // GET /api/courses
  Future<List<CourseModel>> getCourses() async {
    final response = await _apiService.get(url: '/courses', isTokenNeed: true);
    final List data = response.data['data'];
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }

  // GET /api/courses/:id
  Future<CourseModel> getCourseById(int id) async {
    final response = await _apiService.get(
      url: '/courses/$id',
      isTokenNeed: true,
    );
    return CourseModel.fromJson(response.data['data']);
  }

  // POST /api/courses/:id/enroll
  Future<void> enrollInCourse(int courseId) async {
    await _apiService.post(
      url: '/courses/enroll/$courseId',
      body: {},
      isTokenNeed: true,
    );
  }

  // GET /api/courses/enrollments
  Future<List<Enrollment>> getMyEnrollments() async {
    final response = await _apiService.get(
      url: '/courses/enrollments',
      isTokenNeed: true,
    );
    final List data = response.data['data'];
    return data.map((json) => Enrollment.fromJson(json)).toList();
  }

  Future<List<CourseModel>> getTrendingCourses() async {
    final response = await _apiService.get(
      url: '/courses/trending',
      isTokenNeed: true,
    );
    final List data = response.data['data'];
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }

  Future<Quizzes> getQuizzesByCourseId(int quizId) async {
    final response = await _apiService.get(
      url: '/quizzes/$quizId',
      isTokenNeed: true,
    );
    return Quizzes.fromJson(response.data['data']);
  }

  Future<Map<String, dynamic>> submitQuizAttempt({
    required int quizId,
    required List<Map<String, dynamic>> responses,
  }) async {
    final response = await _apiService.post(
      url: '/quizzes/submit/$quizId',
      body: {'responses': responses},
      isTokenNeed: true,
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<List<CourseModel>> searchCourse({required String query}) async {
    final response = await _apiService.get(
      url: '/courses?search=$query',
      isTokenNeed: true,
    );
    final List data = response.data['data'];
    return data.map((json) => CourseModel.fromJson(json)).toList();
  }
}
