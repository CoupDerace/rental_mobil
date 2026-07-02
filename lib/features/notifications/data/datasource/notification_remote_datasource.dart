import '../../../../core/network/supabase_service.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> fetchNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  @override
  Future<List<NotificationModel>> fetchNotifications() async {
    final response = await SupabaseService.from(
      'notifications',
    ).select().order('created_at', ascending: false);

    return (response as List)
        .map((e) => NotificationModel.fromJson(e))
        .toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await SupabaseService.from(
      'notifications',
    ).update({'is_read': true}).eq('id', id);
  }

  @override
  Future<void> markAllAsRead() async {
    await SupabaseService.from(
      'notifications',
    ).update({'is_read': true}).eq('is_read', false);
  }

  @override
  Future<void> deleteNotification(String id) async {
    await SupabaseService.from('notifications').delete().eq('id', id);
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await SupabaseService.from(
      'notifications',
    ).select('id').eq('is_read', false);
    return (response as List).length;
  }
}
