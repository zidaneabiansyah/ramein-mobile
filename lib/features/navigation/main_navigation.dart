import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../events/screens/home_screen.dart';
import '../events/screens/events_screen.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import '../history/history_screen.dart';
import '../profile/screens/profile_screen.dart';

/// Provider untuk scroll notification
final navbarExpandedProvider = StateProvider<bool>((ref) => true);

/// Main Navigation dengan Collapsible Bottom Navigation Bar
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _currentIndex = 0;
  bool _isExpanded = true;

  final List<Widget> _screens = [
    const HomeScreen(),
    const EventsScreen(),
    const QRScannerScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  void _toggleNavbar() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is UserScrollNotification) {
            if (notification.direction == ScrollDirection.forward) {
              // Scroll ke atas - expand navbar
              if (!_isExpanded) {
                setState(() {
                  _isExpanded = true;
                });
              }
            } else if (notification.direction == ScrollDirection.reverse) {
              // Scroll ke bawah - collapse navbar
              if (_isExpanded) {
                setState(() {
                  _isExpanded = false;
                });
              }
            }
          }
          return false;
        },
        child: Stack(
          children: [
            // Main content
            IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            
            // Collapsible Navigation Bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: () {
                  if (!_isExpanded) {
                    _toggleNavbar();
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(
                    left: _isExpanded ? 20 : MediaQuery.of(context).size.width * 0.35,
                    right: _isExpanded ? 20 : MediaQuery.of(context).size.width * 0.35,
                    bottom: _isExpanded ? 20 : 10,
                  ),
                  height: _isExpanded ? 70 : 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(_isExpanded ? 35 : 25),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: _isExpanded 
                        ? _buildExpandedNavbar()
                        : _buildCollapsedNavbar(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedNavbar() {
    return Row(
      key: const ValueKey('expanded'),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildNavItem(0, Icons.home_rounded, 'Home'),
        _buildNavItem(1, Icons.calendar_month_rounded, 'Event'),
        _buildNavItem(2, Icons.qr_code_2_rounded, 'Scan'),
        _buildNavItem(3, Icons.schedule_rounded, 'Riwayat'),
        _buildNavItem(4, Icons.account_circle_rounded, 'Profile'),
      ],
    );
  }

  Widget _buildCollapsedNavbar() {
    final icons = [
      Icons.home_rounded,
      Icons.calendar_month_rounded,
      Icons.qr_code_2_rounded,
      Icons.schedule_rounded,
      Icons.account_circle_rounded,
    ];
    
    return Center(
      key: const ValueKey('collapsed'),
      child: Icon(
        icons[_currentIndex],
        color: Colors.white,
        size: 28,
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppColors.primary 
                  : Colors.white.withValues(alpha: 0.8),
              size: 26,
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
