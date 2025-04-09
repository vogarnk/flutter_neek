// main.dart
import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'package:neek/auth/login_screen.dart';
import 'package:neek/auth/register_screen.dart';
import 'home_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neek',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (_) => const LoginScreen());
        } else if (settings.name == '/register') {
          return MaterialPageRoute(builder: (_) => const RegisterScreen());
        } else if (settings.name == '/home') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('user') && args.containsKey('planNames')) {
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                user: args['user'],
                planNames: List<String>.from(args['planNames']),
              ),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text('Faltan argumentos para /home')), 
              ),
            );
          }
        }
        return null; // Ruta no encontrada
      },
    );
  }
}
