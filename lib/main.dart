import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/auth/ui/login_page.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();

await Supabase.initialize(
  url: 'https://pcxdmfscoltfidarkxzg.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBjeGRtZnNjb2x0ZmlkYXJreHpnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjczNzE4NzMsImV4cCI6MjA4Mjk0Nzg3M30.zLAPQHRsjnYF4jlLtjOG36FMkfn9L_0zp3hgxxOnye8',
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
      home: LoginPage(),
    );
  }
}
