import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:rental_mobil/core/network/supabase_service.dart';
import 'notification_service.dart';

class NotificationChecker {
  static Future<void> checkAndNotify() async {
    await checkRentalDueNotifications();
    await checkOverdueNotifications();
    await checkServiceNotifications();
    await checkServiceCompletedNotifications();
    await checkRentalCompletedNotifications();
  }

  static Future<void> check() async {
    await checkAndNotify();
  }

  static String formatCurrency(dynamic value) {
    if (value == null) return 'Rp 0';
    final numValue = num.tryParse(value.toString()) ?? 0;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(numValue);
  }

  static String getMessage(Map<String, dynamic> row, String type) {
    if (row['message'] != null) return row['message'].toString();
    if (row['body'] != null) return row['body'].toString();

    final pelanggan = row['nama_pelanggan'] ?? row['nama'] ?? 'Pelanggan';
    final mobil = row['nama_mobil'] ?? row['mobil'] ?? 'Mobil';
    final plat = row['plat_nomor'] ?? '';
    final platStr = plat.isNotEmpty ? '($plat)' : '';

    switch (type) {
      case 'rental_due':
        return '$pelanggan\n\n[WA]\n\n$mobil\n$platStr\n\nharus dikembalikan hari ini';
      case 'overdue_rental':
        final hari = row['hari_terlambat'] ?? row['terlambat'] ?? '0';
        return '$pelanggan\n\n[WA]\n\n$mobil\n$platStr\n\nterlambat $hari hari';
      case 'service':
        return '$mobil\n$platStr\n\nsedang menjalani servis';
      case 'service_completed':
        final biaya = row['biaya_servis'] ?? row['biaya'] ?? '0';
        return '$mobil\n$platStr\n\ntelah selesai menjalani servis\n\nBiaya Servis:\n${formatCurrency(biaya)}';
      case 'rental_completed':
        final denda = row['denda'] ?? '0';
        return '$pelanggan\n\ntelah mengembalikan\n\n$mobil\n$platStr\n\nDenda:\n${formatCurrency(denda)}';
      default:
        return '';
    }
  }

  static Future<void> checkNotificationsFromView({
    required String viewName,
    required String type,
    required String title,
  }) async {
    try {
      final response = await SupabaseService.from(viewName).select();
      final list = response as List;

      for (var row in list) {
        final referenceId = row['reference_id']?.toString() ?? row['id']?.toString() ?? '';
        if (referenceId.isEmpty) continue;

        // check notifications table
        final existing = await SupabaseService.from('notifications')
            .select('id')
            .eq('reference_id', referenceId)
            .eq('type', type)
            .maybeSingle();

        if (existing == null) {
          final noHp = row['no_hp']?.toString() ?? '';
          final cleanPhone = noHp.replaceAll(RegExp(r'\D'), '');
          
          String targetPhone = cleanPhone;
          if (cleanPhone.startsWith('0')) {
            targetPhone = '62${cleanPhone.substring(1)}';
          }

          final pelanggan = row['nama_pelanggan'] ?? row['nama'] ?? 'Pelanggan';
          final mobil = row['nama_mobil'] ?? row['mobil'] ?? 'Mobil';
          final plat = row['plat_nomor'] ?? '';
          final platStr = plat.isNotEmpty ? '($plat)' : '';

          String? actionUrl;
          if (type == 'rental_due') {
            final waMessage = 'Halo $pelanggan\n\nKami mengingatkan bahwa kendaraan\n\nMobil = $mobil\nPlat Nomor = $platStr\n\nharus dikembalikan hari ini.\n\nTerima Kasih.\nMulti RentCar';
            actionUrl = 'whatsapp://send?phone=$targetPhone&text=${Uri.encodeComponent(waMessage)}';
          } else if (type == 'overdue_rental') {
            final hari = row['hari_terlambat'] ?? row['terlambat'] ?? '0';
            final waMessage = 'Halo $pelanggan\n\nKendaraan\n\nMobil = $mobil\nPlat Nomor = $platStr\n\nterlambat dikembalikan selama\n\n$hari hari.\n\nMohon segera melakukan pengembalian.\n\nTerima Kasih.\nMulti RentCar';
            actionUrl = 'whatsapp://send?phone=$targetPhone&text=${Uri.encodeComponent(waMessage)}';
          }

          final message = getMessage(row, type);

          // insert into notifications table
          await SupabaseService.from('notifications').insert({
            'title': title,
            'message': message,
            'type': type,
            'reference_id': referenceId,
            'is_read': false,
            'action_url': actionUrl,
          });

          // show local notification
          final notificationId = '$referenceId-$type'.hashCode;
          await NotificationService.showNotification(
            id: notificationId,
            title: title,
            body: message,
          );
        }
      }
    } catch (e) {
      debugPrint('Error checking view $viewName: $e');
    }
  }

  static Future<void> checkRentalDueNotifications() async {
    await checkNotificationsFromView(
      viewName: 'notifikasi_rental',
      type: 'rental_due',
      title: 'Rental Jatuh Tempo',
    );
  }

  static Future<void> checkOverdueNotifications() async {
    await checkNotificationsFromView(
      viewName: 'notifikasi_terlambat',
      type: 'overdue_rental',
      title: 'Mobil Belum Kembali',
    );
  }

  static Future<void> checkServiceNotifications() async {
    await checkNotificationsFromView(
      viewName: 'notifikasi_servis',
      type: 'service',
      title: 'Jadwal Servis',
    );
  }

  static Future<void> checkServiceCompletedNotifications() async {
    await checkNotificationsFromView(
      viewName: 'notifikasi_servis_selesai',
      type: 'service_completed',
      title: 'Servis Selesai',
    );
  }

  static Future<void> checkRentalCompletedNotifications() async {
    await checkNotificationsFromView(
      viewName: 'notifikasi_pengembalian',
      type: 'rental_completed',
      title: 'Pengembalian Selesai',
    );
  }
}
