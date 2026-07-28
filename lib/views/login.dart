import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:open_path/controllers/auth_controller.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _ishidden = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    try {
      if (email.isEmpty || password.isEmpty) {
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
      validateEmail(email);
      validatePassword(password);
      await AuthController().login(email: email, password: password);
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
                Container(
                  margin: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     FaIcon(
                      //       FontAwesomeIcons.graduationCap,
                      //       size: 32,
                      //       color: Theme.of(context).colorScheme.primary,
                      //     ),
                      //     Text(
                      //       "Open Path",
                      //       style: TextStyle(
                      //         fontSize: 24,
                      //         fontWeight: FontWeight.bold,
                      //         color: Theme.of(context).colorScheme.primary,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Image.asset(
                        'assets/icons/icon.png',
                        width: 150,
                        height: 150,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Continue your journey today",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter your email",
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: _ishidden,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter your password",
                    prefixIcon: Icon(Icons.lock_outline),
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
                    _login();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: Text("Login"),
                ),
                SizedBox(height: 200),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        context.push('/signup');
                      },
                      child: Text("Sign Up"),
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
