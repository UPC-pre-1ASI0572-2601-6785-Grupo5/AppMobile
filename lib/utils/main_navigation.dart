import 'package:flutter/material.dart';
import '../screens/analytics_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/tracking_screen.dart';

void handleMainNavigation(BuildContext context, int index, int currentIndex) {
  if (index == currentIndex) return;

  final route = switch (index) {
    0 => MaterialPageRoute(builder: (context) => const DashboardScreen()),
    1 => MaterialPageRoute(builder: (context) => const OrdersScreen()),
    2 => MaterialPageRoute(builder: (context) => const TrackingScreen()),
    3 => MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
    4 => MaterialPageRoute(builder: (context) => const ProfileScreen()),
    _ => null,
  };

  if (route != null) {
    Navigator.pushReplacement(context, route);
  }
}
