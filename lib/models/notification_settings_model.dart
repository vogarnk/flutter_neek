class NotificationSettings {
  final bool appAccountActivity;
  final bool appInvestmentPerformance;
  final bool emailNews;
  final bool emailFinancialAdvice;
  final bool emailEvents;
  final bool whatsappEmergency;
  final bool whatsappSurveys;
  final bool whatsappPromotions;
  final bool whatsappMarketing;

  NotificationSettings({
    required this.appAccountActivity,
    required this.appInvestmentPerformance,
    required this.emailNews,
    required this.emailFinancialAdvice,
    required this.emailEvents,
    required this.whatsappEmergency,
    required this.whatsappSurveys,
    required this.whatsappPromotions,
    required this.whatsappMarketing,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    bool toBool(dynamic value) => value == 1;

    return NotificationSettings(
      appAccountActivity: toBool(json['app_account_activity']),
      appInvestmentPerformance: toBool(json['app_investment_performance']),
      emailNews: toBool(json['email_news']),
      emailFinancialAdvice: toBool(json['email_financial_advice']),
      emailEvents: toBool(json['email_events']),
      whatsappEmergency: toBool(json['whatsapp_emergency']),
      whatsappSurveys: toBool(json['whatsapp_surveys']),
      whatsappPromotions: toBool(json['whatsapp_promotions']),
      whatsappMarketing: toBool(json['whatsapp_marketing']),
    );
  }

  factory NotificationSettings.empty() {
    return NotificationSettings(
      appAccountActivity: false,
      appInvestmentPerformance: false,
      emailNews: false,
      emailFinancialAdvice: false,
      emailEvents: false,
      whatsappEmergency: false,
      whatsappSurveys: false,
      whatsappPromotions: false,
      whatsappMarketing: false,
    );
  }

}
