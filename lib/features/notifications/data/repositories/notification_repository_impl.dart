import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> fetchNotifications() async {
    final models = await remoteDataSource.fetchNotifications();
    return List<NotificationEntity>.from(models);
  }

  @override
  Future<void> markAsRead(String id) {
    return remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() {
    return remoteDataSource.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String id) {
    return remoteDataSource.deleteNotification(id);
  }

  @override
  Future<int> getUnreadCount() {
    return remoteDataSource.getUnreadCount();
  }
}
