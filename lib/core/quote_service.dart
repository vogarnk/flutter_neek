import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuoteService {
  static const String baseUrl = 'https://app.neek.mx/api/quote';
  
  // Generar token para ahorro mensual
  Future<QuoteResponse> simulateMonthlySavings({
    required int age,
    required int planDuration,
    required double monthlySavings,
  }) async {
    try {
      final requestBody = {
        'age': age,
        'plan_duration': planDuration,
        'monthly_savings': monthlySavings,
      };
      
      debugPrint('=== API REQUEST: monthly-savings ===');
      debugPrint('URL: $baseUrl/simulate/monthly-savings');
      debugPrint('Body: ${json.encode(requestBody)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/simulate/monthly-savings'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al generar simulación');
      }
    } catch (e) {
      debugPrint('Error en simulateMonthlySavings: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Generar token para monto objetivo
  Future<QuoteResponse> simulateTargetAmount({
    required int age,
    required double targetAmount,
    required int targetAge,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate/target-amount'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'age': age,
          'target_amount': targetAmount,
          'target_age': targetAge,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al generar simulación');
      }
    } catch (e) {
      debugPrint('Error en simulateTargetAmount: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Generar token para educación
  Future<QuoteResponse> simulateEducation({
    required int age,
    required double monthlySavings,
    required int yearsToUniversity,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate/education'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'age': age,
          'monthly_savings': monthlySavings,
          'years_to_university': yearsToUniversity,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al generar simulación');
      }
    } catch (e) {
      debugPrint('Error en simulateEducation: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Generar token para suma asegurada
  Future<QuoteResponse> simulateInsuranceAmount({
    required int age,
    required double insuranceAmount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate/insurance-amount'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'age': age,
          'insurance_amount': insuranceAmount,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResponse.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al generar simulación');
      }
    } catch (e) {
      debugPrint('Error en simulateInsuranceAmount: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Obtener resultados por token
  Future<QuoteResults> getResultsByToken(String token) async {
    try {
      debugPrint('=== API REQUEST: getResultsByToken ===');
      debugPrint('URL: $baseUrl/results/$token');
      
      final response = await http.get(
        Uri.parse('$baseUrl/results/$token'),
        headers: {
          'Accept': 'application/json',
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return QuoteResults.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al obtener resultados');
      }
    } catch (e) {
      debugPrint('Error en getResultsByToken: $e');
      throw Exception('Error de conexión: $e');
    }
  }
  
  // Verificar token
  Future<TokenVerification> verifyToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/verify/$token'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TokenVerification.fromJson(data);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error al verificar token');
      }
    } catch (e) {
      debugPrint('Error en verifyToken: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}

class QuoteResponse {
  final bool success;
  final String message;
  final String token;
  final String redirectUrl;
  final DateTime expiresAt;

  QuoteResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.redirectUrl,
    required this.expiresAt,
  });

  factory QuoteResponse.fromJson(Map<String, dynamic> json) {
    return QuoteResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      redirectUrl: json['redirect_url'] ?? '',
      expiresAt: DateTime.parse(json['expires_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class QuoteResults {
  final String simulationType;
  final Map<String, dynamic> parameters;
  final List<PlanOption> plans;

  QuoteResults({
    required this.simulationType,
    required this.parameters,
    required this.plans,
  });

  factory QuoteResults.fromJson(Map<String, dynamic> json) {
    final List<dynamic> resultsData = json['data']['results'] ?? [];
    List<PlanOption> plans = [];
    
    // Extraer planes de cada resultado
    for (var result in resultsData) {
      final List<dynamic> quotes = result['quotes'] ?? [];
      final String csvFile = result['csv_file'] ?? '';
      debugPrint('CSV file found: $csvFile');
      for (var quote in quotes) {
        // Agregar el archivo CSV al quote
        quote['csv_file'] = csvFile;
        debugPrint('Quote ID: ${quote['id']}, CSV: $csvFile');
        plans.add(PlanOption.fromJson(quote));
      }
    }
    
    return QuoteResults(
      simulationType: json['data']['simulation_type'] ?? '',
      parameters: json['data']['parameters'] ?? {},
      plans: plans,
    );
  }
}

class PlanOption {
  final int id;
  final int age;
  final int year;
  final String ageRange;
  final String coverageType;
  final int planDuration;
  final String udiValueUsed;
  final String monthlySavings;
  final String primaAnualUdis;
  final double primaMensualMxn;
  final double udiValueAt2050;
  final double annualGrowthRate;
  final double sumaAseguradaMxn;
  final String sumaAseguradaUdis;
  final double totalRetirar2050Mxn;
  final double totalRetirarPlanMxn;
  final double udiValueAtPlanYear;
  final String totalRetirar2050Udis;
  final String totalRetirarPlanUdis;
  final String? csvFile;
  final int? targetYear;
  final double? udiValueAtTarget;
  final double? valueAtTargetAge;
  final int? valorRescateUdisAtTarget;

  PlanOption({
    required this.id,
    required this.age,
    required this.year,
    required this.ageRange,
    required this.coverageType,
    required this.planDuration,
    required this.udiValueUsed,
    required this.monthlySavings,
    required this.primaAnualUdis,
    required this.primaMensualMxn,
    required this.udiValueAt2050,
    required this.annualGrowthRate,
    required this.sumaAseguradaMxn,
    required this.sumaAseguradaUdis,
    required this.totalRetirar2050Mxn,
    required this.totalRetirarPlanMxn,
    required this.udiValueAtPlanYear,
    required this.totalRetirar2050Udis,
    required this.totalRetirarPlanUdis,
    this.csvFile,
    this.targetYear,
    this.udiValueAtTarget,
    this.valueAtTargetAge,
    this.valorRescateUdisAtTarget,
  });

  factory PlanOption.fromJson(Map<String, dynamic> json) {
    return PlanOption(
      id: json['id'] ?? 0,
      age: json['age'] ?? 0,
      year: json['year'] ?? 0,
      ageRange: json['age_range'] ?? '',
      coverageType: json['coverage_type'] ?? '',
      planDuration: json['plan_duration'] ?? 0,
      udiValueUsed: json['udi_value_used'] ?? '0',
      monthlySavings: json['monthly_savings'] ?? '0',
      primaAnualUdis: json['prima_anual_udis'] ?? '0',
      primaMensualMxn: (json['prima_mensual_mxn'] ?? 0).toDouble(),
      udiValueAt2050: (json['udi_value_at_2050'] ?? 0).toDouble(),
      annualGrowthRate: (json['annual_growth_rate'] ?? 0).toDouble(),
      sumaAseguradaMxn: (json['suma_asegurada_mxn'] ?? 0).toDouble(),
      sumaAseguradaUdis: json['suma_asegurada_udis'] ?? '0',
      totalRetirar2050Mxn: (json['total_retirar_2050_mxn'] ?? 0).toDouble(),
      totalRetirarPlanMxn: (json['total_retirar_plan_mxn'] ?? 0).toDouble(),
      udiValueAtPlanYear: (json['udi_value_at_plan_year'] ?? 0).toDouble(),
      totalRetirar2050Udis: json['total_retirar_2050_udis'] ?? '0',
      totalRetirarPlanUdis: json['total_retirar_plan_udis'] ?? '0',
      csvFile: json['csv_file'],
      targetYear: json['target_year'],
      udiValueAtTarget: json['udi_value_at_target']?.toDouble(),
      valueAtTargetAge: json['value_at_target_age']?.toDouble(),
      valorRescateUdisAtTarget: json['valor_rescate_udis_at_target']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'age': age,
      'year': year,
      'age_range': ageRange,
      'coverage_type': coverageType,
      'plan_duration': planDuration,
      'udi_value_used': udiValueUsed,
      'monthly_savings': monthlySavings,
      'prima_anual_udis': primaAnualUdis,
      'prima_mensual_mxn': primaMensualMxn,
      'udi_value_at_2050': udiValueAt2050,
      'annual_growth_rate': annualGrowthRate,
      'suma_asegurada_mxn': sumaAseguradaMxn,
      'suma_asegurada_udis': sumaAseguradaUdis,
      'total_retirar_2050_mxn': totalRetirar2050Mxn,
      'total_retirar_plan_mxn': totalRetirarPlanMxn,
      'udi_value_at_plan_year': udiValueAtPlanYear,
      'total_retirar_2050_udis': totalRetirar2050Udis,
      'total_retirar_plan_udis': totalRetirarPlanUdis,
      'csv_file': csvFile, // 👈 CRÍTICO: Incluir el archivo CSV
      'target_year': targetYear,
      'udi_value_at_target': udiValueAtTarget,
      'value_at_target_age': valueAtTargetAge,
      'valor_rescate_udis_at_target': valorRescateUdisAtTarget,
    };
  }
}

class TokenVerification {
  final String token;
  final String simulationType;
  final bool isValid;
  final DateTime expiresAt;
  final DateTime? usedAt;
  final DateTime createdAt;

  TokenVerification({
    required this.token,
    required this.simulationType,
    required this.isValid,
    required this.expiresAt,
    this.usedAt,
    required this.createdAt,
  });

  factory TokenVerification.fromJson(Map<String, dynamic> json) {
    return TokenVerification(
      token: json['token'] ?? '',
      simulationType: json['simulation_type'] ?? '',
      isValid: json['is_valid'] ?? false,
      expiresAt: DateTime.parse(json['expires_at'] ?? DateTime.now().toIso8601String()),
      usedAt: json['used_at'] != null ? DateTime.parse(json['used_at']) : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

