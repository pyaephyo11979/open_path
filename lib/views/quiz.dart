import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/core/theme/app_theme.dart';

class Quiz extends StatefulWidget {
  const Quiz({required this.quizId, super.key});

  final int quizId;

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  Quizzes? _quiz;
  final CourseController _courseController = CourseController();
  final Map<int, int> _selectedAnswers = {};
  Map<String, dynamic>? _result;
  late final AnimationController _resultsAnimController;
  late final Animation<double> _resultsFadeAnim;

  @override
  void initState() {
    super.initState();
    _resultsAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _resultsFadeAnim = CurvedAnimation(parent: _resultsAnimController, curve: Curves.easeOutBack);
    _fetchQuiz();
  }

  @override
  void dispose() {
    _resultsAnimController.dispose();
    super.dispose();
  }

  void _fetchQuiz() async {
    final fetchedQuiz = await _courseController.fetchQuizzesByCourseId(widget.quizId);
    if (mounted) {
      setState(() {
        _quiz = fetchedQuiz;
        _quiz?.questions?.sort((a, b) => (a.sequence ?? 0).compareTo(b.sequence ?? 0));
        _isLoading = false;
      });
    }
  }

  Future<void> _submitQuiz() async {
    if (_quiz?.questions == null) return;
    final responses = _selectedAnswers.entries
        .map((e) => {'questionId': e.key, 'answerId': e.value})
        .toList();
    setState(() => _isSubmitting = true);
    try {
      final result = await _courseController.submitQuizAttempt(quizId: widget.quizId, responses: responses);
      setState(() {
        _result = result;
        _isSubmitted = true;
        _isSubmitting = false;
      });
      _resultsAnimController.forward();
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit quiz: $e')));
      }
    }
  }

  int get _progressPercent {
    if (_quiz?.questions == null || _quiz!.questions!.isEmpty) return 0;
    final answered = _quiz!.questions!.where((q) => _selectedAnswers.containsKey(q.id)).length;
    return (answered / _quiz!.questions!.length * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_quiz?.title ?? 'Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _quiz?.questions == null || _quiz!.questions!.isEmpty
              ? const Center(child: Text('No questions available'))
              : _isSubmitted && _result != null
                  ? FadeTransition(opacity: _resultsFadeAnim, child: _buildResults())
                  : _buildQuizContent(),
    );
  }

  Widget _buildQuizContent() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Question ${_selectedAnswers.length + 1} of ${_quiz!.questions!.length}', style: Theme.of(context).textTheme.bodyMedium),
                  const Spacer(),
                  Text('$_progressPercent%', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _progressPercent / 100,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _quiz!.questions!.length,
            itemBuilder: (context, index) {
              final question = _quiz!.questions![index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildQuestionCard(question, index),
              );
            },
          ),
        ),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildQuestionCard(Questions question, int index) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white12 : AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('${index + 1}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(question.question, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...?question.answers?.map((answer) {
            final isSelected = _selectedAnswers[question.id] == answer.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedAnswers[question.id] = answer.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : (Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.03) : AppColors.surface),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          width: 2,
                        ),
                        color: isSelected ? AppColors.primary : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Center(child: Icon(Icons.check, size: 14, color: Colors.white))
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(answer.answer, style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? AppColors.primary : null,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      )),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final allAnswered = _quiz!.questions!.every((q) => _selectedAnswers.containsKey(q.id));
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: allAnswered && !_isSubmitting ? _submitQuiz : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: allAnswered ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
          foregroundColor: allAnswered ? Colors.white : AppColors.textSecondary,
        ),
        child: _isSubmitting
            ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
            : Text(allAnswered ? 'Submit Quiz' : 'Answer all questions (${_selectedAnswers.length}/${_quiz!.questions!.length})'),
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
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (passed ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
              ),
              child: Center(
                child: Icon(
                  passed ? Icons.check_circle : Icons.cancel,
                  size: 64,
                  color: passed ? AppColors.success : AppColors.error,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              passed ? 'Congratulations!' : 'Better luck next time',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 12,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(passed ? AppColors.success : AppColors.error),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$correctCount / $totalQuestions', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('${score.toStringAsFixed(0)}%', style: TextStyle(fontSize: 16, color: passed ? AppColors.success : AppColors.error, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              passed ? 'You passed the quiz!' : 'You did not pass (70% required)',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
