import 'package:flutter/material.dart';
import 'package:open_path/controllers/user_controller.dart';
import 'package:open_path/models/user_model.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

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
  final UserController _userController = UserController();
  UserModel? user;

  void fetchUser() async {
    final fetchedUser = await _userController.getUserData();
    if (mounted) {
      user = fetchedUser;
    }
  }

  void validateName(String name) {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (name.length < 3) {
      throw Exception('Name must be at least 3 characters long');
    }
  }

  void validateEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'; // Basic email pattern
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      throw Exception('Invalid email format');
    }
  }

  void validatePassword(String password) {
    if (password.length < 8) {
      throw Exception('Password must be at least 8 characters long');
    }
  }

  void saveChanges() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    try {
      if (name.isEmpty || email.isEmpty) {
        throw Exception('Please fill in all fields');
      }
      if (isChangingPassword == true) {
        if (password.isEmpty || confirmPassword.isEmpty) {
          throw Exception('Please fill in all fields');
        }
        if (password != confirmPassword) {
          throw Exception('Passwords do not match');
        }
        validatePassword(password);
      }
      validateName(name);
      validateEmail(email);
      await _userController.updateUserProfile(
        name: name,
        email: email,
        password: password,
      );
      showToast(
        'Profile updated successfully',
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.greenAccent,
        textStyle: TextStyle(color: Colors.white),
      );
    } catch (e) {
      showToast(
        e.toString(),
        context: context,
        animation: StyledToastAnimation.slideFromBottom,
        reverseAnimation: StyledToastAnimation.slideToBottom,
        position: StyledToastPosition.bottom,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.redAccent,
        textStyle: TextStyle(color: Colors.white),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 32),
            TextButton(
              onPressed: () {
                setState(() {
                  isChangingPassword = !isChangingPassword;
                });
              },
              child: Text('Change Password'),
            ),
            if (isChangingPassword == true)
              Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                  ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: null, // Implement save functionality
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
