import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/core/widgets/course_card.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/core/theme/app_theme.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage>
    with AutomaticKeepAliveClientMixin {
  final CourseController _courseController = CourseController();
  List<CourseModel> _courses = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  void _fetchCourses() async {
    try {
      final courses = await _courseController.fetchCourses();
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _searchCourses() async {
    try {
      if (mounted) setState(() => _isLoading = true);
      if (_searchController.text.isEmpty) {
        _fetchCourses();
        return;
      }
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        _fetchCourses();
        return;
      }
      final courses = await _courseController.searchCourse(query: query);
      if (mounted) {
        setState(() {
          _courses = courses;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: AppTheme.screenPadding,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search courses...',
                suffixIcon: IconButton(
                  onPressed: () {
                    _searchCourses();
                    FocusScope.of(context).unfocus();
                  },
                  icon: Icon(Icons.search_outlined),
                ),
                filled: true,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _courses.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppColors.textSecondary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No courses found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async => _fetchCourses(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        return CourseCard(
                          course: _courses[index],
                          horizontal: false,
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
