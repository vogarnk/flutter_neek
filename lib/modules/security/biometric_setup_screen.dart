import 'package:flutter/material.dart';
import 'package:neek/core/theme/app_colors.dart';
import 'package:neek/core/biometric_auth_service.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});

  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  bool _isLoading = true;
  bool _isSettingUp = false;
  Map<String, dynamic> _biometricStatus = {};
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    try {
      final status = await BiometricAuthService.instance.getBiometricStatus();
      setState(() {
        _biometricStatus = status;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al cargar el estado de la biometría';
        _isLoading = false;
      });
    }
  }

  Future<void> _setupBiometric() async {
    setState(() {
      _isSettingUp = true;
      _errorMessage = null;
    });

    try {
      final result = await BiometricAuthService.instance.setupBiometric();
      
      if (result['success']) {
        // Recargar estado
        await _loadBiometricStatus();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Autenticación biométrica habilitada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'No se pudo habilitar la autenticación biométrica';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al configurar la biometría: $e';
      });
    } finally {
      setState(() {
        _isSettingUp = false;
      });
    }
  }

  Future<void> _disableBiometric() async {
    setState(() {
      _isSettingUp = true;
      _errorMessage = null;
    });

    try {
      await BiometricAuthService.instance.disableBiometric();
      await _loadBiometricStatus();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Autenticación biométrica deshabilitada'),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al deshabilitar la biometría: $e';
      });
    } finally {
      setState(() {
        _isSettingUp = false;
      });
    }
  }

  void _showDiagnosticInfo() {
    final status = _biometricStatus;
    final availableTypes = status['availableTypes'] as List<dynamic>? ?? [];
    final typeNames = availableTypes.map((type) => type.toString()).join(', ');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Información de diagnóstico'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDiagnosticRow('Disponible', status['isAvailable'] ?? false),
              _buildDiagnosticRow('Habilitado', status['isEnabled'] ?? false),
              _buildDiagnosticRow('Configurado', status['hasConfigured'] ?? false),
              _buildDiagnosticRow('Puede usar biometría', status['canUseBiometric'] ?? false),
              const SizedBox(height: 8),
              Text('Tipo principal: ${status['primaryType'] ?? 'N/A'}'),
              const SizedBox(height: 4),
              Text('Tipos disponibles: ${typeNames.isEmpty ? 'Ninguno' : typeNames}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: '),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 16,
          ),
        ],
      ),
    );
  }

  Future<void> _runBiometricTest() async {
    setState(() {
      _isSettingUp = true;
      _errorMessage = null;
    });

    try {
      final result = await BiometricAuthService.instance.testBiometricAuth();
      
      setState(() {
        _isSettingUp = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(result['success'] ? 'Prueba exitosa' : 'Prueba fallida'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(result['message'] ?? 'Sin mensaje'),
              if (result['error'] != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: ${result['error']}',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 8),
              Text('Código: ${result['code']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _isSettingUp = false;
        _errorMessage = 'Error en la prueba: $e';
      });
    }
  }

  Widget _buildBiometricIcon() {
    final primaryType = _biometricStatus['primaryType'] ?? 'Biometría';
    
    if (primaryType.contains('Face ID') || primaryType.contains('Reconocimiento facial')) {
      return const Icon(
        Icons.face,
        size: 64,
        color: AppColors.primary,
      );
    } else if (primaryType.contains('Huella')) {
      return const Icon(
        Icons.fingerprint,
        size: 64,
        color: AppColors.primary,
      );
    } else {
      return const Icon(
        Icons.security,
        size: 64,
        color: AppColors.primary,
      );
    }
  }

  Widget _buildStatusCard() {
    final isEnabled = _biometricStatus['isEnabled'] ?? false;
    final primaryType = _biometricStatus['primaryType'] ?? 'Biometría';
    final hasConfigured = _biometricStatus['hasConfigured'] ?? false;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isEnabled ? Colors.green.shade200 : AppColors.textGray300,
        ),
      ),
      child: Column(
        children: [
          _buildBiometricIcon(),
          const SizedBox(height: 16),
          Text(
            primaryType,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textGray900,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isEnabled ? Colors.green.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEnabled ? 'Habilitado' : 'Deshabilitado',
              style: TextStyle(
                color: isEnabled ? Colors.green.shade700 : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!hasConfigured)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'No tienes $primaryType configurado en tu dispositivo',
                      style: TextStyle(
                        color: Colors.orange.shade700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Autenticación biométrica'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Seguridad adicional',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Habilita la autenticación biométrica para acceder a Neek de forma más segura y rápida.',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textGray300,
                    ),
                  ),
                  const SizedBox(height: 32),

                  _buildStatusCard(),
                  const SizedBox(height: 24),

                  // Mensaje de error
                  if (_errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _errorMessage!,
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Botones de acción
                  if (_biometricStatus['isEnabled'] == true)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSettingUp ? null : _disableBiometric,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSettingUp
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Deshabilitar biometría',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSettingUp ? null : _setupBiometric,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isSettingUp
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Habilitar biometría',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isSettingUp ? null : _showDiagnosticInfo,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.textGray300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Ver información de diagnóstico',
                              style: TextStyle(
                                color: AppColors.textGray300,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _isSettingUp ? null : _runBiometricTest,
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text(
                              'Ejecutar prueba de biometría',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 16),

                  // Información adicional
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¿Cómo funciona?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textGray900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '• Cada vez que abras la app, se te pedirá autenticarte con tu biometría\n'
                          '• Si cancelas, podrás usar tu contraseña normal\n'
                          '• Tus datos biométricos se almacenan de forma segura en tu dispositivo',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textGray500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 