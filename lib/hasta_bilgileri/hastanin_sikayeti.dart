import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/bas_boyun.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HastaninSikayeti extends StatefulWidget {
  final Map<String, dynamic> data;

  HastaninSikayeti({required this.data});

  @override
  _HastaninSikayetiPageState createState() => _HastaninSikayetiPageState();
}

class _HastaninSikayetiPageState extends State<HastaninSikayeti> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hastaOykusuController = TextEditingController();
  final TextEditingController _hastaSikayetiController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    // Eğer veritabanında varsa, bu verileri controller'lara set et
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .collection('sikayetlerim')
            .doc(DoctorInformation.sikayetId)
            .get();

        if (snapshot.exists) {
          setState(() {
            _hastaOykusuController.text = snapshot['oykusu'] ?? '';
            _hastaSikayetiController.text = snapshot['sikayet'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Veri yükleme hatası: $e");
    }
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
          'tarih': DateTime.now(),
          'oykusu': _hastaOykusuController.text,
          'sikayet': _hastaSikayetiController.text,
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Hasta sikayeti',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              textformu(
                controller: _hastaSikayetiController,
                labelText: 'Hasta şikayeti',
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              Container(
                child: Container(
                  height: 175,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: _hastaOykusuController,
                    decoration: InputDecoration(
                      labelText: 'Hasta öyküsü',
                      labelStyle: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[800],
                      ),
                      filled: false,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(Icons.person, color: Colors.grey),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Bu alan boş olamaz';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Buton rengi
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      await _updateUserInfo();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return BasBoyun();
                          },
                        ),
                      );
                    }
                  },
                  child: Text(
                    'KAYDET',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
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
      child: Form(
        key: _formKey,
        child: Container(
          height: 175,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
              ),
              filled: false,
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              prefixIcon: Icon(Icons.person, color: Colors.grey),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş olamaz';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}
