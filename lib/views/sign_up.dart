import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/controllers/auth_controller.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _ishidden = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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

  void validateName(String name) {
    if (name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
  }

  void _signUp() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    try {
      if (name.isEmpty || email.isEmpty || password.isEmpty) {
        showToast(
          'Please fill in all fields',
          context: context,
          animation: StyledToastAnimation.slideFromBottom,
          reverseAnimation: StyledToastAnimation.slideToBottom,
          position: StyledToastPosition.bottom,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.redAccent,
          textStyle: TextStyle(color: Colors.white),
        );
        return;
      }
      validateName(name);
      validateEmail(email);
      validatePassword(password);
      await AuthController().signUp(
        name: name,
        email: email,
        password: password,
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     SizedBox(width: 10),
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
                Image.asset('assets/icons/icon.png', width: 200, height: 200),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Begin Your Path',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Sign up to start your journey with Open Path.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _ishidden,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _ishidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _ishidden = !_ishidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _signUp();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                      child: Text("Sign Up"),
                    ),
                  ],
                ),
                SizedBox(height: 160),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        context.push('/login');
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
