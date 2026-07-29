import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/models/course_model.dart';
import 'package:open_path/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/controllers/course_controller.dart';
import 'package:open_path/core/theme/app_theme.dart';
import 'package:open_path/core/widgets/course_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with AutomaticKeepAliveClientMixin {
  UserModel? user;
  List<Enrollment>? enrolledCourses;
  bool isLoading = true;

  Future<void> fetchAllData() async {
    try {
      final results = await Future.wait([
        UserController().getUserData(),
        CourseController().fetchMyEnrollments(),
      ]);
      if (mounted) {
        setState(() {
          user = results[0] as UserModel;
          enrolledCourses = results[1] as List<Enrollment>;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBackground
                              : Colors.white,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: user?.imageUrl != null
                            ? Image.network(
                                user!.imageUrl!,
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              )
                            : CircleAvatar(
                                backgroundColor: AppColors.primary
                                    .withValues(alpha: 0.1),
                                child: Text(
                                  user?.name.isNotEmpty == true
                                      ? user!.name[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            _StatCard(
                              label: 'Courses',
                              value: '${enrolledCourses?.length ?? 0}',
                              icon: Icons.menu_book,
                            ),
                            const SizedBox(width: 12),
                            _StatCard(
                              label: 'Learning',
                              value:
                                  '${enrolledCourses?.where((e) => e.status == 'APPROVED').length ?? 0}',
                              icon: Icons.trending_up,
                            ),
                            const SizedBox(width: 12),
                            _StatCard(
                              label: 'Completed',
                              value: '0',
                              icon: Icons.check_circle,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Currently Learning',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 270,
                          child:
                              enrolledCourses != null &&
                                  enrolledCourses!.any(
                                    (e) => e.status == 'APPROVED',
                                  )
                              ? ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: enrolledCourses!
                                      .where((e) => e.status == 'APPROVED')
                                      .length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) {
                                    final approved = enrolledCourses!
                                        .where((e) => e.status == 'APPROVED')
                                        .toList()[index];
                                    if (approved.course == null)
                                      return const SizedBox.shrink();
                                    return SizedBox(
                                      width: 260,
                                      child: CourseCard(
                                        course: approved.course!,
                                        horizontal: false,
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No courses yet',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 28),
                        _MenuItem(
                          icon: Icons.edit_outlined,
                          title: 'Edit Profile',
                          onTap: () => context.push('/edit_profile'),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          title: 'Notifications',
                          onTap: () => context.push('/notifications'),
                        ),
                        _MenuItem(
                          icon: Icons.info_outline,
                          title: 'About Us',
                          onTap: () => context.push('/about_us'),
                        ),
                        const Divider(height: 32),
                        _MenuItem(
                          icon: Icons.logout,
                          title: 'Logout',
                          iconColor: AppColors.error,
                          textColor: AppColors.error,
                          onTap: logout,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white12 : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 24, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontSize: 20),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: textColor)),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
