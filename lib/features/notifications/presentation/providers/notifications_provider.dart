import 'package:flutter/material.dart';

class NotificationsProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Mobil Dikembalikan",
      "message": "Toyota Avanza B 1234 ABC telah dikembalikan.",
      "time": "09:30",
      "isRead": false,
    },
    {
      "title": "Servis Terjadwal",
      "message": "Honda Brio akan servis besok.",
      "time": "Kemarin",
      "isRead": true,
    },
    {
      "title": "Pembayaran Berhasil",
      "message": "Pembayaran transaksi #TRX001 berhasil.",
      "time": "2 hari lalu",
      "isRead": true,
    },
  ];

  List<Map<String, dynamic>> get notifications => _notifications;

  void markAsRead(int index) {
    _notifications[index]["isRead"] = true;
    notifyListeners();
  }

  void markAllAsRead() {
    for (final item in _notifications) {
      item["isRead"] = true;
    }

    notifyListeners();
  }
}
