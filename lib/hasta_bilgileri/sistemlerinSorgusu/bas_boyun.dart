import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/gastrointestinal.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BasBoyun extends StatefulWidget {
  @override
  _BasBoyunPageState createState() => _BasBoyunPageState();
}

class _BasBoyunPageState extends State<BasBoyun> {
  bool _Basagrisi = false;
  bool _BasDonmesi = false;
  bool _isitme = false;
  bool _KulakCinlamasi = false;
  bool _KulakAkintisi = false;
  bool _KulakAgirisi = false;
  bool _GormeBozuklugu =
      false; //     Görme bozukluğu // _GormeBozuklugu   _Fotofobi    _ciftGorme
  bool _Fotofobi = false; //  Fotofobi
  bool _ciftGorme = false; //   Çift görme
  bool _burunAkintisisi = false; //   Burun akıntısı, tıkanıklık
  bool _burunTikaniklik = false; //  Geniz akıntısı, sinüzit
  bool _sesKisikligi = false; //    Ses kısıklığı
  bool _dildeYara = false; // dilde yara
  bool _Lenfadenopati = false; //     Lenfadenopati
  bool _guatr = false; //     Guatr

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
          'Işitme': _isitme,
          'Kulak çınlaması': _KulakCinlamasi,
          'Kulak akıntısı': _KulakAkintisi,
          'Kulak ağrısı': _KulakAgirisi,
          'Görme bozukluğu': _GormeBozuklugu,
          'Fotofobi': _Fotofobi,
          'Çift görme': _ciftGorme,
          'Burun akıntısı': _burunAkintisisi,
          'Burun tıkanıklık': _burunTikaniklik,
          'Ses kısıklığı': _sesKisikligi,
          'dilde yara': _dildeYara,
          'Lenfadenopati': _Lenfadenopati,
          'Guatr': _guatr,
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
                'Baş Boyun',
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
              "Işitme",
              _isitme,
              (bool? value) {
                setState(() {
                  _isitme = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Kulak çınlaması",
              _KulakCinlamasi,
              (bool? value) {
                setState(() {
                  _KulakCinlamasi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Kulak akıntısı",
              _KulakAkintisi,
              (bool? value) {
                setState(() {
                  _KulakAkintisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Kulak ağrısı",
              _KulakAgirisi,
              (bool? value) {
                setState(() {
                  _KulakAgirisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Görme bozukluğu",
              _GormeBozuklugu,
              (bool? value) {
                setState(() {
                  _GormeBozuklugu = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Fotofobi",
              _Fotofobi,
              (bool? value) {
                setState(() {
                  _Fotofobi = value ?? false;
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
              "Burun akıntısı",
              _burunAkintisisi,
              (bool? value) {
                setState(() {
                  _burunAkintisisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Burun tıkanıklık",
              _burunTikaniklik,
              (bool? value) {
                setState(() {
                  _burunTikaniklik = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Ses kısıklığı",
              _sesKisikligi,
              (bool? value) {
                setState(() {
                  _sesKisikligi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "dilde yara",
              _dildeYara,
              (bool? value) {
                setState(() {
                  _dildeYara = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Lenfadenopati",
              _Lenfadenopati,
              (bool? value) {
                setState(() {
                  _Lenfadenopati = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Guatr",
              _guatr,
              (bool? value) {
                setState(() {
                  _guatr = value ?? false;
                });
              },
            ),
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
                    return Gastrointestinal(); // Kendi UserScreen'iniz burada
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
      margin: EdgeInsets.symmetric(vertical: 4.0), // Dikey boşluk
      padding: EdgeInsets.symmetric(horizontal: 8.0), // İçerik etrafında boşluk
      decoration: BoxDecoration(
        color: Colors.grey[200], // Arka plan rengi
        borderRadius: BorderRadius.circular(8), // Yuvarlatılmış köşeler
        border: Border.all(
            color: Colors.grey, width: 1), // Çerçeve rengi ve kalınlığı
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2), // Hafif gölge
          ),
        ],
      ),
      child: CheckboxListTile(
        contentPadding:
            EdgeInsets.symmetric(horizontal: 0.0), // Boşluk kaldırıldı
        title: Text(
          text,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w500), // Yazı boyutu 14
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blue, // Checkbox işaretlendiğinde rengi
        controlAffinity: ListTileControlAffinity.leading, // Checkbox solda
      ),
    );
  }
}
