import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdp/modals/user.dart';
import 'package:sdp/providers/user_provider.dart';
import 'package:sdp/screens/home_page.dart';

/// Welcome screen that handles user authentication (login and signup)
/// Uses Riverpod for state management and animate_do for animations
class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  // Authentication state
  bool _isLogin = true;

  // Form controllers and state
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  // Animation controllers
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize loading animation that pulses logo
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // Repeat the animation continuously
    _fadeAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    // Clean up resources
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Validates form data and initiates authentication process
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Show loading animation dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/bg.png',
              width: 120,
            ),
          ),
        ),
      );

      // Simulate server delay
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop(); // Close loading dialog

      _controller.stop(); // Stop animation

      try {
        // Perform login or signup based on current mode
        _isLogin ? await logIn() : await signUp();
      } catch (e) {
        // Error is handled in login/signup methods
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Handles user registration process
  Future<void> signUp() async {
    try {
      // Create user object from form data
      final user = Users(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Attempt to add user to database
      bool checkUser =
          await ref.watch(userNotifierProvider.notifier).addUser(user);

      if (checkUser) {
        _showSuccessDialog('Registration Successful!');
      } else {
        _showErrorDialog('Account Exists',
            '     A user with this email already exists. Please use a different email.');
      }
    } catch (e) {
      _showErrorDialog('Error', '   An error occurred: $e');
    }
  }

  /// Handles user login authentication
  Future<void> logIn() async {
    try {
      // Authenticate user with email and password
      final loggedInUser = await ref
          .read(userNotifierProvider.notifier)
          .authenticateUser(_emailController.text, _passwordController.text);

      if (loggedInUser != null) {
        if (!mounted) return;
        // Navigate to home page on successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        _showErrorDialog('Login Failed',
            'Invalid email or password. Please check your credentials and try again.');
      }
    } catch (e) {
      _showErrorDialog('Error', 'An error occurred: $e');
    }
  }

  /// Shows a success dialog with auto-dismiss
  void _showSuccessDialog(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Auto-dismiss after 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop();
          if (title.contains('Registration')) {
            _emailController.clear();
            _passwordController.clear();
            _switchAuthMode(); // Switch to login after registration
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: const Icon(
            Icons.check_circle,
            size: 72,
            color: Colors.green,
          ),
        );
      },
    );
  }

  /// Shows an error dialog with the specified title and message
  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Center(child: Text(title)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 72,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
          actions: [
            TextButton(
              key: const Key("error_alert_ok_button"),
              onPressed: () => Navigator.of(context).pop(),
              child: const Center(child: Text('OK')),
            ),
          ],
        );
      },
    );
  }

  /// Toggles between login and signup modes
  void _switchAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _formKey.currentState?.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userNotifierProvider.notifier);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Header section with background image
                Container(
                  height: screenSize.height * 0.35,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/plant2.jpg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      // Welcome text with animation
                      Positioned(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                            margin: const EdgeInsets.only(top: 230),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _isLogin
                                        ? "Welcome Back"
                                        : "Create Account",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _isLogin
                                        ? "Sign in to continue"
                                        : "Join us today",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // Authentication form card
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              // Name field (only for signup)
                              if (!_isLogin)
                                _buildTextField(
                                  controller: _nameController,
                                  label: 'Full Name',
                                  icon: Icons.person,
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter your name'
                                      : null,
                                  key: const Key("name_field"),
                                ),

                              // Email field
                              _buildTextField(
                                controller: _emailController,
                                label: 'Email Address',
                                icon: Icons.email,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) =>
                                    value!.isEmpty || !value.contains('@')
                                        ? 'Please enter a valid email'
                                        : null,
                                key: const Key("email_field"),
                              ),

                              // Password field with visibility toggle
                              _buildTextField(
                                controller: _passwordController,
                                label: 'Password',
                                icon: Icons.lock,
                                obscureText: !_isPasswordVisible,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                                validator: (value) => value!.isEmpty ||
                                        value.length < 6
                                    ? 'Password must be at least 6 characters'
                                    : null,
                                key: const Key("pass_field"),
                              ),

                              const SizedBox(height: 10),

                              // Login/Signup button
                              ElevatedButton(
                                key: const Key("submit_button"),
                                onPressed: _isLoading ? null : _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: Text(
                                  _isLogin ? 'Sign In' : 'Sign Up',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Toggle between login and signup modes
                              Center(
                                child: TextButton(
                                  onPressed: _switchAuthMode,
                                  child: Text(
                                    _isLogin
                                        ? 'Don\'t have an account? Sign Up'
                                        : 'Already have an account? Sign In',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ),

                              // Google sign-in option (only for login mode)
                              if (_isLogin) ...[
                                const SizedBox(height: 4),
                                const Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                        endIndent: 10,
                                      ),
                                    ),
                                    Text(
                                      'OR',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        thickness: 1,
                                        color: Colors.grey,
                                        indent: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Google sign-in button
                                ElevatedButton(
                                  onPressed: () async {
                                    if (await user.googleSignIn() != null) {
                                      if (!mounted) return;
                                      {
                                        // Show loading indicator during Google sign-in
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) => const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        );

                                        // Wait for authentication process
                                        await Future.delayed(
                                            const Duration(seconds: 1));

                                        // Navigate to home screen
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushReplacementNamed("/home");
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      side: const BorderSide(
                                          color: Colors.grey, width: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo1.png',
                                        height: 24,
                                        width: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Sign in with ',
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      const Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'G',
                                              style: TextStyle(
                                                  color: Color(0xFF4285F4)),
                                            ),
                                            TextSpan(
                                              text: 'o',
                                              style: TextStyle(
                                                  color: Color(0xFFEA4335)),
                                            ),
                                            TextSpan(
                                              text: 'o',
                                              style: TextStyle(
                                                  color: Color(0xFFFBBC05)),
                                            ),
                                            TextSpan(
                                              text: 'g',
                                              style: TextStyle(
                                                  color: Color(0xFF34A853)),
                                            ),
                                            TextSpan(
                                              text: 'l',
                                              style: TextStyle(
                                                  color: Color(0xFF4285F4)),
                                            ),
                                            TextSpan(
                                              text: 'e',
                                              style: TextStyle(
                                                  color: Color(0xFFEA4335)),
                                            ),
                                          ],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build consistent text form fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    Key? key,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        key: key,
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: validator,
      ),
    );
  }
}
