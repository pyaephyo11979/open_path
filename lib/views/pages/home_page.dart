import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/core/widgets/course_card.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (currentUser != null)
                      Text(
                        'Welcome, ${currentUser!.name}!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (isLoading) Center(child: CircularProgressIndicator()),
                    if (enrolledCourses.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'My Courses',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text('See All'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemCount: enrolledCourses.length,
                              itemBuilder: (context, index) {
                                final enrollment = enrolledCourses[index];
                                return CourseCard(course: enrollment.course!);
                              },
                            ),
                          ),
                        ],
                      ),
                    if (trendingCourses.isNotEmpty)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Trending Courses',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text('See All'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: trendingCourses.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final course = trendingCourses[index];
                                return CourseCard(course: course);
                              },
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
