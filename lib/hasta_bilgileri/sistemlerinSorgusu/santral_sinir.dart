import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/solumun.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SantralSinir extends StatefulWidget {
  @override
  _SantralSinirPageState createState() => _SantralSinirPageState();
}

class _SantralSinirPageState extends State<SantralSinir> {
  bool _Basagrisi = false;
  bool _BasDonmesi = false;
  bool _bayilma = false;
  bool _gorme = false;
  bool _ciftGorme = false; //   Çift Görme
  bool _duyma = false;
  bool _kas = false;
  bool _uyusluk = false; //  Uyuşukluk
  bool _yanma = false; //   Yanma, tıkanıklık
  bool _karincalanma = false; //  Geniz akıntısı, sinüzit
  bool _hafizaKaybi = false; //    Hafıza kaybı,

  @override
  void initState() {
    super.initState();
  }

  Future<void> _updateUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .collection('sikayetlerim')
            .doc(DoctorInformation.sikayetId)
            .set({
          'Başağrısı': _Basagrisi,
          'Baş dönmesi': _BasDonmesi,
          'Bayılma,': _bayilma,
          'Görme': _gorme,
          'Çift görme': _ciftGorme,
          'Duyma': _duyma,
          'Kas gūçsüzlüğü': _kas,
          'Uyuşukluk': _uyusluk,
          'Yanma': _yanma,
          'karıncalanma': _karincalanma,
          'Hafıza kaybı,': _hafizaKaybi,
        }, SetOptions(merge: true));

        // Bilgiler güncellendikten sonra UI'yi güncelle
        setState(() {});
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Güncelleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bilgiler güncellenemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sistemlerin Sorgusu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                ' Santral Sinir',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Checkbox'lar için bir liste oluşturuyoruz
            checkbox(
              "Başağrısı",
              _Basagrisi,
              (bool? value) {
                setState(() {
                  _Basagrisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Baş dönmesi",
              _BasDonmesi,
              (bool? value) {
                setState(() {
                  _BasDonmesi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Bayılma,",
              _bayilma,
              (bool? value) {
                setState(() {
                  _bayilma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Görme",
              _gorme,
              (bool? value) {
                setState(() {
                  _gorme = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Duyma",
              _duyma,
              (bool? value) {
                setState(() {
                  _duyma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Kas gūçsüzlüğü",
              _kas,
              (bool? value) {
                setState(() {
                  _kas = value ?? false;
                });
              },
            ),

            SizedBox(height: 10),
            checkbox(
              "Uyuşukluk",
              _uyusluk,
              (bool? value) {
                setState(() {
                  _uyusluk = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              " Çift görme",
              _ciftGorme,
              (bool? value) {
                setState(() {
                  _ciftGorme = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Yanma",
              _yanma,
              (bool? value) {
                setState(() {
                  _yanma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "karıncalanma",
              _karincalanma,
              (bool? value) {
                setState(() {
                  _karincalanma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Hafıza kaybı,",
              _hafizaKaybi,
              (bool? value) {
                setState(() {
                  _hafizaKaybi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),

            SizedBox(height: 20), // Butonun üstünde biraz boşluk
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Buton rengi
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              onPressed: () async {
                await _updateUserInfo();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return Solumun(); // Kendi UserScreen'iniz burada
                  }),
                );
              },
              child: Text('KAYDET'),
            ),
          ],
        ),
      ),
    );
  }

  Container checkbox(String text, bool value, Function(bool?) onChanged) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Gölge konumu
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue, // Checkbox işaretlendiğinde rengi
        controlAffinity: ListTileControlAffinity.leading, // Checkbox solda
      ),
    );
  }
}
