import 'package:chatapp/pages/auth_or_app_page.dart';
import 'package:chatapp/pages/auth_page.dart';
import 'package:chatapp/pages/loading_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          primary: Colors.blue,
          secondary: Colors.orange,
        ),
        useMaterial3: true,
      ),
      home: const AuthOrAppPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
