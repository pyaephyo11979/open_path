import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:open_path/views/pages/course_page.dart';
import 'package:open_path/views/pages/home_page.dart';
import 'package:open_path/views/pages/profile_page.dart';
import 'package:open_path/core/theme/app_theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  late final PageController _pageController;
  int _unreadCount = 0;
  StreamSubscription? _notificationSubscription;

  List<Widget> get _pages => [
    HomePage(onSeeAllCourses: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)),
    const CoursePage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _notificationSubscription = FirebaseMessaging.onMessage.listen((_) {
      if (mounted) setState(() => _unreadCount++);
    });
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String get _title {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Courses';
      case 2:
        return 'Profile';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? AppColors.darkSurface : Colors.white;
    final borderColor = isDark ? Colors.white12 : Colors.white;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/icons/icon.png',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              _title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Badge(
            isLabelVisible: _unreadCount > 0,
            label: Text('$_unreadCount'),
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                setState(() => _unreadCount = 0);
                context.push('/notifications');
              },
            ),
          ),
        ],
      ),
      body: BottomBar(
        layout: const BottomBarLayout(
          width: 420,
          borderRadius: BorderRadius.all(Radius.circular(35)),
        ),
        scrollBehavior: const BottomBarScrollBehavior(hideOnScroll: true),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: barColor.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.3),
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          iconDecoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        motion: BottomBarMotion.cupertino(
          preset: BottomBarCupertinoMotion.snappy,
          duration: const Duration(milliseconds: 400),
          slideStart: const Offset(0, 5),
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentIndex = index),
          children: _pages,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    barColor.withValues(alpha: 0.15),
                    barColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: BottomBarItems(
                  children: [
                    _buildNavItem(
                      0,
                      FontAwesomeIcons.house,
                      FontAwesomeIcons.houseCircleCheck,
                      'Home',
                    ),
                    _buildNavItem(
                      1,
                      FontAwesomeIcons.compass,
                      FontAwesomeIcons.compass,
                      'Courses',
                    ),
                    _buildNavItem(
                      2,
                      FontAwesomeIcons.user,
                      FontAwesomeIcons.circleUser,
                      'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    FaIconData inactiveIcon,
    FaIconData activeIcon,
    String label,
  ) {
    final isSelected = _currentIndex == index;
    return BottomBarItem(
      icon: FaIcon(inactiveIcon, size: 22),
      selectedIcon: FaIcon(activeIcon, size: 22),
      label: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        child: Text(label),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
    );
  }
}
