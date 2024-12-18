import 'package:e_anamnez/Widget/checkbox_sorgusu.dart';
import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/solumun.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kas extends StatefulWidget {
  @override
  _KasPageState createState() => _KasPageState();
}

class _KasPageState extends State<Kas> {
  bool _kasAgrisi = false;
  bool _sislik = false;
  bool _tutulma = false;
  bool _kisitlilik = false;
  bool _kasGucu = false;

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
          'Ağrı': _kasAgrisi,
          'şişliki': _sislik,
          'tutulma': _tutulma,
          'kısıtlılık': _kisitlilik,
          'Kas gücū': _kasGucu,
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
                  Icons.directions_run,
                  size: 30,
                  color: Colors.blue,
                ),
                SizedBox(width: 8),
                Text(
                  'Kas iskelet sistemi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // CustomCheckbox'lar için bir liste oluşturuyoruz
            CustomCheckbox(
              text: " Kas Ağrısı",
              value: _kasAgrisi,
              onChanged: (bool? value) {
                setState(() {
                  _kasAgrisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Şişlik",
              value: _sislik,
              onChanged: (bool? value) {
                setState(() {
                  _sislik = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Kas Tutulma",
              value: _tutulma,
              onChanged: (bool? value) {
                setState(() {
                  _tutulma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Kısıtlılık",
              value: _kisitlilik,
              onChanged: (bool? value) {
                setState(() {
                  _kisitlilik = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Kas Gücü",
              value: _kasGucu,
              onChanged: (bool? value) {
                setState(() {
                  _kasGucu = value ?? false;
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
