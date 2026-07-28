import 'package:flutter/material.dart';
import 'package:open_path/controllers/lesson_controller.dart';
import 'package:open_path/models/lesson_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class LessonDetail extends StatefulWidget {
  const LessonDetail({required this.lessonId, super.key});

  final int lessonId;

  @override
  State<LessonDetail> createState() => _LessonDetailState();
}

class _LessonDetailState extends State<LessonDetail> {
  bool _isLoading = true;
  Lesson? _lesson;
  final LessonController _lessonController = LessonController();

  YoutubePlayerController? _youtubeController;

  void _fetchLesson() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final lesson = await _lessonController.fetchLessonById(widget.lessonId);
      if (mounted) {
        setState(() {
          _lesson = lesson;
          _youtubeController = YoutubePlayerController.fromVideoId(
            videoId: _lesson?.videoId ?? '',
            params: YoutubePlayerParams(showFullscreenButton: true),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        showToast(
          'Failed to load lesson: ${e.toString()}',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }

  void _toggleCompletion() async {
    if (_lesson == null) return;
    final currentStatus = _lesson?.isCompleted ?? false;
    if (currentStatus) {
      showToast(
        'Lesson is already completed.',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.blue,
        textStyle: const TextStyle(color: Colors.white),
      );
      return;
    }

    try {
      await _lessonController.markLessonComplete(widget.lessonId);
      if (mounted) {
        showToast(
          'Lesson marked as completed!',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          textStyle: const TextStyle(color: Colors.white),
        );
        _fetchLesson();
      }
    } catch (e) {
      if (mounted) {
        showToast(
          'Failed to mark lesson as completed: ${e.toString()}',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLesson();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isLoading
            ? const Text('Loading...')
            : Text(_lesson?.title ?? 'Lesson Detail'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_youtubeController != null)
                      YoutubePlayer(controller: _youtubeController!),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _lesson?.title ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _toggleCompletion,
                          icon: Icon(
                            _lesson?.isCompleted == true
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: _lesson?.isCompleted == true
                                ? Colors.green
                                : Colors.grey,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 10),
                    Text(
                      _lesson?.content ?? '',
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
