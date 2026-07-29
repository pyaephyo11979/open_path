import 'package:flutter/material.dart';
import 'package:open_path/core/theme/app_theme.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: SingleChildScrollView(
        padding: AppTheme.screenPadding,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/icons/icon.png', width: 60, height: 60),
            ),
            const SizedBox(height: 20),
            Text('Open Path', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Version 1.0.0', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: AppTheme.cardPadding,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                border: Border.all(color: isDark ? Colors.white12 : AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Our Mission', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text(
                    'Open Path is dedicated to providing accessible, high-quality education to learners everywhere. We believe that knowledge should be free and accessible to all.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: AppTheme.cardPadding,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                border: Border.all(color: isDark ? Colors.white12 : AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Features', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  _FeatureItem(icon: Icons.menu_book, text: 'Curated courses on various topics'),
                  _FeatureItem(icon: Icons.video_library, text: 'Video-based lessons with YouTube integration'),
                  _FeatureItem(icon: Icons.quiz, text: 'Interactive quizzes to test your knowledge'),
                  _FeatureItem(icon: Icons.track_changes, text: 'Track your learning progress'),
                  _FeatureItem(icon: Icons.notifications, text: 'Stay updated with notifications'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Made with ❤️ for learners everywhere', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
