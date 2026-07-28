import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/models/course_model.dart';

class Quiz extends StatefulWidget {
  const Quiz({required this.quizId, super.key});

  final int quizId;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  Quizzes? _quiz;
  final CourseController _courseController = CourseController();
  final Map<int, int> _selectedAnswers = {};
  Map<String, dynamic>? _result;

  void _fetchQuiz() async {
    final fetchedQuiz = await _courseController.fetchQuizzesByCourseId(
      widget.quizId,
    );
    setState(() {
      _quiz = fetchedQuiz;
      _isLoading = false;
    });
  }

  Future<void> _submitQuiz() async {
    if (_quiz?.questions == null) return;

    final responses = _selectedAnswers.entries
        .map((e) => {'questionId': e.key, 'answerId': e.value})
        .toList();

    setState(() => _isSubmitting = true);

    try {
      final result = await _courseController.submitQuizAttempt(
        quizId: widget.quizId,
        responses: responses,
      );
      setState(() {
        _result = result;
        _isSubmitted = true;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit quiz: $e')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuiz();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoading ? 'Loading...' : _quiz?.title ?? 'Quiz'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quiz?.questions == null || _quiz!.questions!.isEmpty
          ? const Center(child: Text('No questions available'))
          : _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    if (_isSubmitted && _result != null) {
      return _buildResults();
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _quiz!.questions!.length,
            itemBuilder: (context, index) {
              final question = _quiz!.questions![index];
              return _buildQuestionCard(question, index);
            },
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildQuestionCard(Questions question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${index + 1}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.question,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            ...?question.answers?.map((answer) {
              final isSelected = _selectedAnswers[question.id] == answer.id;
              return RadioListTile<int>(
                value: answer.id,
                groupValue: _selectedAnswers[question.id],
                title: Text(answer.answer),
                onChanged: (value) {
                  setState(() {
                    _selectedAnswers[question.id] = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final allAnswered = _quiz!.questions!.every(
      (q) => _selectedAnswers.containsKey(q.id),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: allAnswered && !_isSubmitting ? _submitQuiz : null,
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                allAnswered ? 'Submit Quiz' : 'Answer all questions to submit',
              ),
      ),
    );
  }

  Widget _buildResults() {
    final score = (_result!['score'] as num).toDouble();
    final correctCount = _result!['correctCount'] as int;
    final totalQuestions = _result!['totalQuestions'] as int;
    final passed = _result!['passed'] as bool;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              size: 80,
              color: passed ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 24),
            Text(
              passed ? 'Congratulations!' : 'Better luck next time',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Text(
              '$correctCount / $totalQuestions',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${score.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 20,
                color: passed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              passed
                  ? 'You passed the quiz!'
                  : 'You did not pass (70% required)',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to Course'),
            ),
          ],
        ),
      ),
    );
  }
}
