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
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 64),
                        SizedBox(height: 10),
                        Text(
                          'Bir hata oluştu. Lütfen tekrar deneyin.',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 20),
                        Text(
                          'Henüz şikayet kaydı yok.',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Lütfen şikayet kaydınızı ekleyin.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final doc = snapshot.data!.docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final sikayetId = doc.id;

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        title: Text(
                          data['sikayet'] ?? 'Şikayet Yok',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                        trailing: Icon(Icons.arrow_forward_ios, size: 18),
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
                    );
                  },
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 20),
                  Text(
                    'Lütfen giriş yapınız.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
    );
  }
}
