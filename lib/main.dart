import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';

import 'core/device_token_service.dart';
import 'splash_screen.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'home_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print('✅ Firebase inicializado correctamente');
  } catch (e, stack) {
    print("🔥 Error inicializando Firebase: $e");
    print(stack);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Espera a que el árbol de widgets esté construido antes de ejecutar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupFCM();
    });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📬 Notificación recibida en primer plano');

    final notification = message.notification;
    if (notification != null) {
      print('🔔 Título: ${notification.title}');
      print('📝 Mensaje: ${notification.body}');
    }
  });    
  }

  Future<void> _setupFCM() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print("📡 Solicitando token FCM...");
        String? fcmToken = await messaging.getToken();

        if (fcmToken == null && Platform.isIOS) {
          print("⏳ Esperando APNS...");
          await Future.delayed(const Duration(seconds: 2));
          fcmToken = await messaging.getToken();
        }

        if (Platform.isIOS) {
          final apnsToken = await messaging.getAPNSToken();
          print("📱 APNS Token: $apnsToken");
        }

        print("✅ Token FCM: $fcmToken");

        if (fcmToken != null) {
          await DeviceTokenService.registerToken(fcmToken);
          debugPrint('📤 Token FCM enviado: ${fcmToken.substring(0, 12)}...');
        }
      } else {
        print("⚠️ Permisos de notificación denegados.");
      }
    } catch (e) {
      print("🔥 Error en _setupFCM: $e");
    }
  }

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

          if (args != null &&
              args.containsKey('user') &&
              args.containsKey('planNames')) {
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
        return null;
      },
    );
  }
}