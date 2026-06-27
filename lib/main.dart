import 'package:flutter/material.dart';
import 'config/theme.dart';
import 'constants/strings.dart';
import 'screens/signup_screen.dart';

void main() {
  print('Deploy Build: ${DateTime.now().toIso8601String()}');
  runApp(const FuelTrackApp());
}

class FuelTrackApp extends StatelessWidget {
  const FuelTrackApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SignUpScreen(),
    );
  }
}