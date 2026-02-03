import 'package:cu_plus_webapp/features/dashboard/course_content_page.dart';
import 'package:flutter/material.dart';
import 'features/auth/ui/first_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://kqwnpokzwlmfbbahjwyz.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imtxd25wb2t6d2xtZmJiYWhqd3l6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzAxNTQ5MjcsImV4cCI6MjA4NTczMDkyN30.w8kQavPuMff0ztQh15WuKtcEe6PSsMhV48DoMJWBYYA',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'DMSans'),
      home: FirstPage(),
    );
  }
}
