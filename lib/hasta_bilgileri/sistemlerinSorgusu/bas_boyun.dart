import 'package:e_anamnez/Widget/checkbox_sorgusu.dart';
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
                child: Row(
              children: [
                Icon(
                  Icons.accessibility, // Baş ve boyunla ilgili bir ikon
                  size: 30, // İkon boyutunu ayarlayın
                  color: Colors.blue, // İkon rengini ayarlayın
                ),
                SizedBox(width: 8), // İkon ile metin arasında boşluk
                Text(
                  'Baş Boyun',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            )),
            SizedBox(height: 16),
            // Checkbox'lar için CustomCheckbox sınıfını kullanıyoruz
            Row(
              children: [
                Flexible(
                  child: CustomCheckbox(
                    text: "Baş ağrısı",
                    value: _Basagrisi,
                    onChanged: (bool? value) {
                      setState(() {
                        _Basagrisi = value ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: CustomCheckbox(
                    text: "Baş dönmesi",
                    value: _BasDonmesi,
                    onChanged: (bool? value) {
                      setState(() {
                        _BasDonmesi = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            CustomCheckbox(
              text: "Kulak ağrısı",
              value: _KulakAgirisi,
              onChanged: (bool? value) {
                setState(() {
                  _KulakAgirisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Flexible(
                  child: CustomCheckbox(
                    text: "Kulak çınlaması",
                    value: _KulakCinlamasi,
                    onChanged: (bool? value) {
                      setState(() {
                        _KulakCinlamasi = value ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: CustomCheckbox(
                    text: "Kulak akıntısı",
                    value: _KulakAkintisi,
                    onChanged: (bool? value) {
                      setState(() {
                        _KulakAkintisi = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            CustomCheckbox(
              text: "Görme bozukluğu",
              value: _GormeBozuklugu,
              onChanged: (bool? value) {
                setState(() {
                  _GormeBozuklugu = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Flexible(
                  child: CustomCheckbox(
                    text: "Fotofobi",
                    value: _Fotofobi,
                    onChanged: (bool? value) {
                      setState(() {
                        _Fotofobi = value ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 15),
                Flexible(
                  child: CustomCheckbox(
                    text: "Çift görme",
                    value: _ciftGorme,
                    onChanged: (bool? value) {
                      setState(() {
                        _ciftGorme = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Ses kısıklığı",
              value: _sesKisikligi,
              onChanged: (bool? value) {
                setState(() {
                  _sesKisikligi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),

            CustomCheckbox(
              text: "Lenfadenopati",
              value: _Lenfadenopati,
              onChanged: (bool? value) {
                setState(() {
                  _Lenfadenopati = value ?? false;
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
}
