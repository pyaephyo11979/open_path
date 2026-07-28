import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/views/pages/course_page.dart';
import 'package:open_path/views/pages/home_page.dart';
import 'package:open_path/views/pages/profile_page.dart';

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
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     const SizedBox(width: 10),
        //     FaIcon(
        //       FontAwesomeIcons.graduationCap,
        //       size: 32,
        //       color: Theme.of(context).colorScheme.primary,
        //     ),
        //     Text(
        //       'Open Path',
        //       style: TextStyle(
        //         fontSize: 24,
        //         fontWeight: FontWeight.bold,
        //         color: Theme.of(context).colorScheme.primary,
        //       ),
        //     ),
        //   ],
        // ),
        title: Image.asset(
          'assets/icons/banner_icon.png',
          width: 1000,
          height: 80,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: BottomBar(
        layout: BottomBarLayout(
          width: 400,
          borderRadius: BorderRadius.circular(30),
        ),
        scrollBehavior: BottomBarScrollBehavior(hideOnScroll: true),
        theme: BottomBarThemeData(
          barDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          iconDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        motion: BottomBarMotion.cupertino(
          preset: BottomBarCupertinoMotion.snappy,
          duration: Duration(milliseconds: 300),
          slideStart: Offset(0, 3),
        ),
        body: TabBarView(controller: _tabController, children: _pages),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: BottomBarItems(
                children: [
                  BottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.house),
                    label: const Text('Home'),
                    selected: _currentIndex == 0,
                    onTap: () {
                      _tabController.animateTo(0);
                    },
                  ),
                  BottomBarItem(
                    icon: FaIcon(FontAwesomeIcons.compass),
                    label: const Text('Courses'),
                    selected: _currentIndex == 1,
                    onTap: () {
                      _tabController.animateTo(1);
                    },
                  ),
                  BottomBarItem(
                    icon: const FaIcon(FontAwesomeIcons.user),
                    label: const Text('Profile'),
                    selected: _currentIndex == 2,
                    onTap: () {
                      _tabController.animateTo(2);
                    },
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
