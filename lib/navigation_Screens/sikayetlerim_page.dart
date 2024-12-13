import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/Widget/sikayet_detayi_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SikayetlerimPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayetlerim',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 4,
      ),
      body: currentUser != null
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('hasta')
                  .doc(currentUser.uid)
                  .collection('sikayetlerim')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Bir hata oluştu.'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Henüz şikayet kaydı yok. Lütfen şikayet kaydınızı ekleyin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String sikayetId = doc.id; // Şikayet ID'si

                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            data['sikayet'] ?? 'Şikayet Yok',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            data['tarih']?.toDate() != null
                                ? DateFormat('dd/MM/yyyy HH:mm')
                                    .format(data['tarih']?.toDate())
                                : 'Tarih Yok',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SikayetDetayiPage(
                                  sikayetId: sikayetId,
                                  sikayetData: data,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Lütfen giriş yapınız.',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ),
            ),
    );
  }
}
