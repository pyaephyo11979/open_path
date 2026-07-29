import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/views/pages/course_page.dart';
import 'package:open_path/views/pages/home_page.dart';
import 'package:open_path/views/pages/profile_page.dart';
import 'package:open_path/core/theme/app_theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final TabController _tabController;

  final List<Widget> _pages = const [HomePage(), CoursePage(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() => _currentIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String get _title {
    switch (_currentIndex) {
      case 0: return 'Home';
      case 1: return 'Courses';
      case 2: return 'Profile';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              child: Image.asset('assets/icons/icon.png', width: 24, height: 24),
            ),
            const SizedBox(width: 10),
            Text(_title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.push('/notifications'),
          ),
        ],
      ),
      body: BottomBar(
        layout: const BottomBarLayout(
          width: 400,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        scrollBehavior: const BottomBarScrollBehavior(hideOnScroll: true),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: (isDark ? Colors.white12 : AppColors.border), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
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
          duration: const Duration(milliseconds: 300),
          slideStart: const Offset(0, 3),
        ),
        body: TabBarView(controller: _tabController, children: _pages),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: BottomBarItems(
                children: [
                  BottomBarItem(
                    icon: FaIcon(_currentIndex == 0 ? FontAwesomeIcons.house : FontAwesomeIcons.house),
                    label: const Text('Home'),
                    selected: _currentIndex == 0,
                    onTap: () => _tabController.animateTo(0),
                  ),
                  BottomBarItem(
                    icon: FaIcon(_currentIndex == 1 ? FontAwesomeIcons.compass : FontAwesomeIcons.compass),
                    label: const Text('Courses'),
                    selected: _currentIndex == 1,
                    onTap: () => _tabController.animateTo(1),
                  ),
                  BottomBarItem(
                    icon: FaIcon(_currentIndex == 2 ? FontAwesomeIcons.user : FontAwesomeIcons.user),
                    label: const Text('Profile'),
                    selected: _currentIndex == 2,
                    onTap: () => _tabController.animateTo(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
