import 'package:flutter/material.dart';

class SikayetDetayiPage extends StatelessWidget {
  final String sikayetId;
  final Map<String, dynamic> sikayetData;

  SikayetDetayiPage({required this.sikayetId, required this.sikayetData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayet Detayı',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Değerlendirme Sonucu Container
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Değerlendirme Sonucu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    Text(
                      'Sonuçlandırılmadı', // Burada değerlendirme sonucunu gösterebilirsiniz.
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Şikayet Detayı Listesi
            Expanded(
              child: ListView(
                children: sikayetData.entries.map((entry) {
                  // Koşul ekleniyor: Eğer entry.key 'tarih' değilse göster
                  if (entry.key != 'tarih') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 15),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    '${entry.key}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green[700],
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    entry.value?.toString() ?? 'Bilgi Yok',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return SizedBox(); // Tarih alanını göstermiyoruz
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
