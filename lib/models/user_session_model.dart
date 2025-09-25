class UserSession {
  final String id;
  final String deviceType;
  final String userAgent;
  final String lastActivity;
  final String timeAgo;
  final bool isExpired;
  final String sessionType;
  final String tokenName;

  UserSession({
    required this.id,
    required this.deviceType,
    required this.userAgent,
    required this.lastActivity,
    required this.timeAgo,
    required this.isExpired,
    required this.sessionType,
    required this.tokenName,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'].toString(), // Convertir a String
      deviceType: json['device_type'] ?? '',
      userAgent: json['user_agent'] ?? '',
      lastActivity: json['last_activity'] ?? '',
      timeAgo: json['time_ago'] ?? '',
      isExpired: json['is_expired'] ?? false,
      sessionType: json['session_type'] ?? '',
      tokenName: json['token_name'] ?? '',
    );
  }
}
