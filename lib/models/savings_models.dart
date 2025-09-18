import 'package:flutter/material.dart';

class SavingsType {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  SavingsType({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });

  static List<SavingsType> get allTypes => [
    SavingsType(
      id: 'monthly-savings',
      title: 'Ahorro Mensual',
      description: 'Ahorra una cantidad fija cada mes',
      icon: Icons.savings,
      color: const Color(0xFF2563EB),
    ),
    SavingsType(
      id: 'target-amount',
      title: 'Monto Objetivo',
      description: 'Define cuánto quieres retirar',
      icon: Icons.flag,
      color: const Color(0xFF059669),
    ),
    SavingsType(
      id: 'education',
      title: 'Educación',
      description: 'Ahorra para la educación universitaria',
      icon: Icons.school,
      color: const Color(0xFFDC2626),
    ),
    SavingsType(
      id: 'insurance-amount',
      title: 'Suma Asegurada',
      description: 'Protege a tus beneficiarios',
      icon: Icons.security,
      color: const Color(0xFF7C3AED),
    ),
  ];
}

class MonthlySavingsData {
  final int age;
  final int planDuration;
  final double monthlySavings;

  MonthlySavingsData({
    required this.age,
    required this.planDuration,
    required this.monthlySavings,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'plan_duration': planDuration,
    'monthly_savings': monthlySavings,
  };
}

class TargetAmountData {
  final int age;
  final double targetAmount;
  final int targetAge;

  TargetAmountData({
    required this.age,
    required this.targetAmount,
    required this.targetAge,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'target_amount': targetAmount,
    'target_age': targetAge,
  };
}

class EducationData {
  final int age;
  final double monthlySavings;
  final int yearsToUniversity;

  EducationData({
    required this.age,
    required this.monthlySavings,
    required this.yearsToUniversity,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'monthly_savings': monthlySavings,
    'years_to_university': yearsToUniversity,
  };
}

class InsuranceAmountData {
  final int age;
  final double insuranceAmount;
  final int beneficiaries;

  InsuranceAmountData({
    required this.age,
    required this.insuranceAmount,
    required this.beneficiaries,
  });

  Map<String, dynamic> toJson() => {
    'age': age,
    'insurance_amount': insuranceAmount,
    'beneficiaries': beneficiaries,
  };
}

class SavingsSimulationResult {
  final String simulationType;
  final Map<String, dynamic> parameters;
  final Map<String, dynamic> results;
  final String token;
  final DateTime expiresAt;

  SavingsSimulationResult({
    required this.simulationType,
    required this.parameters,
    required this.results,
    required this.token,
    required this.expiresAt,
  });

  factory SavingsSimulationResult.fromJson(Map<String, dynamic> json) {
    return SavingsSimulationResult(
      simulationType: json['simulation_type'] ?? '',
      parameters: json['parameters'] ?? {},
      results: json['results'] ?? {},
      token: json['token'] ?? '',
      expiresAt: DateTime.parse(json['expires_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Constantes para los valores permitidos
class SavingsConstants {
  static const List<int> ages = [18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60];
  
  static const List<int> planDurations = [5, 10, 15, 20];
  
  static const List<double> monthlySavingsOptions = [1500, 2500, 3500, 4500, 6000, 7500, 8000, 9000];
  
  static const List<int> yearsToUniversity = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42];
  
  static const List<int> beneficiariesOptions = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  
  static const double minTargetAmount = 1000.0;
  static const double minInsuranceAmount = 10000.0;
}
