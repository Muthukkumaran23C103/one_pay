import 'dart:async';
import 'dart:ui';
import "package:one_pay/api/signlog_calls.dart";
import 'package:flutter/material.dart';
import 'package:one_pay/screens/home.dart';

class SignLog extends StatefulWidget {
  @override
  State<SignLog> createState() => _SignLog();
}

class _SignLog extends State<SignLog> with TickerProviderStateMixin {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();
  String? _autoLoginInput;
  // DEV / MOCK MODE
  static const bool mockAuth = false;

// Fake credentials
  static const String mockLogin = "9999999999";
  static const String mockPassword = "123456";
  static const int mockMerchantId = 1;

  final fullNameC = TextEditingController();
  final businessC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passwordC = TextEditingController();
  final loginInputC = TextEditingController();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0.3, 0), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    fullNameC.dispose();
    businessC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    loginInputC.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _clearFields() {
    fullNameC.clear();
    businessC.clear();
    emailC.clear();
    phoneC.clear();
    loginInputC.clear();
    passwordC.clear();
  }

  Future<void> _handleSignUp() async {
    final email =
    emailC.text.trim().isEmpty ? null : emailC.text.trim();
    final phone = phoneC.text.trim();
    final res = await SignlogCalls.signUp(
        fullName: fullNameC.text.trim(),
        businessName: businessC.text.trim(),
        email: email,
        phoneNumber: phone,
        password: passwordC.text.trim());
    print(res);
    if (res['success'] == true) {
      setState(() {
        isLogin = true;
        loginInputC.text = phoneC.text.trim();
        _resetAnimations();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign-Up Successful. Please login"),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res['message'] ?? 'Sign-Up failed'),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  /*Future<void> _handleLogin({bool autoLogin = false}) async {
    final loginInput = autoLogin ? _autoLoginInput : loginInputC.text.trim();

    if (loginInput == null || loginInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Enter your email or phone number'),
        backgroundColor: Colors.orange.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    final res = await SignlogCalls.login(
        loginInput: loginInputC.text.trim(),
        password: passwordC.text.trim());
    print(res);
    if (res['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Successful'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      final int merchantId = res['id'];
      print(merchantId);
      _clearFields();

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Home(merchantId: merchantId)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(res['message'] ?? 'Login failed'),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }*/
  Future<void> _handleLogin({bool autoLogin = false}) async {
    final loginInput = autoLogin ? _autoLoginInput : loginInputC.text.trim();

    if (loginInput == null || loginInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter your email or phone number')),
      );
      return;
    }

    // 🔥 MOCK LOGIN (NO API)
    if (mockAuth) {
      if (loginInput == mockLogin && passwordC.text == mockPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mock Login Successful'),
            backgroundColor: Colors.green,
          ),
        );

        _clearFields();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Home(merchantId: mockMerchantId),
          ),
        );
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid mock credentials'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // 🟢 REAL LOGIN (when server is live)
    final res = await SignlogCalls.login(
      loginInput: loginInput,
      password: passwordC.text.trim(),
    );

    if (res['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Home(merchantId: res['id']),
        ),
      );
    }
  }


  void _resetAnimations() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
  }

  Widget _authToggle(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active
                ? Color(0xFF2196F3)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
              BoxShadow(
                color: Color(0xFF2196F3).withOpacity(0.3),
                blurRadius: 12,
                offset: Offset(0, 4),
              )
            ]
                : [],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: active ? Colors.white : Color(0xFF757575),
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String? Function(String?) validator,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    int animationDelay = 0,
  }) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.only(
            top: 16,
            left: (animationDelay * 5).toDouble(),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: icon != null ? Icon(icon, color: Color(0xFF2196F3)) : null,
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              contentPadding:
              EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Color(0xFF2196F3),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 2,
                ),
              ),
              labelStyle: TextStyle(
                color: Color(0xFF757575),
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                color: Color(0xFFBDBDBD),
              ),
              errorStyle: TextStyle(
                fontSize: 12,
                color: Colors.red.shade600,
              ),
            ),
            style: TextStyle(
              color: Color(0xFF212121),
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF5F7FA),
              Color(0xFFE8F0FE),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Header
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2196F3),
                            Color(0xFF1976D2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2196F3).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.wallet,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 32),

                    // Title
                    Text(
                      'OnePay',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      isLogin ? 'Welcome back' : 'Create your account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 32),

                    // Form Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF000000).withOpacity(0.06),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Auth Toggle
                            Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Row(
                                children: [
                                  _authToggle('Login', isLogin, () {
                                    setState(() {
                                      isLogin = true;
                                      _formKey.currentState?.reset();
                                      _clearFields();
                                      _resetAnimations();
                                    });
                                  }),
                                  SizedBox(width: 8),
                                  _authToggle('Sign Up', !isLogin, () {
                                    setState(() {
                                      isLogin = false;
                                      _formKey.currentState?.reset();
                                      _clearFields();
                                      _resetAnimations();
                                    });
                                  }),
                                ],
                              ),
                            ),

                            // Sign Up Fields
                            if (!isLogin) ...[
                              _buildTextField(
                                controller: fullNameC,
                                label: 'Full Name',
                                hint: 'Enter your full name',
                                icon: Icons.person_outline,
                                validator: (v) {
                                  if (v == null || v == "")
                                    return "Enter full name";
                                  return null;
                                },
                              ),
                              _buildTextField(
                                controller: businessC,
                                label: 'Business Name',
                                hint: 'Enter your business name',
                                icon: Icons.business_outlined,
                                validator: (v) {
                                  if (v == null || v == "")
                                    return "Enter business name";
                                  return null;
                                },
                              ),
                              _buildTextField(
                                controller: emailC,
                                label: 'Email',
                                hint: 'your@email.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v == "")
                                    return "Enter your email";
                                  if (!(v.contains('@')))
                                    return "Invalid Email";
                                  return null;
                                },
                              ),
                              _buildTextField(
                                controller: phoneC,
                                label: 'Phone Number',
                                hint: '9876543210',
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  if (v == null || v == "")
                                    return "Enter your phone no.";
                                  if (v.length != 10)
                                    return "Invalid phone no.";
                                  return null;
                                },
                              ),
                            ],

                            // Login Field
                            if (isLogin)
                              _buildTextField(
                                controller: loginInputC,
                                label: 'Email or Phone Number',
                                hint: 'Enter email or phone',
                                icon: Icons.mail_outline,
                                keyboardType: TextInputType.emailAddress,
                                validator: (v) {
                                  if (v == null || v == "")
                                    return "Enter email or phone no.";
                                  return null;
                                },
                              ),

                            // Password Field
                            _buildTextField(
                              controller: passwordC,
                              label: 'Password',
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              obscure: true,
                              validator: (v) {
                                if (v == null || v == "")
                                  return "Enter your password";
                                if (v.length < 6)
                                  return "Minimum 6 characters";
                                return null;
                              },
                            ),

                            SizedBox(height: 28),

                            // Submit Button
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: double.infinity,
                              height: 52,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (isLogin) {
                                        await _handleLogin();
                                      } else {
                                        await _handleSignUp();
                                      }
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF2196F3),
                                          Color(0xFF1976D2),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Color(0xFF2196F3).withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      isLogin ? 'Login' : 'Sign Up',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Footer Text
                    Text(
                      'Secure & Fast Payment Solutions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
