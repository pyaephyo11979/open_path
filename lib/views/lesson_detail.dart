import 'package:flutter/material.dart';
import 'package:open_path/controllers/lesson_controller.dart';
import 'package:open_path/models/lesson_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:open_path/core/theme/app_theme.dart';

class LessonDetail extends StatefulWidget {
  const LessonDetail({required this.lessonId, super.key});

  final int lessonId;

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  bool _isLoading = true;
  bool _isCompleting = false;
  Lesson? _lesson;
  final LessonController _lessonController = LessonController();
  YoutubePlayerController? _youtubeController;

  void _fetchLesson() async {
    try {
      setState(() => _isLoading = true);
      final lesson = await _lessonController.fetchLessonById(widget.lessonId);
      if (mounted) {
        setState(() {
          _lesson = lesson;
          if (lesson.videoId != null && lesson.videoId!.isNotEmpty) {
            _youtubeController = YoutubePlayerController.fromVideoId(
              videoId: lesson.videoId!,
              params: const YoutubePlayerParams(showFullscreenButton: true),
            );
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showToast('Failed to load lesson: ${e.toString().replaceFirst("Exception: ", "")}', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 3), backgroundColor: AppColors.error, textStyle: const TextStyle(color: Colors.white));
      }
    }
  }

  void _toggleCompletion() async {
    if (_lesson == null || _isCompleting) return;
    if (_lesson!.isCompleted == true) {
      showToast('Lesson already completed', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 2), backgroundColor: AppColors.primary, textStyle: const TextStyle(color: Colors.white));
      return;
    }
    setState(() => _isCompleting = true);
    try {
      await _lessonController.markLessonComplete(widget.lessonId);
      if (mounted) {
        showToast('Lesson completed!', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 2), backgroundColor: AppColors.success, textStyle: const TextStyle(color: Colors.white));
        _fetchLesson();
      }
    } catch (e) {
      if (mounted) {
        showToast('Failed: ${e.toString().replaceFirst("Exception: ", "")}', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 3), backgroundColor: AppColors.error, textStyle: const TextStyle(color: Colors.white));
      }
    } finally {
      if (mounted) setState(() => _isCompleting = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLesson();
  }

  @override
  void dispose() {
    _youtubeController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = _lesson?.isCompleted == true;
    return Scaffold(
      appBar: AppBar(
        title: Text(_lesson?.title ?? 'Lesson'),
        actions: [
          IconButton(
            onPressed: _isCompleting ? null : _toggleCompletion,
            icon: _isCompleting
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                : Icon(
                    isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                    color: isCompleted ? AppColors.success : null,
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_youtubeController != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                      child: YoutubePlayer(controller: _youtubeController!),
                    ),
                  Padding(
                    padding: AppTheme.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isCompleted ? AppColors.success : AppColors.primary).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isCompleted ? 'Completed' : 'In Progress',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isCompleted ? AppColors.success : AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            if (_lesson?.videoId != null && _lesson!.videoId!.isNotEmpty)
                              Text('Video Lesson', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(_lesson?.title ?? '', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: AppTheme.cardPadding,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? AppColors.darkSurface
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Lesson Content', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 12),
                              Text(
                                _lesson?.content ?? 'No content available.',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.7),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isCompleting ? null : _toggleCompletion,
                            icon: Icon(isCompleted ? Icons.check_circle : Icons.check_circle_outline),
                            label: Text(isCompleted ? 'Completed' : 'Mark as Complete'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isCompleted ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
