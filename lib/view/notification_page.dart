import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    notifications = _dummyNotifications.map((e) => NotificationItem.fromMap(e)).toList();
  }

  void _markAsRead(int index) {
    setState(() {
      notifications[index].isRead = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B3358)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF1B3358),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return _buildNotificationCard(
            context: context,
            notification: notification,
            index: index,
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard({
    required BuildContext context,
    required NotificationItem notification,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        _markAsRead(index);
        _showNotificationDetail(context, notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : const Color(0xFFF5F8FF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      notification.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.bold,
                        color: const Color(0xFF1B3358),
                      ),
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFC107),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                notification.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotificationDetail(BuildContext context, NotificationItem notification) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B3358),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification.detailMessage ?? notification.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            if (notification.actionButton != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Implementasi aksi sesuai dengan jenis notifikasi
                    if (notification.actionButton!.contains('Lihat Reservasi')) {
                      Navigator.pushNamed(context, '/reservation');
                    } else if (notification.actionButton!.contains('Lihat Promo')) {
                      // Navigate to promo page
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B5585),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    notification.actionButton!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  final String? detailMessage;
  final String time;
  bool isRead;
  final String? actionButton;

  NotificationItem({
    required this.title,
    required this.message,
    this.detailMessage,
    required this.time,
    required this.isRead,
    this.actionButton,
  });

  factory NotificationItem.fromMap(Map<String, dynamic> map) {
    return NotificationItem(
      title: map['title'],
      message: map['message'],
      detailMessage: map['detailMessage'],
      time: map['time'],
      isRead: map['isRead'],
      actionButton: map['actionButton'],
    );
  }
}

final List<Map<String, dynamic>> _dummyNotifications = [
  {
    'title': 'Reservasi Berhasil',
    'message': 'Reservasi anda untuk haircut pada tanggal 21 November 2024 telah dikonfirmasi.',
    'detailMessage': 'Reservasi anda untuk layanan haircut pada tanggal 21 November 2024 pukul 14:00 WIB telah dikonfirmasi.\n\nDetail Reservasi:\n- Layanan: Haircut\n- Tanggal: 21 November 2024\n- Waktu: 14:00 WIB\n- Durasi: 1 jam\n- Barber: John Doe',
    'time': '2 menit yang lalu',
    'isRead': false,
    'actionButton': 'Lihat Reservasi',
  },
  {
    'title': 'Promo Spesial!',
    'message': 'Dapatkan diskon 20% untuk semua layanan pada hari Senin-Jumat.',
    'detailMessage': 'Spesial untuk Anda! Dapatkan diskon 20% untuk semua layanan pada hari Senin-Jumat.\n\nSyarat dan Ketentuan:\n- Berlaku untuk semua jenis layanan\n- Periode promo: 1-30 November 2024\n- Tidak dapat digabung dengan promo lain\n- Berlaku di semua cabang',
    'time': '1 jam yang lalu',
    'isRead': false,
    'actionButton': 'Lihat Promo',
  },
  {
    'title': 'Top Up Berhasil',
    'message': 'Top up saldo sebesar Rp 100.000 telah berhasil.',
    'detailMessage': 'Top up saldo sebesar Rp 100.000 telah berhasil.\n\nDetail Transaksi:\n- ID Transaksi: TU123456\n- Metode: Virtual Account BCA\n- Waktu: 20 November 2024, 10:30 WIB\n- Status: Berhasil',
    'time': '3 jam yang lalu',
    'isRead': true,
    'actionButton': null,
  },
  {
    'title': 'Pengingat Reservasi',
    'message': 'Jangan lupa reservasi anda besok pukul 14:00 WIB.',
    'time': '5 jam yang lalu',
    'isRead': true,
    'actionButton': 'Lihat Reservasi',
  },
  {
    'title': 'Point Reward',
    'message': 'Selamat! Anda mendapatkan 50 point dari transaksi terakhir.',
    'detailMessage': 'Selamat! Anda mendapatkan 50 point dari transaksi terakhir Anda.\n\nDetail Point:\n- Point yang didapat: 50\n- Total point: 150\n- Transaksi: Haircut + Beard Trim\n- Tanggal: 19 November 2024',
    'time': '1 hari yang lalu',
    'isRead': true,
    'actionButton': null,
  },
];