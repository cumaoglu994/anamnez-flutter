import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/hasta_bilgileri/hastanin_sikayeti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DoctorInformation extends StatelessWidget {
  static String? sikayetId; // Şikayet ID'sini saklamak için static değişken
  final Map<String, dynamic> data;

  DoctorInformation({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Doctor Information",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey[200],
                      child: Image.asset(
                        'assets/images/logo.png',
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['name'] ?? 'Doctor Name',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            data['uzmanlik'] ?? 'Specialty',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Email Address',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          data['mail'] ?? 'No Email Provided',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        trailing:
                            Icon(Icons.email, color: Colors.green, size: 30),
                      ),
                      Align(
                        alignment: Alignment(-0.9, 0),
                        child: Text(
                          'About',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data['ozgecmis'] ?? 'No Bio Available',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.9, 0),
                        child: Text(
                          'Address',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            data['address'] ?? 'No Address Available',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () async {
            try {
              // Mevcut kullanıcı kimliğini al
              final currentUser = FirebaseAuth.instance.currentUser;

              if (currentUser != null) {
                // Firestore'da 'sikayetlerim' koleksiyonuna yeni bir benzersiz kayıt ekle
                DocumentReference documentReference = await FirebaseFirestore
                    .instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .collection('sikayetlerim')
                    .add({
                  'tarih': DateTime.now(), // Örnek veri
                  'sikayet': 'Ön görüşme talebi', // Örnek veri
                  // Diğer alanlar burada belirtilebilir
                });

                // Oluşturulan belge ID'sini static değişkende sakla
                sikayetId = documentReference.id;

                // İşlem başarılı olduğunda mesaj göster ve ana sayfaya yönlendir
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Yeni şikayet kaydı oluşturuldu")),
                );
                // Yönlendirme işlemi   HastaninSikayeti

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HastaninSikayeti(
                            data: {},
                          )),
                ); // '/main' yönlendirme yapılacak ana sayfa rotası
              } else {
                // Kullanıcı giriş yapmamışsa hata mesajı göster
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Lütfen giriş yapınız")),
                );
              }
            } catch (e) {
              // Hata durumunda kullanıcıya mesaj göster
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Kayıt oluşturulurken hata oluştu")),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          ),
          child: Text(
            'Ön görüşme için kayıt oluştur',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
