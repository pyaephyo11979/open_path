import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/controllers/course_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? user;
  List<Enrollment>? enrolledCourses;

  bool isLoading = true;

  void fetchAllData() async {
    final fetchedUser = await UserController().getUserData();
    final fetchedCourses = await CourseController().fetchMyEnrollments();
    if (mounted) {
      setState(() {
        user = fetchedUser;
        enrolledCourses = fetchedCourses;
        isLoading = false;
      });
    }
  }

  void logout() async {
    await UserController().logout(context: context);
  }

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColor,
                          ),
                          child: Text(
                            user?.name.substring(0, 1) ?? 'Loading...',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              user?.email ?? 'Loading...',
                              style: TextStyle(
                                fontSize: 16,
                                color: const Color.fromARGB(255, 105, 104, 104),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.grey, thickness: 0.5, height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Courses',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        if (user?.enrollments == null ||
                            user!.enrollments!.isEmpty)
                          Text('No courses enrolled.')
                        else
                          SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 10),
                              itemCount: user?.enrollments?.length ?? 0,
                              itemBuilder: (context, index) {
                                final course = enrolledCourses?[index].course;
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/course/${course?.id}');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(10),
                                    width: 100,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withValues(
                                            alpha: 0.5,
                                          ),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        Image.network(
                                          course?.imageUrl ??
                                              'https://via.placeholder.com/150',
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          course?.title ?? 'No title',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                    Divider(color: Colors.grey, thickness: 0.5, height: 20),
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Edit Profile'),
                      onTap: () {
                        context.push('/edit_profile');
                      },
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About Us'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.push('/about_us');
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: Colors.red),
                      title: Text(
                        'Logout',
                        style: TextStyle(color: Colors.red),
                      ),
                      onTap: () {
                        logout();
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
