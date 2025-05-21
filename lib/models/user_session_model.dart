class UserSession {
  final String id;
  final String ipAddress;
  final String userAgent;
  final String lastActivity;
  final bool isCurrent;

  UserSession({
    required this.id,
    required this.ipAddress,
    required this.userAgent,
    required this.lastActivity,
    required this.isCurrent,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'],
      ipAddress: json['ip_address'] ?? '',
      userAgent: json['user_agent'] ?? '',
      lastActivity: json['last_activity'] ?? '',
      isCurrent: json['is_current'] ?? false,
    );
  }
}
