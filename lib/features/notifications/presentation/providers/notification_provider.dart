import 'package:flutter/material.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository repository;

  NotificationProvider({required this.repository});

  List<NotificationEntity> _notifications = [];
  int _unreadCount = 0;
  bool _loading = false;
  String? _error;

  List<NotificationEntity> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> fetchNotifications([String role = 'admin']) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final all = await repository.fetchNotifications();
      final cleanRole = role.toLowerCase();

      if (cleanRole == 'admin') {
        _notifications = all;
      } else if (cleanRole == 'operator') {
        _notifications = all
            .where((n) => n.type == 'service' || n.type == 'service_completed')
            .toList();
      } else {
        _notifications = [];
      }
      _unreadCount = _notifications.where((n) => !n.isRead).length;
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    try {
      await repository.markAsRead(id);
      final index = _notifications.indexWhere((element) => element.id == id);
      if (index != -1) {
        final current = _notifications[index];
        if (!current.isRead) {
          _notifications[index] = NotificationEntity(
            id: current.id,
            title: current.title,
            message: current.message,
            type: current.type,
            referenceId: current.referenceId,
            isRead: true,
            createdAt: current.createdAt,
            actionUrl: current.actionUrl,
          );
          _unreadCount = (_unreadCount - 1).clamp(0, 99999999);
          notifyListeners();
        }
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await repository.markAllAsRead();
      _notifications =
          _notifications.map((current) {
            return NotificationEntity(
              id: current.id,
              title: current.title,
              message: current.message,
              type: current.type,
              referenceId: current.referenceId,
              isRead: true,
              createdAt: current.createdAt,
              actionUrl: current.actionUrl,
            );
          }).toList();
      _unreadCount = 0;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotification(String id) async {
    try {
      final index = _notifications.indexWhere((element) => element.id == id);
      if (index != -1) {
        final current = _notifications[index];
        await repository.deleteNotification(id);
        _notifications.removeAt(index);
        if (!current.isRead) {
          _unreadCount = (_unreadCount - 1).clamp(0, 99999999);
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> getUnreadCount([String role = 'admin']) async {
    try {
      final all = await repository.fetchNotifications();
      final cleanRole = role.toLowerCase();
      List<NotificationEntity> filtered = [];

      if (cleanRole == 'admin') {
        filtered = all;
      } else if (cleanRole == 'operator') {
        filtered = all
            .where((n) => n.type == 'service' || n.type == 'service_completed')
            .toList();
      }

      _unreadCount = filtered.where((n) => !n.isRead).length;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
