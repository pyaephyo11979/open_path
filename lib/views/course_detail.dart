import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/core/widgets/lesson_card.dart';
import 'package:open_path/models/course_model.dart';
import 'package:go_router/go_router.dart';

class CourseDetail extends StatefulWidget {
  const CourseDetail({required this.courseId, super.key});

  final int courseId;

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  final CourseController _courseController = CourseController();
  CourseModel? _course;
  bool _isLoading = true;

  void _fetchCourseDetail() async {
    final course = await _courseController.fetchCourseById(widget.courseId);
    if (mounted) {
      setState(() {
        _course = course;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCourseDetail();
  }

  @override
  Widget build(BuildContext context) {
    final lessons = _course?.lessons ?? [];

    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Loading...')
            : Text(_course?.title ?? 'Course Detail'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      _course?.imageUrl ?? '',
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
                            height: 200,
                            child: Center(
                              child: Icon(Icons.broken_image, size: 50),
                            ),
                          ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _course?.title ?? 'Course Title',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _course?.description ??
                              'Course description will be displayed here.',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return LessonCard(lesson: lesson);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      floatingActionButton:
          _course?.quizzes != null && _course!.quizzes!.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push('/quiz/${_course!.quizzes!.first.id}');
              },
              label: const Text('Take Quiz'),
              icon: const Icon(Icons.quiz),
            )
          : null,
    );
  }
}
