import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supa/home.dart';
import 'package:supa/login_page.dart';
import 'package:supa/splash_page.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://gaiipxkakijrqyxinwxo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdhaWlweGtha2lqcnF5eGlud3hvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE5NDgwNjcsImV4cCI6MjAyNzUyNDA2N30.v9fz-jxTz617NjFckCbtDI9scLIy6oo6VAdAQracK1A',
  );
  runApp(MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PrintHub',
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.greenAccent,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => MyHomePage(),
      },
    );
  }
}
