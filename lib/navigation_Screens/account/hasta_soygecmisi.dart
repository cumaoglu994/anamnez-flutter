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

  // Sağlık teması için renk paleti
  final Color primaryGreen = Color.fromARGB(169, 76, 175, 79);
  final Color secondaryGreen = Color.fromARGB(158, 129, 199, 132);
  final Color lightGreen = Color(0xFFE8F5E9);
  final Color darkGreen = Color(0xFF2E7D32);

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
          SnackBar(
            content: Text('Bilgiler başarıyla güncellendi'),
            backgroundColor: primaryGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bilgiler güncellenemedi.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [primaryGreen.withOpacity(0.1), Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        size: 48,
                        color: primaryGreen,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Aile Sağlık Geçmişi',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: darkGreen,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildFormField(
                        controller: _anneController,
                        labelText: 'Anne Sağlık Geçmişi',
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: 16),
                      _buildFormField(
                        controller: _babaController,
                        labelText: 'Baba Sağlık Geçmişi',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 16),
                      _buildFormField(
                        controller: _kardeslerController,
                        labelText: 'Kardeşler Sağlık Geçmişi',
                        icon: Icons.people_outline,
                      ),
                      SizedBox(height: 16),
                      _buildFormField(
                        controller: _cocuklerController,
                        labelText: 'Çocuklar Sağlık Geçmişi',
                        icon: Icons.child_care,
                      ),
                      SizedBox(height: 16),
                      _buildFormField(
                        controller: _aileController,
                        labelText: 'Ailedeki Hastalıklar',
                        icon: Icons.medical_services_outlined,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                onPressed: () async {
                  await _updateUserInfo();
                  Navigator.pop(context);
                },
                child: Text(
                  'KAYDET',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: darkGreen,
          fontSize: 16,
        ),
        prefixIcon: Icon(icon, color: secondaryGreen),
        filled: true,
        fillColor: lightGreen,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryGreen,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      style: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    );
  }
}
