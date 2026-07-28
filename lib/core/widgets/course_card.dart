import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:open_path/models/course_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:open_path/repositories/course_api.dart';
import 'package:go_router/go_router.dart';

class CourseCard extends StatefulWidget {
  const CourseCard({required this.course, super.key});

  final CourseModel course;

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  final CourseAPI _courseAPI = CourseAPI();

  void enrollInCourse(int courseId) async {
    try {
      await _courseAPI.enrollInCourse(courseId);
      showToast(
        'Successfully enrolled in the course!',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.green,
        textStyle: const TextStyle(color: Colors.white),
      );
    } catch (e) {
      showToast(
        e.toString(),
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

  @override
  void initState() {
    super.initState();
    log(widget.course.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 380,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Image.network(
                  widget.course.imageUrl ?? 'https://via.placeholder.com/150',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(
                    width: 100,
                    height: 100,
                    child: Center(child: Icon(Icons.broken_image, size: 50)),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.course.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.course.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.course.price > 0
                      ? '${widget.course.price} MMK'
                      : 'Free',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (widget.course.isEnrolled == true) {
                      widget.course.enrollmentStatus == 'APPROVED'
                          ? context.push('/course/${widget.course.id}')
                          : showToast(
                              'Your enrollment is pending approval.',
                              context: context,
                              animation: StyledToastAnimation.slideFromBottom,
                              reverseAnimation:
                                  StyledToastAnimation.slideToBottom,
                              position: StyledToastPosition.bottom,
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.orangeAccent,
                              textStyle: TextStyle(color: Colors.white),
                            );
                    } else {
                      enrollInCourse(widget.course.id);
                      setState(() {
                        widget.course.copyWith(
                          isEnrolled: true,
                          enrollmentStatus: 'PENDING',
                        );
                      });
                    }
                  },
                  child: Text(
                    widget.course.isEnrolled == true
                        ? widget.course.enrollmentStatus == 'APPROVED'
                              ? 'Explore Course'
                              : 'Pending Approval'
                        : 'Enroll',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
