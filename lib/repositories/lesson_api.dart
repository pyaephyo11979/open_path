import 'package:open_path/core/services/api_service.dart';
import 'package:open_path/models/lesson_model.dart';

class LessonAPI {
  final APIService _apiService;

  LessonAPI(this._apiService);

  // GET /api/lessons/course/:courseId
  Future<List<Lesson>> getLessonsByCourse(int courseId) async {
    final response = await _apiService.get(
      url: '/lessons/course/$courseId',
      isTokenNeed: true,
    );
    final List data = response.data['data'];
    return data.map((json) => Lesson.fromJson(json)).toList();
  }

  Future<Lesson> getLessonById(int lessonId) async {
    final response = await _apiService.get(
      url: '/lessons/$lessonId',
      isTokenNeed: true,
    );
    return Lesson.fromJson(response.data['data']);
  }

  // POST /api/lessons/:lessonId/complete
  Future<void> markLessonComplete(int lessonId) async {
    await _apiService.post(
      url: '/lessons/$lessonId/complete',
      body: {},
      isTokenNeed: true,
    );
  }

  // PUT /api/lessons/:lessonTrackId
  Future<void> updateLessonProgress(int lessonTrackId, bool completed) async {
    await _apiService.put(
      url: '/lessons/$lessonTrackId',
      body: {'completed': completed},
      isTokenNeed: true,
    );
  }
}
