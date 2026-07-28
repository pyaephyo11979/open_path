import 'package:open_path/core/services/api_service.dart';
import 'package:open_path/models/lesson_model.dart';
import 'package:open_path/repositories/lesson_api.dart';

class LessonController {
  final LessonAPI _lessonAPI = LessonAPI(APIService());
  Future<List<Lesson>> fetchLessonsByCourse(int courseId) async {
    return await _lessonAPI.getLessonsByCourse(courseId);
  }

  Future<Lesson> fetchLessonById(int lessonId) async {
    return await _lessonAPI.getLessonById(lessonId);
  }

  Future<void> markLessonComplete(int lessonId) async {
    await _lessonAPI.markLessonComplete(lessonId);
  }

  Future<void> updateLessonProgress(int lessonTrackId, bool completed) async {
    await _lessonAPI.updateLessonProgress(lessonTrackId, completed);
  }
}
