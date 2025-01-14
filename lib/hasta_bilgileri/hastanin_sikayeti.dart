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
  final TextEditingController _hastaSikayetiController =
      TextEditingController();

  // Define gradient colors
  final List<Color> gradientColors = [
    Colors.blueAccent,
    const Color.fromARGB(255, 33, 243, 173),
  ];

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
          'sikayet': _hastaSikayetiController.text,
        }, SetOptions(merge: true));
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Güncelleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bilgiler güncellenemedi.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
            stops: const [0.1, 0.9],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    _buildHeader(),
                    SizedBox(height: 40),
                    _buildComplaintField(),
                    SizedBox(height: 40),
                    _buildSubmitButton(),
                    SizedBox(height: 250),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.medical_services,
            size: 35,
            color: gradientColors[0],
          ),
          SizedBox(width: 15),
          Text(
            'Hasta Şikayeti',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintField() {
    return _buildTextField(
      controller: _hastaSikayetiController,
      labelText: 'Şikayetiniz',
      hintText: 'Lütfen şikayetinizle ilgili detayları yazın',
      icon: Icons.healing,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 15),
            child: Row(
              children: [
                Icon(icon, color: gradientColors[0]),
                SizedBox(width: 10),
                Text(
                  labelText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.all(20),
              border: InputBorder.none,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş bırakılamaz';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: gradientColors[0],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 8,
          ),
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              await _updateUserInfo();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => BasBoyun(),
                ),
              );
            }
          },
          child: Text(
            'KAYDET',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
