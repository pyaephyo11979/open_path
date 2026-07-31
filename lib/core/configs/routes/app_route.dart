import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/views/about_us.dart';
import 'package:open_path/views/course_detail.dart';
import 'package:open_path/views/edit_profile.dart';
import 'package:open_path/views/home.dart';
import 'package:open_path/views/lesson_detail.dart';
import 'package:open_path/views/login.dart';
import 'package:open_path/views/quiz.dart';
import 'package:open_path/views/quiz_scores.dart';
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
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => _fadePage(const Login(), state),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => _slidePage(const SignUp(), state),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _fadePage(const Home(), state),
    ),
    GoRoute(
      path: '/about_us',
      pageBuilder: (context, state) => _slidePage(const AboutUs(), state),
    ),
    GoRoute(
      path: '/course/:courseId',
      pageBuilder: (context, state) {
        final courseId = state.pathParameters['courseId'] != null
            ? int.tryParse(state.pathParameters['courseId']!)
            : null;
        if (courseId != null) {
          return _slidePage(CourseDetail(courseId: courseId), state);
        } else {
          return _slidePage(
            const Scaffold(body: Center(child: Text('Invalid course ID'))),
            state,
          );
        }
      },
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] != null
            ? int.tryParse(state.pathParameters['lessonId']!)
            : null;
        if (lessonId != null) {
          return _slidePage(LessonDetail(lessonId: lessonId), state);
        } else {
          return _slidePage(
            const Scaffold(body: Center(child: Text('Invalid Lesson Id'))),
            state,
          );
        }
      },
    ),
    GoRoute(
      path: '/edit_profile',
      pageBuilder: (context, state) => _slidePage(const EditProfile(), state),
    ),
    GoRoute(
      path: '/lessons/:lessonId',
      pageBuilder: (context, state) {
        final lessonId = state.pathParameters['lessonId'] != null
            ? int.tryParse(state.pathParameters['lessonId']!)
            : null;
        if (lessonId != null) {
          return _slidePage(CourseDetail(courseId: lessonId), state);
        } else {
          return _slidePage(
            const Scaffold(body: Center(child: Text('Invalid lesson ID'))),
            state,
          );
        }
      },
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) =>
          _slidePage(const NotificationPage(), state),
    ),
    GoRoute(
      path: '/quiz/:quizId',
      pageBuilder: (context, state) {
        final quizId = state.pathParameters['quizId'] != null
            ? int.tryParse(state.pathParameters['quizId']!)
            : null;
        if (quizId != null) {
          return _slidePage(Quiz(quizId: quizId), state);
        } else {
          return _slidePage(
            const Scaffold(body: Center(child: Text('Invalid quiz ID'))),
            state,
          );
        }
      },
    ),
    GoRoute(
      path: '/quiz_scores/:quizId',
      pageBuilder: (context, state) {
        final quizId = state.pathParameters['quizId'] != null
            ? int.tryParse(state.pathParameters['quizId']!)
            : null;
        if (quizId != null) {
          return _slidePage(QuizScores(quizId: quizId), state);
        } else {
          return _slidePage(
            const Scaffold(body: Center(child: Text('Invalid quiz ID'))),
            state,
          );
        }
      },
    ),
  ],
);

CustomTransitionPage _slidePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.3, 0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var fadeTween = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}
