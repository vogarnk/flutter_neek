# Documentación de API de Beneficiarios

## Factory de Laravel

El factory de beneficiarios en Laravel define la estructura de datos para crear beneficiarios:

```php
class BeneficiarioFactory extends Factory
{
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'user_beneficiario_id' => User::factory(),
            'user_plan_id' => UserPlan::factory(),
            'tipo' => $this->faker->randomElement(['basico', 'intermedio', 'avanzado']),
            'porcentaje' => $this->faker->numberBetween(1, 100),
            'parentesco' => $this->faker->randomElement(['Hijo', 'Hija', 'Esposo', 'Esposa', 'Padre', 'Madre', 'Hermano', 'Hermana']),
            'activo' => $this->faker->boolean(80), // 80% de probabilidad de estar activo
        ];
    }
}
```

## Estructura de Datos Esperada

### Campos Requeridos
- `user_id`: ID del usuario asegurado
- `user_beneficiario_id`: ID del usuario beneficiario (si existe)
- `user_plan_id`: ID del plan del usuario
- `tipo`: Tipo de beneficiario ('basico', 'intermedio', 'avanzado')
- `porcentaje`: Porcentaje de la suma asegurada (1-100)
- `parentesco`: Relación familiar
- `activo`: Estado del beneficiario (true/false)

### Campos Opcionales
- `nombres`: Nombre del beneficiario
- `segundo_nombre`: Segundo nombre (opcional)
- `apellido_paterno`: Apellido paterno
- `apellido_materno`: Apellido materno (opcional)
- `fecha_nacimiento`: Fecha de nacimiento
- `ocupacion`: Ocupación del beneficiario
- `domicilio`: Información del domicilio
- `ine_file`: Archivo de identificación
- `tutor`: Información del tutor (si es menor de edad)

## Llamadas Correctas a la API

### 1. Crear Beneficiario

**Endpoint:** `POST /api/beneficiarios`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
```

**Body:**
```json
{
  "nombres": "Juan Carlos",
  "segundo_nombre": "Luis",
  "apellido_paterno": "García",
  "apellido_materno": "Sánchez",
  "fecha_nacimiento": "1990-05-15T00:00:00.000Z",
  "parentesco": "Hijo",
  "ocupacion": "Ingeniero",
  "porcentaje": 50.0,
  "tipo": "basico",
  "mismo_domicilio": true,
  "domicilio": {
    "calle": "Av. Reforma",
    "colonia": "Centro",
    "codigo_postal": "06000",
    "estado": "Ciudad de México",
    "numero_exterior": "123",
    "numero_interior": "A",
    "ciudad": "Ciudad de México",
    "pais": "México"
  },
  "ine_file": "base64_encoded_file_content",
  "tutor": {
    "nombre_completo": "María García Sánchez",
    "fecha_nacimiento": "1965-03-20T00:00:00.000Z",
    "parentesco": "Madre",
    "ocupacion": "Ama de casa",
    "domicilio": {
      "calle": "Calle Principal",
      "colonia": "Residencial"
    }
  }
}
```

**Respuesta Exitosa (201):**
```json
{
  "success": true,
  "message": "Beneficiario creado exitosamente",
  "data": {
    "id": 1,
    "user_id": 1,
    "user_beneficiario_id": null,
    "user_plan_id": 1,
    "nombres": "Juan Carlos",
    "segundo_nombre": "Luis",
    "apellido_paterno": "García",
    "apellido_materno": "Sánchez",
    "fecha_nacimiento": "1990-05-15T00:00:00.000Z",
    "parentesco": "Hijo",
    "ocupacion": "Ingeniero",
    "porcentaje": 50.0,
    "tipo": "basico",
    "activo": true,
    "mismo_domicilio": true,
    "created_at": "2024-01-15T10:30:00.000Z",
    "updated_at": "2024-01-15T10:30:00.000Z"
  }
}
```

### 2. Obtener Beneficiarios

**Endpoint:** `GET /api/beneficiarios`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

**Respuesta Exitosa (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "user_id": 1,
      "user_beneficiario_id": null,
      "user_plan_id": 1,
      "nombres": "Juan Carlos",
      "segundo_nombre": "Luis",
      "apellido_paterno": "García",
      "apellido_materno": "Sánchez",
      "fecha_nacimiento": "1990-05-15T00:00:00.000Z",
      "parentesco": "Hijo",
      "ocupacion": "Ingeniero",
      "porcentaje": 50.0,
      "tipo": "basico",
      "activo": true,
      "mismo_domicilio": true,
      "created_at": "2024-01-15T10:30:00.000Z",
      "updated_at": "2024-01-15T10:30:00.000Z"
    }
  ]
}
```

### 3. Actualizar Beneficiario

**Endpoint:** `PUT /api/beneficiarios/{id}`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
```

**Body:** (solo los campos a actualizar)
```json
{
  "porcentaje": 60.0,
  "tipo": "intermedio",
  "activo": false
}
```

### 4. Eliminar Beneficiario

**Endpoint:** `DELETE /api/beneficiarios/{id}`

**Headers:**
```
Authorization: Bearer {token}
Accept: application/json
```

### 5. Activar/Desactivar Beneficiario

**Endpoint:** `PATCH /api/beneficiarios/{id}/status`

**Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
```

**Body:**
```json
{
  "activo": true
}
```

## Validaciones Importantes

### 1. Porcentajes
- La suma de todos los porcentajes de beneficiarios activos no debe exceder 100%
- Cada beneficiario debe tener un porcentaje entre 1 y 100

### 2. Edad y Tutor
- Si el beneficiario es menor de 18 años, se requiere información del tutor
- El tutor debe ser mayor de edad

### 3. Tipos de Beneficiario
- `basico`: Acceso básico a información
- `intermedio`: Acceso intermedio a información
- `avanzado`: Acceso completo a información

### 4. Parentescos Válidos
- Hijo, Hija, Esposo, Esposa, Padre, Madre, Hermano, Hermana

## Códigos de Error Comunes

- `400`: Datos inválidos o validaciones fallidas
- `401`: Token de autenticación inválido o expirado
- `403`: No autorizado para realizar la acción
- `404`: Beneficiario no encontrado
- `422`: Error de validación (porcentajes, edad, etc.)
- `500`: Error interno del servidor

## Ejemplos de Uso en Flutter

### Crear Beneficiario
```dart
try {
  final beneficiario = await BeneficiarioService.createBeneficiario(
    nombres: "Juan Carlos",
    apellidoPaterno: "García",
    fechaNacimiento: DateTime(1990, 5, 15),
    parentesco: "Hijo",
    porcentaje: 50.0,
    tipo: "basico",
    mismoDomicilio: true,
  );
  print('Beneficiario creado: ${beneficiario['id']}');
} catch (e) {
  print('Error: $e');
}
```

### Obtener Beneficiarios
```dart
try {
  final beneficiarios = await BeneficiarioService.getBeneficiarios();
  print('Total beneficiarios: ${beneficiarios.length}');
} catch (e) {
  print('Error: $e');
}
```

### Validar Porcentajes
```dart
final beneficiarios = await BeneficiarioService.getBeneficiarios();
final nuevoPorcentaje = 30.0;

if (BeneficiarioService.validatePorcentajes(beneficiarios, nuevoPorcentaje)) {
  // Proceder a crear el beneficiario
} else {
  // Mostrar error: porcentaje excede el 100%
}
```

