import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/navigation_Screens/sikayetlerim_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Solumun extends StatefulWidget {
  @override
  _SolumunPageState createState() => _SolumunPageState();
}

class _SolumunPageState extends State<Solumun> {
  bool _goguzAgrisi = false;
  bool _nefesDarligi = false;
  bool _oksuruk = false;
  bool _balgam = false;
  bool _hemoptizi = false;

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
          'Göğüs ağrısı': _goguzAgrisi,
          'Nefes darlığı': _nefesDarligi,
          'Öksürük': _oksuruk,
          'Balgam': _balgam,
          'Hemoptizi': _hemoptizi,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.air,
                  size: 30,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'Solunum sistemi ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            // Checkbox'lar için bir liste oluşturuyoruz
            checkbox(
              "Göğüs ağrısı",
              _goguzAgrisi,
              (bool? value) {
                setState(() {
                  _goguzAgrisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Nefes darlığı",
              _nefesDarligi,
              (bool? value) {
                setState(() {
                  _nefesDarligi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Öksürük",
              _oksuruk,
              (bool? value) {
                setState(() {
                  _oksuruk = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Balgam",
              _balgam,
              (bool? value) {
                setState(() {
                  _balgam = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Hemoptizi",
              _hemoptizi,
              (bool? value) {
                setState(() {
                  _hemoptizi = value ?? false;
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
                    return SikayetlerimPage(); // Kendi UserScreen'iniz burada
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
