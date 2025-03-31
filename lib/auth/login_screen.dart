import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'register_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io' show Platform;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  bool _isLoading = false;
  String? _errorMessage;

  String getBackendUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // Android emulator
    } else {
      return 'http://192.168.1.221:8000/api'; // iOS emulator (tu IP)
    }
  }
  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${getBackendUrl()}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailCtrl.text,
          'password': _passwordCtrl.text,
        }),
      );

      if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await _secureStorage.write(key: 'auth_token', value: data['token']);
          Navigator.pushReplacementNamed(context, '/home');          
          print('Token guardado');          
        print('Token recibido: ${data['token']}');
        // Aquí puedes guardar el token en secure storage y navegar
      } else {
        final data = jsonDecode(response.body);
        _showError(data['message'] ?? 'Error al iniciar sesión');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await _googleSignIn.signIn();

      if (account != null) {
        final email = account.email;
        final name = account.displayName ?? '';

        final response = await http.post(
          Uri.parse('${getBackendUrl()}/social-login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'provider': 'google',
            'email': email,
            'name': name,
          }),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await _secureStorage.write(key: 'auth_token', value: data['token']);
          Navigator.pushReplacementNamed(context, '/home');
          print('Token guardado');;          
          print('Login con Google exitoso');
        } else {
          print('Fallo al loguearse con Google: ${response.body}');
        }
      }
    } catch (e) {
      print('Error en Google Sign-In: $e');
    }
  }

  Future<void> _handleAppleSignIn() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final email = credential.email ?? 'user@apple.com';
      final name =
          "${credential.givenName ?? ''} ${credential.familyName ?? ''}".trim();

      final response = await http.post(
        Uri.parse('${getBackendUrl()}/social-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'provider': 'apple',
          'email': email,
          'name': name,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _secureStorage.write(key: 'auth_token', value: data['token']);
        Navigator.pushReplacementNamed(context, '/home');
        print('Token guardado');        
        print('Login con Apple exitoso');
      } else {
        print('Fallo al loguearse con Apple: ${response.body}');
      }
    } catch (e) {
      print('Error en Apple Sign-In: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                SizedBox(height: 120, child: Image.asset('assets/logo.png')),
                const SizedBox(height: 32),
                const Text(
                  "Bienvenido de nuevo",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: InputDecoration(
                    labelText: "Correo electrónico",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Ingresa tu correo' : null,
                ),                
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Ingresa tu contraseña' : null,
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),                
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Iniciar sesión"),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "o continúa con",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),
                const SizedBox(height: 20),
                if (Platform.isIOS)
                  SignInButton(Buttons.AppleDark, onPressed: _handleAppleSignIn),                             
                const SizedBox(height: 12),
                SignInButton(Buttons.Google, onPressed: _handleGoogleSignIn),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes cuenta?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Regístrate"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}