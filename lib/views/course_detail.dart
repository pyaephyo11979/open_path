import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/core/widgets/lesson_card.dart';
import 'package:open_path/models/course_model.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/core/theme/app_theme.dart';

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
    final hasQuiz = _course?.quizzes != null && _course!.quizzes!.isNotEmpty;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 220,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              _course?.imageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                child: const Center(child: Icon(Icons.school, size: 64, color: AppColors.primary)),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_course?.title ?? '', style: Theme.of(context).textTheme.headlineMedium),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.menu_book, size: 16, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                Text('${lessons.length} Lessons', style: Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(width: 20),
                                if (hasQuiz) ...[
                                  const Icon(Icons.quiz, size: 16, color: AppColors.textSecondary),
                                  const SizedBox(width: 6),
                                  Text('${_course!.quizzes!.length} Quiz', style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('About this course', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 8),
                            Text(
                              _course?.description ?? 'No description available.',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _course?.price != null && _course!.price > 0
                                        ? AppColors.accent.withValues(alpha: 0.1)
                                        : AppColors.success.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    _course?.price != null && _course!.price > 0
                                        ? '${_course!.price.toStringAsFixed(0)} MMK'
                                        : 'Free',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: _course?.price != null && _course!.price > 0
                                          ? AppColors.accent
                                          : AppColors.success,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 28),
                            Text('Course Content', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(height: 4),
                            Text('${lessons.length} lessons', style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 12),
                            ...lessons.asMap().entries.map((entry) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: LessonCard(
                                  lesson: entry.value,
                                  showProgress: true,
                                ),
                              );
                            }),
                            if (hasQuiz) ...[
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () => context.push('/quiz/${_course!.quizzes!.first.id}'),
                                  icon: const Icon(Icons.quiz_outlined),
                                  label: const Text('Take Quiz'),
                                ),
                              ),
                            ],
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
