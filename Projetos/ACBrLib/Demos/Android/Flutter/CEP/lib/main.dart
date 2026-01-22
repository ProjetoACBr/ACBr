import 'package:demo_acbrcep_flutter/ui/screens/home_page.dart';
import 'package:demo_acbrcep_flutter/ui/_core/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      title: 'Demo ACBrLibCEP',
      theme: AppTheme.appTheme
    );
  }
}
