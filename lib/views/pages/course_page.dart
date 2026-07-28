import 'package:flutter/material.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/core/widgets/course_card.dart';
import 'package:open_path/models/course_model.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final CourseController _courseController = CourseController();
  List<CourseModel> _courses = [];
  bool _isLoading = true;

  void _fetchCourses() async {
    final courses = await _courseController.fetchCourses();
    if (mounted) {
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isLoading)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _courses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(course: _courses[index]);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
