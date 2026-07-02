class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String type;
  final String referenceId;
  final bool isRead;
  final DateTime createdAt;
  final String? actionUrl;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.referenceId,
    required this.isRead,
    required this.createdAt,
    this.actionUrl,
  });
}
