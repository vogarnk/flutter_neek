import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/cards/agent_card.dart'; // ⬅️ Asegúrate de que la ruta sea correcta
import '../misc/edit_request_screen.dart'; // ⬅️ Asegúrate de que la ruta sea correcta

class AccountDetailScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const AccountDetailScreen({super.key, required this.user});

  // Función para convertir códigos de estado a nombres completos
  String _getEstadoNacimiento(String? estadoCode) {
    if (estadoCode == null || estadoCode.isEmpty) {
      return 'No especificado';
    }

    const Map<String, String> estados = {
      'AS': 'Aguascalientes',
      'BC': 'Baja California',
      'BS': 'Baja California Sur',
      'CC': 'Campeche',
      'CL': 'Coahuila de Zaragoza',
      'CM': 'Colima',
      'CS': 'Chiapas',
      'CH': 'Chihuahua',
      'DF': 'Ciudad de México',
      'DG': 'Durango',
      'GT': 'Guanajuato',
      'GR': 'Guerrero',
      'HG': 'Hidalgo',
      'JC': 'Jalisco',
      'MC': 'México',
      'MN': 'Michoacán de Ocampo',
      'MS': 'Morelos',
      'NT': 'Nayarit',
      'NL': 'Nuevo León',
      'OC': 'Oaxaca',
      'PL': 'Puebla',
      'QT': 'Querétaro',
      'QR': 'Quintana Roo',
      'SP': 'San Luis Potosí',
      'SL': 'Sinaloa',
      'SR': 'Sonora',
      'TC': 'Tabasco',
      'TS': 'Tamaulipas',
      'TL': 'Tlaxcala',
      'VZ': 'Veracruz',
      'YN': 'Yucatán',
      'ZS': 'Zacatecas',
      'NE': 'Nacido en el Extranjero',
    };

    return estados[estadoCode.toUpperCase()] ?? estadoCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1320),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1320),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Mi Cuenta', style: TextStyle(color: Colors.white)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 🔵 Card de Detalles del Usuario
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: user['avatar'] != null && user['avatar'].toString().isNotEmpty
                        ? NetworkImage('https://app.neek.mx/storage/${user['avatar']}')
                        : null,
                    child: (user['avatar'] == null || user['avatar'].toString().isEmpty)
                        ? const Icon(Icons.person, size: 36, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(height: 12),
                  Text(
                      '${user['name']} ${user['sName'] ?? ''} ${user['lName'] ?? ''} ${user['lName2'] ?? ''}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Header con título y botón cerrar
                                  Row(
                                    children: [
                                      const Expanded(
                                        child: Text(
                                          'Cambiar imagen de perfil',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  // Imagen placeholder sobre fondo con cuadrícula
                                  Container(
                                    width: double.infinity,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: const Color(0xFFE5E7EB),
                                      image: const DecorationImage(
                                        image: AssetImage('assets/images/grid_background.png'), // cuadrícula
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: const Center(
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color(0xFF9CA3AF),
                                        child: Icon(Icons.person, size: 60, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Text(
                                    'Ajusta la imagen dentro de la retícula. Una imagen tuya ayudará a tu agente a reconocerte y permitirá saber cuando has accedido a tu cuenta.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Botón guardar
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context); // Aquí puedes colocar la lógica para subir imagen
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF2B5FF3),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                      ),
                                      child: const Text(
                                        'Guardar',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Cambiar imagen',
                      style: TextStyle(
                        color: Color(0xFF2B5FF3),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _userRow(label: 'Usuario', value: '${user['name'] ?? ''} ${user['lName'] ?? ''}'.toLowerCase().replaceAll(' ', '')),
                  //si el usuario tiene perfil_completo con el valor 1, mostrar el icono de verificado
                  if (user['perfil_completo'] == 1)
                  _userRow(
                    label: 'Estado',
                    value: 'Verificado',
                    trailing: Icon(Icons.verified, size: 18, color: Color(0xFF2B5FF3)),
                  ),
                  _userRow(label: 'Número de cliente', value: 'NK-2310-01-W857567'),
                  _userRow(label: 'Nombre(s)', value: '${user['name'] ?? ''} ${user['sName'] ?? ''}' ),
                  _userRow(label: 'Apellidos', value: '${user['lName'] ?? ''} ${user['lName2'] ?? ''}'),
                  //Genero mostrarlo correctamente puede ser male o masculino o female o femenino, si no tiene genero mostrar un texto que diga "No especificado" y considerar acentos y primer letra mayusculas
                  _userRow(label: 'Género', value: user['genero'] == 'masculini' ? 'Masculino' : user['genero'] == 'femenino' ? 'Femenino' : 'No especificado'),
                  //Mostrar la fecha entendible para mexico y si no tiene fecha de nacimiento mostrar un texto que diga "No especificado"
                  _userRow(label: 'Fecha de Nacimiento', value: user['dateBirth'] != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(user['dateBirth'])) : 'No especificado'),
                  //De acuerdo a la curp puede ser SP, DF, CH, NL, etc. mostrar correctamente el estado de nacimiento
                  _userRow(label: 'Lugar de Nacimiento', value: _getEstadoNacimiento(user['estadoNacimiento'])),
                  //Si el curp es null mostrar un texto que diga "No especificado"
                  _userRow(label: 'CURP', value: user['curp'] ?? 'No especificado'),
                  //Si el rfc es null mostrar un texto que diga "No especificado"
                  _userRow(label: 'RFC', value: user['rfc'] ?? 'No especificado'),
                  _userRow(label: 'Correo', value: user['email'] ?? ''),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                            title: Text(
                              '¿Te gustaría enviar una solicitud de cambio de datos?',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Theme.of(context).textTheme.displaySmall?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F0FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: const [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.info, color: Color(0xFF2B5FF3)),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    '¡Tus datos han sido revisados!',
                                                    style: TextStyle(
                                                      color: Color(0xFF2B5FF3),
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Tus datos personales fueron llenados al momento de crear tu cotización, '
                                              'si encuentras algún error en tu información o deseas cambiar algún dato, '
                                              'puedes enviar una solicitud a tu Agente Neek.',
                                              style: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text(
                                          'Cancelar',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const EditRequestScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF2B5FF3),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                        ),
                                        child: const Text(
                                          'Continuar',
                                          style: TextStyle(fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Envía una solicitud de cambio de información',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🟣 Card del Agente (fuera del contenedor anterior)
            //const AgentCard(),
          ],
        ),
      ),
    );
  }

  Widget _userRow({required String label, required String value, Widget? trailing}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1), // gris clarito
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing,
              ]
            ],
          )
        ],
      ),
    );
  }
}