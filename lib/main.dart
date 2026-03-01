import 'package:cu_plus_webapp/features/dashboard/dashboard_shell.dart';
import 'package:cu_plus_webapp/features/dashboard/manage_students_view.dart';
import 'package:flutter/material.dart';
import 'features/auth/ui/first_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'DMSans'),
      // home: FirstPage(),
      initialRoute: '/',
      routes: {
        '/': (context) => FirstPage(),
      },
    );
  }
}
