import 'dart:io';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricAuthService {
  static final BiometricAuthService instance = BiometricAuthService._internal();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  BiometricAuthService._internal();

  /// Verifica si la autenticación biométrica está disponible
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      print('🔍 Verificando biometría: isAvailable=$isAvailable, isDeviceSupported=$isDeviceSupported');
      
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('❌ Error verificando disponibilidad biométrica: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('❌ Error inesperado verificando disponibilidad biométrica: $e');
      return false;
    }
  }

  /// Obtiene los tipos de autenticación biométrica disponibles
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      print('📱 Biometrías disponibles: $availableBiometrics');
      return availableBiometrics;
    } on PlatformException catch (e) {
      print('❌ Error obteniendo biometrías disponibles: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('❌ Error inesperado obteniendo biometrías disponibles: $e');
      return [];
    }
  }

  /// Obtiene el nombre amigable del tipo de biometría
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.face:
        return Platform.isIOS ? 'Face ID' : 'Reconocimiento facial';
      case BiometricType.fingerprint:
        return Platform.isIOS ? 'Touch ID' : 'Huella dactilar';
      case BiometricType.iris:
        return 'Iris';
      default:
        return 'Biometría';
    }
  }

  /// Obtiene el nombre del tipo de biometría principal disponible (optimizado para iPhone físico)
  Future<String> getPrimaryBiometricTypeName() async {
    final availableBiometrics = await getAvailableBiometrics();
    
    // En iPhone físico, solo usar Face ID (no Touch ID)
    if (Platform.isIOS) {
      if (availableBiometrics.contains(BiometricType.face)) {
        return 'Face ID';
      }
      // No usar Touch ID en iPhone físico
    } else {
      // Android: priorizar huella dactilar
      if (availableBiometrics.contains(BiometricType.fingerprint)) {
        return 'Huella dactilar';
      } else if (availableBiometrics.contains(BiometricType.face)) {
        return 'Reconocimiento facial';
      }
    }
    
    if (availableBiometrics.contains(BiometricType.iris)) {
      return 'Iris';
    }
    
    return 'Autenticación biométrica';
  }

  /// Verifica si el usuario ha habilitado la autenticación biométrica
  Future<bool> isBiometricEnabled() async {
    try {
      final isEnabled = await _secureStorage.read(key: 'biometric_enabled');
      return isEnabled == 'true';
    } catch (e) {
      print('❌ Error verificando si biometría está habilitada: $e');
      return false;
    }
  }

  /// Habilita la autenticación biométrica para el usuario
  Future<Map<String, dynamic>> enableBiometric() async {
    try {
      print('🔐 Iniciando habilitación de biometría...');
      
      // Verificar que la biometría esté disponible
      if (!await isBiometricAvailable()) {
        return {
          'success': false,
          'error': 'La autenticación biométrica no está disponible en este dispositivo',
          'code': 'NOT_AVAILABLE'
        };
      }

      // Verificar que esté configurada
      if (!await hasBiometricConfigured()) {
        return {
          'success': false,
          'error': 'No tienes biometría configurada en tu dispositivo. Ve a Configuración > Face ID y código de acceso para configurarla.',
          'code': 'NOT_CONFIGURED'
        };
      }

      // Realizar una autenticación de prueba directa (sin verificar si ya está habilitada)
      print('🔐 Realizando prueba de autenticación para habilitar...');
      
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Habilitar autenticación biométrica',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      print('🔐 Resultado de autenticación para habilitar: $authenticated');

      if (authenticated) {
        await _secureStorage.write(key: 'biometric_enabled', value: 'true');
        print('✅ Biometría habilitada exitosamente');
        return {
          'success': true,
          'message': 'Autenticación biométrica habilitada exitosamente'
        };
      } else {
        return {
          'success': false,
          'error': 'La autenticación biométrica fue cancelada o falló',
          'code': 'AUTH_FAILED'
        };
      }
    } on PlatformException catch (e) {
      print('❌ Error habilitando biometría: ${e.code} - ${e.message}');
      String errorMessage = 'Error al habilitar la autenticación biométrica';
      
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'La autenticación biométrica no está disponible';
          break;
        case 'NotEnrolled':
          errorMessage = 'No tienes biometría configurada. Ve a Configuración > Face ID y código de acceso.';
          break;
        case 'PasscodeNotSet':
          errorMessage = 'Debes configurar un código de acceso antes de usar biometría';
          break;
        case 'LockedOut':
          errorMessage = 'La biometría está bloqueada temporalmente. Inténtalo más tarde.';
          break;
        case 'PermanentlyLockedOut':
          errorMessage = 'La biometría está bloqueada permanentemente. Ve a Configuración para desbloquearla.';
          break;
        case 'UserCancel':
          errorMessage = 'Autenticación cancelada por el usuario';
          break;
        case 'AuthenticationFailed':
          errorMessage = 'La autenticación biométrica falló. Inténtalo de nuevo.';
          break;
        case 'UserFallback':
          errorMessage = 'El usuario eligió usar el método alternativo';
          break;
        case 'SystemCancel':
          errorMessage = 'La autenticación fue cancelada por el sistema';
          break;
        case 'InvalidContext':
          errorMessage = 'Contexto de autenticación inválido';
          break;
        default:
          errorMessage = 'Error: ${e.message} (Código: ${e.code})';
      }
      
      return {
        'success': false,
        'error': errorMessage,
        'code': e.code
      };
    } catch (e) {
      print('❌ Error inesperado habilitando biometría: $e');
      return {
        'success': false,
        'error': 'Error inesperado al habilitar la biometría',
        'code': 'UNKNOWN_ERROR'
      };
    }
  }

  /// Deshabilita la autenticación biométrica
  Future<void> disableBiometric() async {
    await _secureStorage.delete(key: 'biometric_enabled');
    print('🔓 Biometría deshabilitada');
  }

  /// Realiza la autenticación biométrica
  Future<Map<String, dynamic>> authenticate({
    required String reason,
  }) async {
    try {
      print('🔐 Iniciando autenticación biométrica...');
      print('🔐 Razón: $reason');
      
      // Verificar si la biometría está habilitada
      if (!await isBiometricEnabled()) {
        print('❌ Biometría no habilitada');
        return {
          'success': false,
          'error': 'La autenticación biométrica no está habilitada',
          'code': 'NOT_ENABLED'
        };
      }

      // Configurar opciones de autenticación
      final authOptions = AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      );

      print('🔐 Opciones de autenticación configuradas');
      print('🔐 Llamando a _localAuth.authenticate...');

      // Realizar autenticación
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: authOptions,
      );

      print('🔐 Resultado de autenticación: $authenticated');

      if (authenticated) {
        print('✅ Autenticación biométrica exitosa');
        return {
          'success': true,
          'message': 'Autenticación exitosa'
        };
      } else {
        print('❌ Autenticación biométrica falló o fue cancelada');
        return {
          'success': false,
          'error': 'La autenticación biométrica fue cancelada o falló',
          'code': 'AUTH_CANCELLED'
        };
      }
    } on PlatformException catch (e) {
      print('❌ Error en autenticación biométrica: ${e.code} - ${e.message}');
      print('❌ Detalles del error: ${e.details}');
      String errorMessage = 'Error en la autenticación biométrica';
      
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'La autenticación biométrica no está disponible';
          break;
        case 'NotEnrolled':
          errorMessage = 'No tienes biometría configurada. Ve a Configuración > Face ID y código de acceso.';
          break;
        case 'PasscodeNotSet':
          errorMessage = 'Debes configurar un código de acceso antes de usar biometría';
          break;
        case 'LockedOut':
          errorMessage = 'La biometría está bloqueada temporalmente. Inténtalo más tarde.';
          break;
        case 'PermanentlyLockedOut':
          errorMessage = 'La biometría está bloqueada permanentemente. Ve a Configuración para desbloquearla.';
          break;
        case 'UserCancel':
          errorMessage = 'Autenticación cancelada por el usuario';
          break;
        case 'AuthenticationFailed':
          errorMessage = 'La autenticación biométrica falló. Inténtalo de nuevo.';
          break;
        case 'UserFallback':
          errorMessage = 'El usuario eligió usar el método alternativo';
          break;
        case 'SystemCancel':
          errorMessage = 'La autenticación fue cancelada por el sistema';
          break;
        case 'InvalidContext':
          errorMessage = 'Contexto de autenticación inválido';
          break;
        default:
          errorMessage = 'Error: ${e.message} (Código: ${e.code})';
      }
      
      return {
        'success': false,
        'error': errorMessage,
        'code': e.code
      };
    } catch (e) {
      print('❌ Error inesperado en autenticación: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      return {
        'success': false,
        'error': 'Error inesperado en la autenticación: $e',
        'code': 'UNKNOWN_ERROR'
      };
    }
  }

  /// Autenticación biométrica para acceso a la app
  Future<Map<String, dynamic>> authenticateForAppAccess() async {
    try {
      final biometricType = await getPrimaryBiometricTypeName();
      final reason = 'Usa $biometricType para acceder a Neek';
      
      print('🔐 Iniciando autenticación para acceso a la app...');
      print('🔐 Tipo de biometría: $biometricType');
      
      // Verificar si la biometría está habilitada en la app
      final isEnabled = await isBiometricEnabled();
      if (!isEnabled) {
        print('❌ Biometría no habilitada en la app');
        return {
          'success': false,
          'error': 'La autenticación biométrica no está habilitada en la app',
          'code': 'NOT_ENABLED_IN_APP'
        };
      }
      
      // Realizar autenticación directa
      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      
      print('🔐 Resultado de autenticación para acceso: $authenticated');
      
      if (authenticated) {
        print('✅ Autenticación para acceso exitosa');
        return {
          'success': true,
          'message': 'Autenticación exitosa'
        };
      } else {
        print('❌ Autenticación para acceso falló o fue cancelada');
        return {
          'success': false,
          'error': 'La autenticación biométrica fue cancelada o falló',
          'code': 'AUTH_CANCELLED'
        };
      }
    } on PlatformException catch (e) {
      print('❌ Error en autenticación para acceso: ${e.code} - ${e.message}');
      String errorMessage = 'Error en la autenticación biométrica';
      
      switch (e.code) {
        case 'NotAvailable':
          errorMessage = 'La autenticación biométrica no está disponible';
          break;
        case 'NotEnrolled':
          errorMessage = 'No tienes biometría configurada';
          break;
        case 'PasscodeNotSet':
          errorMessage = 'Debes configurar un código de acceso';
          break;
        case 'LockedOut':
          errorMessage = 'La biometría está bloqueada temporalmente';
          break;
        case 'PermanentlyLockedOut':
          errorMessage = 'La biometría está bloqueada permanentemente';
          break;
        case 'UserCancel':
          errorMessage = 'Autenticación cancelada por el usuario';
          break;
        case 'AuthenticationFailed':
          errorMessage = 'La autenticación biométrica falló. Inténtalo de nuevo.';
          break;
        case 'UserFallback':
          errorMessage = 'El usuario eligió usar el método alternativo';
          break;
        case 'SystemCancel':
          errorMessage = 'La autenticación fue cancelada por el sistema';
          break;
        case 'InvalidContext':
          errorMessage = 'Contexto de autenticación inválido';
          break;
        default:
          errorMessage = 'Error: ${e.message} (Código: ${e.code})';
      }
      
      return {
        'success': false,
        'error': errorMessage,
        'code': e.code
      };
    } catch (e) {
      print('❌ Error inesperado en autenticación para acceso: $e');
      return {
        'success': false,
        'error': 'Error inesperado en la autenticación',
        'code': 'UNKNOWN_ERROR'
      };
    }
  }

  /// Verifica si el dispositivo tiene biometría configurada
  Future<bool> hasBiometricConfigured() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      final hasConfigured = availableBiometrics.isNotEmpty;
      print('📱 Biometría configurada: $hasConfigured');
      return hasConfigured;
    } catch (e) {
      print('❌ Error verificando configuración de biometría: $e');
      return false;
    }
  }

  /// Obtiene información completa sobre el estado de la biometría
  Future<Map<String, dynamic>> getBiometricStatus() async {
    try {
      final isAvailable = await isBiometricAvailable();
      final isEnabled = await isBiometricEnabled();
      final hasConfigured = await hasBiometricConfigured();
      final availableTypes = await getAvailableBiometrics();
      final primaryType = await getPrimaryBiometricTypeName();

      final status = {
        'isAvailable': isAvailable,
        'isEnabled': isEnabled,
        'hasConfigured': hasConfigured,
        'availableTypes': availableTypes,
        'primaryType': primaryType,
        'canUseBiometric': isAvailable && isEnabled && hasConfigured,
      };

      print('📊 Estado de biometría: $status');
      return status;
    } catch (e, stackTrace) {
      print('❌ Error obteniendo estado de biometría: $e');
      print('❌ Stack trace: $stackTrace');
      
      // Retornar estado por defecto en caso de error
      return {
        'isAvailable': false,
        'isEnabled': false,
        'hasConfigured': false,
        'availableTypes': [],
        'primaryType': 'Biometría',
        'canUseBiometric': false,
      };
    }
  }

  /// Configuración inicial de biometría
  Future<Map<String, dynamic>> setupBiometric() async {
    return await enableBiometric();
  }

  /// Método de prueba para diagnosticar problemas de autenticación
  Future<Map<String, dynamic>> testBiometricAuth() async {
    try {
      print('🧪 Iniciando prueba de autenticación biométrica...');
      
      // Verificar disponibilidad básica
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      print('🧪 isAvailable: $isAvailable');
      print('🧪 isDeviceSupported: $isDeviceSupported');
      print('🧪 availableBiometrics: $availableBiometrics');
      
      if (!isAvailable || !isDeviceSupported) {
        return {
          'success': false,
          'error': 'Biometría no disponible o dispositivo no soportado',
          'code': 'NOT_AVAILABLE'
        };
      }
      
      // Intentar autenticación directa sin verificaciones adicionales
      print('🧪 Intentando autenticación directa...');
      
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Prueba de autenticación biométrica',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      
      print('🧪 Resultado de autenticación directa: $authenticated');
      
      return {
        'success': authenticated,
        'message': authenticated ? 'Prueba exitosa' : 'Prueba fallida',
        'code': authenticated ? 'SUCCESS' : 'FAILED'
      };
      
    } on PlatformException catch (e) {
      print('🧪 Error en prueba: ${e.code} - ${e.message}');
      return {
        'success': false,
        'error': 'Error en prueba: ${e.message}',
        'code': e.code
      };
    } catch (e) {
      print('🧪 Error inesperado en prueba: $e');
      return {
        'success': false,
        'error': 'Error inesperado: $e',
        'code': 'UNKNOWN_ERROR'
      };
    }
  }
} 