import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HastaSoygecmisi extends StatefulWidget {
  final Map<String, dynamic> data;

  HastaSoygecmisi({required this.data});

  @override
  _HastaSoygecmisiPageState createState() => _HastaSoygecmisiPageState();
}

class _HastaSoygecmisiPageState extends State<HastaSoygecmisi> {
  final TextEditingController _anneController = TextEditingController();
  final TextEditingController _babaController = TextEditingController();
  final TextEditingController _kardeslerController = TextEditingController();
  final TextEditingController _cocuklerController = TextEditingController();
  final TextEditingController _aileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          _anneController.text = userData['anne'] ?? '';
          _babaController.text = userData['baba'] ?? '';
          _kardeslerController.text = userData['kardesler'] ?? '';
          _cocuklerController.text = userData['cocukler'] ?? '';
          _aileController.text = userData['aile'] ?? '';

          setState(() {});
        }
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Kullanıcı bilgileri çekilirken hata: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .set({
          'anne': _anneController.text,
          'baba': _babaController.text,
          'kardesler': _kardeslerController.text,
          'cocukler': _cocuklerController.text,
          'aile': _aileController.text,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bilgiler başarıyla güncellendi')),
        );
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
        title: Text('Hesabım'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                'Hasta Soygeçmişi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 16),
            textformu(
              controller: _anneController,
              labelText: 'Anne',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            textformu(
              controller: _babaController,
              labelText: 'Baba',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            textformu(
              controller: _kardeslerController,
              labelText: 'kardesler',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            textformu(
              controller: _cocuklerController,
              labelText: 'cocukler',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 16),
            textformu(
              controller: _aileController,
              labelText: 'ailedeki hastaliklar',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              onPressed: () async {
                await _updateUserInfo();
                Navigator.pop(
                    context); // Güncelleme sonrası mevcut sayfayı kapatır ve önceki ekrana döner
              },
              child: Text('KAYDET'),
            ),
          ],
        ),
      ),
    );
  }

  Container textformu({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
  }) {
    return Container(
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue,
              width: 2,
            ),
          ),
          prefixIcon: Icon(Icons.person, color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}
