import 'package:flutter/material.dart';
import 'package:open_path/models/course_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:open_path/repositories/course_api.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/core/theme/app_theme.dart';

class CourseCard extends StatefulWidget {
  final CourseModel course;
  final bool horizontal;

  const CourseCard({required this.course, this.horizontal = true, super.key});

  @override
  State<CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  final CourseAPI _courseAPI = CourseAPI();

  void enrollInCourse(int courseId) async {
    try {
      await _courseAPI.enrollInCourse(courseId);
      showToast('Successfully enrolled in the course!', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 3), backgroundColor: AppColors.success, textStyle: const TextStyle(color: Colors.white));
    } catch (e) {
      showToast(e.toString().replaceFirst('Exception: ', ''), context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 3), backgroundColor: AppColors.error, textStyle: const TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        if (widget.course.isEnrolled == true) {
          if (widget.course.enrollmentStatus == 'APPROVED') {
            context.push('/course/${widget.course.id}');
          } else {
            showToast('Your enrollment is pending approval.', context: context, animation: StyledToastAnimation.slideFromBottom, reverseAnimation: StyledToastAnimation.slideToBottom, position: StyledToastPosition.bottom, duration: const Duration(seconds: 3), backgroundColor: AppColors.warning, textStyle: const TextStyle(color: Colors.white));
          }
        } else {
          enrollInCourse(widget.course.id);
          setState(() {
            widget.course.copyWith(isEnrolled: true, enrollmentStatus: 'PENDING');
          });
        }
      },
      child: Container(
        width: widget.horizontal ? 280 : double.infinity,
        margin: widget.horizontal ? EdgeInsets.zero : const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black26 : Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppTheme.cardRadius)),
                  child: Image.network(
                    widget.course.imageUrl ?? 'https://via.placeholder.com/320x180',
                    width: double.infinity,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      child: const Center(child: Icon(Icons.school, size: 48, color: AppColors.primary)),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.course.price > 0 ? AppColors.accent : AppColors.success,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.course.price > 0 ? '${widget.course.price.toStringAsFixed(0)} MMK' : 'Free',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.course.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.course.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: widget.course.isEnrolled == true
                            ? (widget.course.enrollmentStatus == 'APPROVED' ? AppColors.primary.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1))
                            : AppColors.primary,
                        foregroundColor: widget.course.isEnrolled == true
                            ? (widget.course.enrollmentStatus == 'APPROVED' ? AppColors.primary : AppColors.warning)
                            : Colors.white,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        widget.course.isEnrolled == true
                            ? (widget.course.enrollmentStatus == 'APPROVED' ? 'Explore' : 'Pending')
                            : 'Enroll Now',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
