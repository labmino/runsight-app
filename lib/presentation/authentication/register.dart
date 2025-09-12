import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_module/data/model/user.dart';
import '../../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _useScreenReader = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authController = Provider.of<AuthController>(context, listen: false);
    final registerRequest = UserRegisterRequest(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _passwordController.text,
    );

    try {
      final response = await authController.register(registerRequest);

      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Registration successful! Please login with your new account.',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xff1b1f3b)),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Create Account',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 28,
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Join the RunSight community',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 16,
                                        color: const Color(0xff888b94),
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormField(
                                'Full Name',
                                'Enter your full name',
                                _fullNameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              _buildFormField(
                                'Email',
                                'Enter your email',
                                _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please create a password';
                                        }
                                        if (value.length < 8) {
                                          return 'Password must be at least 8 characters';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Create a strong password',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          color: const Color(0xff888b94),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                          left: 16,
                                          top: 16,
                                          bottom: 16,
                                          right: 8,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: const Color(0xff888b94),
                                            size: 24,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Accessibility Preferences',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _useScreenReader = !_useScreenReader;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            color: _useScreenReader
                                                ? const Color(0xff3abeff)
                                                : Colors.transparent,
                                            border: Border.all(
                                              color: _useScreenReader
                                                  ? const Color(0xff3abeff)
                                                  : const Color(0xff888b94),
                                              width: 2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: _useScreenReader
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            'I use screen reader or voice assistance',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 14,
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: _isLoading
                                          ? null
                                          : _handleRegister,
                                      child: Container(
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff3abeff),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (_isLoading)
                                              const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(Color(0xff1b1f3b)),
                                                ),
                                              )
                                            else
                                              Text(
                                                'Create Account',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  decoration:
                                                      TextDecoration.none,
                                                  fontSize: 16,
                                                  color: const Color(
                                                    0xff1b1f3b,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'By creating an account, you agree to our',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 12,
                                            color: const Color(0xff888b94),
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        InkWell(
                                          onTap: () {
                                            // TODO: Open Terms and Privacy Policy
                                          },
                                          child: Text(
                                            'Terms of Service and Privacy Policy',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              fontSize: 12,
                                              color: const Color(0xff3abeff),
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 14,
                            color: const Color(0xff888b94),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        InkWell(
                          onTap: _navigateToLogin,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 14,
                              color: const Color(0xff3abeff),
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
      ),
    );
  }

  Widget _buildFormField(
    String label,
    String hintText,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.left,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 16,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: const Color(0xff888b94),
                fontWeight: FontWeight.normal,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
