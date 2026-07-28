import 'package:flutter/material.dart';
import 'package:open_path/models/lesson_model.dart';
import 'package:go_router/go_router.dart';

class LessonCard extends StatefulWidget {
  const LessonCard({required this.lesson, super.key});

  final Lesson lesson;

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        widget.lesson.sequence.toString(),
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      title: Text(widget.lesson.title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        context.push('/lesson/${widget.lesson.id}');
      },
    );
  }
}
