import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/views/about_us.dart';
import 'package:open_path/views/course_detail.dart';
import 'package:open_path/views/edit_profile.dart';
import 'package:open_path/views/home.dart';
import 'package:open_path/views/lesson_detail.dart';
import 'package:open_path/views/login.dart';
import 'package:open_path/views/quiz.dart';
import 'package:open_path/views/sign_up.dart';
import 'package:open_path/views/notification.dart';
import 'package:open_path/core/services/secure_storage_service.dart';

final GlobalKey<NavigatorState> rootKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) async {
        final token = await SecureStorageService().getAuthToken();
        if (token == null || token.isEmpty) {
          return '/login';
        } else {
          return '/home';
        }
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const Login()),
    GoRoute(path: '/signup', builder: (context, state) => const SignUp()),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
    GoRoute(path: '/about_us', builder: (context, state) => const AboutUs()),
    GoRoute(
      path: '/course/:courseId',
      builder: (context, state) {
        final courseId = state.pathParameters['courseId'] != null
            ? int.tryParse(state.pathParameters['courseId']!)
            : null;
        if (courseId != null) {
          return CourseDetail(courseId: courseId);
        } else {
          return const Scaffold(body: Center(child: Text('Invalid course ID')));
        }
      },
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] != null
            ? int.tryParse(state.pathParameters['lessonId']!)
            : null;
        if (lessonId != null) {
          return LessonDetail(lessonId: lessonId);
        } else {
          return const Scaffold(body: Center(child: Text('Invalid Lesson Id')));
        }
      },
    ),
    GoRoute(
      path: '/edit_profile',
      builder: (context, state) => const EditProfile(),
    ),
    GoRoute(
      path: '/lessons/:lessonId',
      builder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] != null
            ? int.tryParse(state.pathParameters['lessonId']!)
            : null;
        if (lessonId != null) {
          return CourseDetail(courseId: lessonId);
        } else {
          return const Scaffold(body: Center(child: Text('Invalid lesson ID')));
        }
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/quiz/:quizId',
      builder: (context, state) {
        final quizId = state.pathParameters['quizId'] != null
            ? int.tryParse(state.pathParameters['quizId']!)
            : null;
        if (quizId != null) {
          return Quiz(quizId: quizId);
        } else {
          return const Scaffold(body: Center(child: Text('Invalid quiz ID')));
        }
      },
    ),
  ],
);
