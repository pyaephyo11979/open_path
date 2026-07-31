import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class QuizScores extends StatefulWidget {
  const QuizScores({required this.quizId, super.key});

  final int quizId;

  @override
  State<QuizScores> createState() => _QuizScoresState();
}

class _QuizScoresState extends State<QuizScores>
    with AutomaticKeepAliveClientMixin<QuizScores> {
  bool _isLoading = true;
  final CourseController _courseController = CourseController();
  List<Map<String, dynamic>> _quizScores = [];

  void fetchQuizScores() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final scores = await _courseController.fetchQuizScores(widget.quizId);
      if (mounted) {
        setState(() {
          _quizScores = scores;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        showToast(
          'Failed to fetch quiz scores: $e',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 4),
          backgroundColor: Colors.redAccent,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuizScores();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Scores')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => fetchQuizScores(),
              child: _quizScores.isEmpty
                  ? const Center(child: Text('No attempts yet'))
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: _quizScores.length,
                      itemBuilder: (context, index) {
                        final attempt = _quizScores[index];
                        final score = attempt['score'];
                        final passed = attempt['passed'] == true;
                        final createdAt = attempt['createdAt'];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text('Score: $score'),
                            subtitle: Text('Attempted: $createdAt'),
                            trailing: Chip(
                              label: Text(passed ? 'Passed' : 'Failed'),
                              backgroundColor: passed
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              labelStyle: TextStyle(
                                color: passed
                                    ? Colors.green.shade800
                                    : Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
