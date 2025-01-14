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
      backgroundColor:
          Color(0xFFF0F4F8), // Soft background color for modern look
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(
                    Icons.healing, // Sağlıkla ilgili bir ikon
                    size: 30, // İkon boyutunu ayarlayın
                    color: Colors.greenAccent, // Daha modern ikon rengi
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Hasta Şikayeti',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87, // Modern yazı rengi
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildTextField(
                controller: _hastaSikayetiController,
                labelText: 'şikayetinizle ilgili detayları yazın.',
                keyboardType: TextInputType.text,
                icon: Icons.medical_services,
              ),
              SizedBox(height: 30),
              _buildTextField(
                controller: _hastaOykusuController,
                labelText: 'Hasta öyküsü',
                keyboardType: TextInputType.text,
                icon: Icons.history_edu,
              ),
              SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Modern buton rengi
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5, // Butona gölge efekti
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

  Container _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required TextInputType keyboardType,
    required IconData icon,
  }) {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white, // Modern beyaz arka plan
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
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
            fontSize: 16,
            color: Colors.black54,
          ),
          prefixIcon: Icon(icon, color: Colors.greenAccent),
          filled: true,
          fillColor: Colors.white,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Bu alan boş olamaz';
          }
          return null;
        },
      ),
    );
  }
}
