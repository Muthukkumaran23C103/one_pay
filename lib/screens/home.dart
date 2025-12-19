import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final int merchantId;
  const Home({super.key, required this.merchantId});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Container(
          height: 48,
          child: SearchBar(
            controller: _searchController,
            hintText: "Search Clients & Businesses",
            backgroundColor: MaterialStateProperty.all(Color(0xFFF5F5F5)),
            hintStyle: MaterialStateProperty.all(
              TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 14,
              ),
            ),
            textStyle: MaterialStateProperty.all(
              TextStyle(
                color: Color(0xFF212121),
                fontSize: 14,
              ),
            ),
            leading: Icon(Icons.search, color: Color(0xFF757575)),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Color(0xFFE0E0E0),
                  width: 1,
                ),
              ),
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Container(
              width: 44,
              height: 44,
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
                    color: Color(0xFF2196F3).withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 20),
                onPressed: () {
                  // Open profile
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildBody(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xFF000000).withOpacity(0.06),
              blurRadius: 12,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
          },
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: Color(0xFF2196F3),
          unselectedItemColor: Color(0xFF9E9E9E),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home_rounded, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.payments_outlined, size: 24),
              activeIcon: Icon(Icons.payments, size: 24),
              label: 'Money',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined, size: 24),
              activeIcon: Icon(Icons.person, size: 24),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2196F3),
                  Color(0xFF1976D2),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2196F3).withOpacity(0.2),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                )
              ],
            ),
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to OnePay',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage your business payments effortlessly',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),

          // Body Content
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentIndex == 0) ...[
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2196F3).withOpacity(0.1),
                              Color(0xFF1976D2).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.dashboard_outlined,
                          size: 60,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Home Screen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ] else if (_currentIndex == 1) ...[
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2196F3).withOpacity(0.1),
                              Color(0xFF1976D2).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.wallet_outlined,
                          size: 60,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Money Screen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ] else if (_currentIndex == 2) ...[
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2196F3).withOpacity(0.1),
                              Color(0xFF1976D2).withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 60,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Profile Screen',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
