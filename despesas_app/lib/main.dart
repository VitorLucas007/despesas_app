import 'package:despesas_app/widgets/main_navigation_page_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Despesas App',
      debugShowCheckedModeBanner: false,
      home: MainNavigationPageWidget(),
    );
  }
}
