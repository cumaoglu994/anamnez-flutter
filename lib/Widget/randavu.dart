import 'package:flutter/material.dart';

class Randavularim extends StatelessWidget {
  const Randavularim({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Örnek veri
    List<Map<String, String>> randevular = [
      {
        'tarih': '2024-11-08',
        'saat': '10:30 AM',
        'durum': 'Onaylı',
      },
      {
        'tarih': '2024-11-09',
        'saat': '02:00 PM',
        'durum': 'Beklemede',
      },
      {
        'tarih': '2024-11-10',
        'saat': '11:00 AM',
        'durum': 'İptal Edildi',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Randevularım'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView.builder(
          itemCount: randevular.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(15),
                title: Text(
                  'Tarih: ${randevular[index]['tarih']}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saat: ${randevular[index]['saat']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Durum: ${randevular[index]['durum']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: randevular[index]['durum'] == 'Onaylı'
                            ? Colors.green
                            : randevular[index]['durum'] == 'Beklemede'
                                ? Colors.orange
                                : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
