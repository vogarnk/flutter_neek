# Módulo de Selección de Tipo de Ahorro

Este módulo implementa la nueva funcionalidad de selección de tipo de ahorro que reemplaza la pantalla anterior que pedía plazo ahorro y ahorro anual.

## Estructura del Módulo

### Archivos Principales

- `savings_type_selection_screen.dart` - Pantalla principal de selección de tipo de ahorro
- `savings_results_screen.dart` - Pantalla de resultados de la simulación
- `cards/` - Directorio con los cards específicos para cada tipo de ahorro
  - `monthly_savings_card.dart` - Card para ahorro mensual
  - `target_amount_card.dart` - Card para monto objetivo
  - `education_card.dart` - Card para educación
  - `insurance_amount_card.dart` - Card para suma asegurada

### Servicios y Modelos

- `lib/core/quote_service.dart` - Servicio para manejar las APIs de simulación
- `lib/models/savings_models.dart` - Modelos de datos para los diferentes tipos de ahorro

## Tipos de Ahorro Disponibles

### 1. Ahorro Mensual (`monthly-savings`)
- **Descripción**: Simulación basada en un monto fijo de ahorro mensual
- **Parámetros**:
  - Edad del usuario (18-60 años)
  - Duración del plan (5, 10, 15, 20 años)
  - Ahorro mensual (1500, 2500, 3500, 4500, 6000, 7500, 8000, 9000)

### 2. Monto Objetivo (`target-amount`)
- **Descripción**: Simulación basada en un monto específico que se desea retirar
- **Parámetros**:
  - Edad del usuario (18-60 años)
  - Monto objetivo a retirar (mínimo 1000)
  - Edad objetivo para retirar (18-85 años, debe ser mayor a la edad actual)

### 3. Educación (`education`)
- **Descripción**: Simulación enfocada en ahorro para educación universitaria
- **Parámetros**:
  - Edad del usuario (18-60 años)
  - Ahorro mensual (1500, 2500, 3500, 4500, 6000, 7500, 8000, 9000)
  - Años hasta la universidad (1-42 años)

### 4. Suma Asegurada (`insurance-amount`)
- **Descripción**: Simulación basada en una suma asegurada específica
- **Parámetros**:
  - Edad del usuario (18-60 años)
  - Suma asegurada deseada (mínimo 10,000)
  - Número de beneficiarios (1-10, opcional, por defecto 1)

## Flujo de Implementación

### 1. Selección de Tipo
El usuario selecciona uno de los 4 tipos de ahorro disponibles en la pantalla principal.

### 2. Configuración de Parámetros
Se despliega el card correspondiente con los campos de entrada específicos para cada tipo.

### 3. Generación de Simulación
Se envía una petición al endpoint correspondiente y se genera un token único.

### 4. Visualización de Resultados
Se muestran los resultados de la simulación con la opción de continuar al registro.

### 5. Integración con Registro
Los datos de la simulación se pasan al flujo de registro existente.

## Uso

### Navegación desde el Registro
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const SavingsTypeSelectionScreen(),
  ),
);
```

### Integración con el Flujo Existente
La nueva funcionalidad se integra perfectamente con el flujo de registro existente, manteniendo la compatibilidad con el sistema actual.

## Características Técnicas

- **Validación**: Validación robusta de todos los parámetros de entrada
- **UI/UX**: Interfaz moderna y consistente con el diseño existente
- **Manejo de Errores**: Manejo completo de errores con mensajes informativos
- **Responsive**: Diseño adaptable a diferentes tamaños de pantalla
- **Accesibilidad**: Implementación de mejores prácticas de accesibilidad

## Consideraciones de Desarrollo

### APIs de Simulación
Actualmente se utilizan datos simulados para demostración. Para implementación en producción, reemplazar las llamadas simuladas con las APIs reales del servicio `QuoteService`.

### Persistencia
Los tokens de simulación se pueden persistir localmente para permitir continuar con la simulación si se cierra la app.

### Testing
Se recomienda implementar tests unitarios y de integración para asegurar la funcionalidad correcta.

## Próximos Pasos

1. **Integración con APIs Reales**: Reemplazar las simulaciones con llamadas reales a las APIs
2. **Persistencia de Datos**: Implementar almacenamiento local para tokens y datos de simulación
3. **Testing**: Agregar tests unitarios y de integración
4. **Optimización**: Optimizar el rendimiento y la experiencia de usuario
5. **Documentación**: Expandir la documentación técnica y de usuario
