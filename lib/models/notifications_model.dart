class NotificationModel {
  final String title;
  final String message;
  final DateTime? date;
  final bool isNew;

  NotificationModel({
    required this.title,
    required this.message,
    required this.date,
    required this.isNew,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      isNew: json['is_new'] == true || json['is_new'] == 1,
      date: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}