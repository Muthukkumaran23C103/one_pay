import 'dart:async';
import 'package:flutter/material.dart';
import 'screens/signlog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    _fadeController.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignLog()),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo Container
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2196F3),
                          Color(0xFF1976D2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2196F3).withOpacity(0.4),
                          blurRadius: 32,
                          offset: Offset(0, 12),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.wallet,
                        size: 80,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),

              // App Name
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      'OnePay',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Secure Payment Solutions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60),

              // Loading Indicator
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF2196F3).withOpacity(0.15),
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF2196F3),
                    ),
                    backgroundColor: Color(0xFFE3F2FD),
                  ),
                ),
              ),

              SizedBox(height: 32),

              // Loading Text
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Initializing...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
