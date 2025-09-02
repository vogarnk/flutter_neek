class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? filePath;
  final String? fileName;
  final String? fileType;
  final String? conversationId;
  final bool isRead;
  final String? agentId;
  final String? agentName;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.filePath,
    this.fileName,
    this.fileType,
    this.conversationId,
    this.isRead = false,
    this.agentId,
    this.agentName,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      text: json['text'] ?? json['message'] ?? '',
      isUser: json['is_user'] ?? false,
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      filePath: json['file_path'],
      fileName: json['file_name'],
      fileType: json['file_type'],
      conversationId: json['conversation_id'],
      isRead: json['is_read'] ?? false,
      agentId: json['agent_id'],
      agentName: json['agent_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'is_user': isUser,
      'timestamp': timestamp.toIso8601String(),
      'file_path': filePath,
      'file_name': fileName,
      'file_type': fileType,
      'conversation_id': conversationId,
      'is_read': isRead,
      'agent_id': agentId,
      'agent_name': agentName,
    };
  }

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? filePath,
    String? fileName,
    String? fileType,
    String? conversationId,
    bool? isRead,
    String? agentId,
    String? agentName,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      fileType: fileType ?? this.fileType,
      conversationId: conversationId ?? this.conversationId,
      isRead: isRead ?? this.isRead,
      agentId: agentId ?? this.agentId,
      agentName: agentName ?? this.agentName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatMessage(id: $id, text: $text, isUser: $isUser, timestamp: $timestamp)';
  }
}
