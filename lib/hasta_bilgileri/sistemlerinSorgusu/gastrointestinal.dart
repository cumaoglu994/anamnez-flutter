import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/gilt.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Gastrointestinal extends StatefulWidget {
  @override
  _GastrointestinalPageState createState() => _GastrointestinalPageState();
}

class _GastrointestinalPageState extends State<Gastrointestinal> {
  bool _kiloKaybi = false;
  bool _diefaji = false;
  bool _bulanti = false;
  bool _kusma = false;
  bool _hematenmez = false;
  bool _hazimsizlik = false;
  bool _pirozis = false;
  bool _karinAgrisi = false;
  bool _sarilik = false; //  Karın ağrısı

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
          'İştaheızlık ve kilo kaybi': _kiloKaybi,
          'Diefaji': _diefaji,
          'Bulantı': _bulanti,
          'kusma': _kusma,
          'hematenmez': _hematenmez,
          'Hazımsızlık': _hazimsizlik,
          'pirozis': _pirozis,
          'Karın ağrısı': _karinAgrisi,
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
        title: Text('Sistemlerin Sorgusu '),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Gastrointestinal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Checkbox'lar için bir liste oluşturuyoruz
            checkbox(
              "İştaheızlık ve kilo kaybi",
              _kiloKaybi,
              (bool? value) {
                setState(() {
                  _kiloKaybi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Diefaji",
              _diefaji,
              (bool? value) {
                setState(() {
                  _diefaji = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Bulantı",
              _bulanti,
              (bool? value) {
                setState(() {
                  _bulanti = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "kusma",
              _kusma,
              (bool? value) {
                setState(() {
                  _kusma = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "hematenmez",
              _hematenmez,
              (bool? value) {
                setState(() {
                  _hematenmez = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Hazımsızlık",
              _hazimsizlik,
              (bool? value) {
                setState(() {
                  _hazimsizlik = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "pirozis",
              _pirozis,
              (bool? value) {
                setState(() {
                  _pirozis = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              "Karın ağrısı",
              _karinAgrisi,
              (bool? value) {
                setState(() {
                  _karinAgrisi = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),
            checkbox(
              " Sarılık",
              _sarilik,
              (bool? value) {
                setState(() {
                  _sarilik = value ?? false;
                });
              },
            ),
            SizedBox(height: 10),

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
                    return Gilt(); // Kendi UserScreen'iniz burada
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
