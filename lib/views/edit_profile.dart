import 'package:flutter/material.dart';
import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/models/user_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:open_path/core/theme/app_theme.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool isChangingPassword = false;
  bool _isSaving = false;
  bool _isLoading = true;
  final UserController _userController = UserController();
  UserModel? user;

  void fetchUser() async {
    try {
      final fetchedUser = await _userController.getUserData();
      if (mounted) {
        setState(() {
          user = fetchedUser;
          _nameController.text = fetchedUser.name;
          _emailController.text = fetchedUser.email;
        });
      }
    } catch (_) {
      // handle error silently
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void saveChanges() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty) {
      showToast(
        'Please fill in required fields',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.error,
        textStyle: const TextStyle(color: Colors.white),
      );
      return;
    }
    if (isChangingPassword) {
      if (password.isEmpty || confirmPassword.isEmpty) {
        showToast(
          'Please fill in password fields',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
          textStyle: const TextStyle(color: Colors.white),
        );
        return;
      }
      if (password != confirmPassword) {
        showToast(
          'Passwords do not match',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: const Duration(seconds: 3),
          backgroundColor: AppColors.error,
          textStyle: const TextStyle(color: Colors.white),
        );
        return;
      }
    }

    setState(() => _isSaving = true);
    try {
      await _userController.updateUserProfile(
        name: name,
        email: email,
        password: isChangingPassword ? password : null,
      );
      showToast(
        'Profile updated successfully',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.success,
        textStyle: const TextStyle(color: Colors.white),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      showToast(
        e.toString().replaceFirst('Exception: ', ''),
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: const Duration(seconds: 3),
        backgroundColor: AppColors.error,
        textStyle: const TextStyle(color: Colors.white),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Skeletonizer(
        enabled: _isLoading,
        child: SingleChildScrollView(
          padding: AppTheme.screenPadding,
          child: Column(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          user?.name.isNotEmpty == true
                              ? user!.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(
                      () => isChangingPassword = !isChangingPassword,
                    ),
                    child: Text(isChangingPassword ? 'Cancel' : 'Change'),
                  ),
                ],
              ),
              if (isChangingPassword) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : saveChanges,
                child: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
