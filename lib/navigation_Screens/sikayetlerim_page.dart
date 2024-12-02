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
        title: Text('Şikayetlerim'),
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
                  return Center(child: Text('Henüz şikayet kaydı yok.'));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    String sikayetId = doc.id; // Şikayet ID'si

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical:
                                8.0), // Liste öğeleri arasına boşluk ekler
                        padding: EdgeInsets.all(
                            12.0), // Container içine boşluk ekler
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // Arka plan rengini beyaz yapıyoruz
                          borderRadius:
                              BorderRadius.circular(12.0), // Köşe yuvarlama
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.2), // Hafif bir gölge ekler
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: Offset(0,
                                  4), // Gölgeyi biraz sağa ve aşağıya kaydırıyoruz
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets
                              .zero, // Varsayılan padding'i sıfırlıyoruz
                          title: Text(
                            data['sikayet'] ?? 'Şikayet Yok',
                            style: TextStyle(
                              fontSize: 18, // Başlık boyutunu ayarlıyoruz
                              fontWeight:
                                  FontWeight.bold, // Başlığı kalın yapıyoruz
                              color: Colors
                                  .black, // Başlık rengini siyah yapıyoruz
                            ),
                          ),
                          subtitle: Text(
                            data['tarih']?.toDate() != null
                                ? DateFormat('dd/MM/yyyy HH:mm')
                                    .format(data['tarih']?.toDate())
                                : 'Tarih Yok',
                            style: TextStyle(
                              fontSize: 14, // Alt başlık boyutunu ayarlıyoruz
                              color: Colors
                                  .grey, // Alt başlık rengini gri yapıyoruz
                            ),
                          ),
                          onTap: () {
                            // Tıklanılan şikayetin ID'si ve verilerini yeni sayfaya gönder
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
          : Center(child: Text('Lütfen giriş yapınız')),
    );
  }
}
