import 'package:flutter/material.dart';

class SikayetDetayiPage extends StatelessWidget {
  final String sikayetId;
  final Map<String, dynamic> sikayetData;

  SikayetDetayiPage({required this.sikayetId, required this.sikayetData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şikayet Detayı'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Değerlendirme Sonucu Container
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.green[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Değerlendirme Sonucu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    ' sonuçlandırılmadı ', // Burada değerlendirme sonucunu gösterebilirsiniz.
                    style: TextStyle(fontSize: 16, color: Colors.green[800]),
                  ),
                ],
              ),
            ),

            // Şikayet Detayı Listesi
            Expanded(
              child: ListView(
                children: sikayetData.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Koşul ekleniyor: Eğer entry.key 'tarih' değilse göster
                        if (entry.key != 'tarih') ...[
                          Row(
                            children: [
                              Text(
                                '${entry.key} :', // Alan adı (field name)
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 5),
                              Text(
                                entry.value?.toString() ??
                                    'Bilgi Yok', // Alan değeri
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
