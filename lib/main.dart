import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'constants/strings.dart';
import 'screens/signup_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/provider_dashboard_screen.dart';
import 'services/session_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Deploy Build: ${DateTime.now().toIso8601String()}');
  
  await SessionManager.instance.init();
  
  runApp(const FuelTrackApp());
}

class FuelTrackApp extends StatelessWidget {
  const FuelTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget initialScreen = const SignUpScreen();
    
    if (SessionManager.instance.isLoggedIn) {
      final user = SessionManager.instance.user;
      if (user != null && user.isProvider) {
        initialScreen = const ProviderDashboardScreen();
      } else {
        initialScreen = const DashboardScreen();
      }
    }

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: initialScreen,
    );
  }
}