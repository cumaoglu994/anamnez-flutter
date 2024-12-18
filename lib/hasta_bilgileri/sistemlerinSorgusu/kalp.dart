import 'package:e_anamnez/Widget/checkbox_sorgusu.dart';
import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/kas.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Kalp extends StatefulWidget {
  @override
  _KalpPageState createState() => _KalpPageState();
}

class _KalpPageState extends State<Kalp> {
  bool _Gogusagrisi = false;
  bool _nefesDarligi = false;
  bool _Ortopne = false;
  bool _carpinti = false;
  bool _bacaklardaSislik = false;

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
          'Goğüs ağrısı': _Gogusagrisi, //Goğüs ağrısı
          'Nefes darlığı ': _nefesDarligi, //Nefes darlığı
          'Ortopne': _Ortopne, //Ortopne
          'Çarpıntı': _carpinti, //Çarpıntı
          'Bacaklarda şişlik': _bacaklardaSislik, //Bacaklarda şişlik
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
                SizedBox(width: 10),
                Icon(
                  Icons.health_and_safety,
                  size: 30,
                  color: Colors.red,
                ),
                SizedBox(width: 18),
                Text(
                  ' Kardiyovasküler\n sistem ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),
            // CustomCheckbox kullanımı
            CustomCheckbox(
              text: "Goğüs ağrısı",
              value: _Gogusagrisi,
              onChanged: (bool? value) {
                setState(() {
                  _Gogusagrisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Nefes darlığı",
              value: _nefesDarligi,
              onChanged: (bool? value) {
                setState(() {
                  _nefesDarligi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Ortopne",
              value: _Ortopne,
              onChanged: (bool? value) {
                setState(() {
                  _Ortopne = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Çarpıntı",
              value: _carpinti,
              onChanged: (bool? value) {
                setState(() {
                  _carpinti = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            CustomCheckbox(
              text: "Bacaklarda şişlik",
              value: _bacaklardaSislik,
              onChanged: (bool? value) {
                setState(() {
                  _bacaklardaSislik = value ?? false;
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
                    return Kas(); // Kendi UserScreen'iniz burada
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
