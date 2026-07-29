import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/core/widgets/course_card.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/models/user_model.dart';
import 'package:open_path/core/theme/app_theme.dart';

class HomePage extends StatefulWidget {
  final VoidCallback? onSeeAllCourses;

  const HomePage({super.key, this.onSeeAllCourses});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  List<Enrollment> enrolledCourses = [];
  List<CourseModel> trendingCourses = [];
  bool isLoading = true;
  UserModel? currentUser;
  final CourseController _courseController = CourseController();
  final UserController _userController = UserController();

  void fetchAllData() async {
    final fetchedUser = await _userController.getUserData();
    final fetchedCourses = await _courseController.fetchMyEnrollments();
    final fetchedTrendingCourses = await _courseController
        .fetchTrendingCourses();
    if (mounted) {
      setState(() {
        currentUser = fetchedUser;
        enrolledCourses = fetchedCourses;
        trendingCourses = fetchedTrendingCourses;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => fetchAllData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: AppTheme.screenPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${currentUser?.name ?? 'Learner'}!',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Continue your learning journey',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (enrolledCourses.isNotEmpty) ...[
                      SectionHeader(title: 'My Courses'),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: enrolledCourses.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final enrollment = enrolledCourses[index];
                            return CourseCard(course: enrollment.course!);
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                    ],
                    if (trendingCourses.isNotEmpty) ...[
                      SectionHeader(title: 'Trending Courses', onSeeAll: widget.onSeeAllCourses),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 250,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: trendingCourses.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            return CourseCard(course: trendingCourses[index]);
                          },
                        ),
                      ),
                    ],
                    if (enrolledCourses.isEmpty && trendingCourses.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 60),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                size: 64,
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No courses yet',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Browse courses in the Courses tab',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({required this.title, this.onSeeAll, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17),
        ),
        const Spacer(),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See All')),
      ],
    );
  }
}
