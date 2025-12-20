import 'package:flutter/material.dart';
import 'package:flutter_auto_service_app/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  bool rememberMe = false;
  bool obscurePassword = true;
  bool _isLoading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _handleEmailAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      if (isLogin) {
        await _authService.signInWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
      } else {
        await _authService.signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          username: usernameController.text.trim(),
          mobileNumber: mobileController.text.trim().isEmpty
              ? null
              : mobileController.text.trim(),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithGoogle();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() => _isLoading = true);
    try {
      await _authService.signInWithFacebook();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    final resetEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Reset Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter your email to receive a password reset link.'),
            const SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () async {
              if (resetEmailController.text.trim().isNotEmpty) {
                try {
                  await _authService.resetPassword(
                    resetEmailController.text.trim(),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    _showSuccess('Password reset email sent!');
                  }
                } catch (e) {
                  _showError(e.toString());
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Send', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: isLogin ? 80 : 40),

                  // Welcome text
                  Text(
                    isLogin ? 'Welcome Back!' : 'Create Account!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    isLogin
                        ? 'Your next opportunity is just a tap away.'
                        : 'Start your journey with us today.',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: isLogin ? 80 : 40),

                  // Username field (only for signup)
                  if (!isLogin) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EAF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                        validator: (value) {
                          if (!isLogin &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Email input
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Enter your email',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mobile number field (only for signup)
                  if (!isLogin) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EAF6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Mobile Number (optional)',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.phone_outlined,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Password input
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.grey,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(
                            () => obscurePassword = !obscurePassword,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!isLogin && value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Remember me and Forgot password
                  if (isLogin)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: rememberMe,
                                onChanged: (value) =>
                                    setState(() => rememberMe = value ?? false),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                  SizedBox(height: isLogin ? 40 : 24),

                  // Login/Signup button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleEmailAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              isLogin ? 'Login' : 'Sign Up',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Or divider
                  const Text(
                    'or',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Google button
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8EAF6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _handleGoogleSignIn,
                          icon: Image.asset(
                            'assets/icons/google_icon.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                      // Facebook button
                      Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8EAF6),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: _isLoading ? null : _handleFacebookSignIn,
                          icon: Image.asset(
                            'assets/icons/facebook_icon.png',
                            width: 28,
                            height: 28,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Sign up / Login toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? "Don't have an account? "
                            : "Already have an account? ",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  isLogin = !isLogin;
                                  usernameController.clear();
                                  mobileController.clear();
                                });
                              },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          isLogin ? 'Signup' : 'Login',
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
