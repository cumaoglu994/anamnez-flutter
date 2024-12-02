import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      'title': 'Yeni Mesaj',
      'description': 'Sana yeni bir mesaj gönderildi.',
    },
    {
      'title': 'Randevu Hatırlatıcı',
      'description': 'Yarın randevunuz var.',
    },
    {
      'title': 'Yeni Güncelleme',
      'description': 'Uygulamanızda yeni bir güncelleme mevcut.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bildirimler'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(notifications[index]['title']!),
              subtitle: Text(notifications[index]['description']!),
              leading: Icon(Icons.notifications),
              onTap: () {
                // Bildirime tıklama olayları eklenebilir
              },
            ),
          );
        },
      ),
    );
  }
}
