import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HastaOzgecmis extends StatefulWidget {
  final Map<String, dynamic> data;

  HastaOzgecmis({required this.data});

  @override
  _HastaOzgecmisPageState createState() => _HastaOzgecmisPageState();
}

class _HastaOzgecmisPageState extends State<HastaOzgecmis> {
  bool _sigara = false;
  bool _alkol = false;
  final TextEditingController _hastalikController = TextEditingController();
  final TextEditingController _kulandigiIlacController =
      TextEditingController();
  final TextEditingController _operasyonController = TextEditingController();
  final TextEditingController _kanamaDiyateziController =
      TextEditingController();
  final TextEditingController _allerjiController = TextEditingController();
  // Sağlık teması için renk paleti
  final Color primaryGreen = Color.fromARGB(169, 76, 175, 79);
  final Color secondaryGreen = Color.fromARGB(158, 129, 199, 132);
  final gradient = LinearGradient(
    colors: [
      const Color.fromARGB(105, 76, 175, 79),
      Colors.green,
    ],
  );

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
          setState(() {
            _hastalikController.text = userData['hastalik'] ?? '';
            _kulandigiIlacController.text = userData['kullandigiIlac'] ?? '';
            _operasyonController.text = userData['operasyon'] ?? '';
            _kanamaDiyateziController.text = userData['kanamaDiyatezi'] ?? '';
            _allerjiController.text = userData['allerji'] ?? '';
            _alkol = userData['alkol'] ?? false;
            _sigara = userData['sigara'] ?? false;
          });
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
          'hastalik': _hastalikController.text,
          'kullandigiIlac': _kulandigiIlacController.text,
          'operasyon': _operasyonController.text,
          'kanamaDiyatezi': _kanamaDiyateziController.text,
          'allerji': _allerjiController.text,
          'alkol': _alkol,
          'sigara': _sigara,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bilgiler başarıyla güncellendi'),
            backgroundColor: Colors.blueAccent,
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
            colors: [
              const Color.fromARGB(255, 68, 255, 183).withOpacity(0.1),
              const Color.fromARGB(255, 33, 243, 173).withOpacity(0.1),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person,
                        size: 48,
                        color: primaryGreen,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'özgeçmişine ait bilgiler  ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 20),
              ...[
                'Hastalik',
                'Kullandigi Ilac',
                'Operasyon',
                'Kanama Diyatezi',
                'Allerji'
              ]
                  .map((label) => _buildTextField(
                        controller: {
                          'Hastalik': _hastalikController,
                          'Kullandigi Ilac': _kulandigiIlacController,
                          'Operasyon': _operasyonController,
                          'Kanama Diyatezi': _kanamaDiyateziController,
                          'Allerji': _allerjiController,
                        }[label]!,
                        label: label,
                      ))
                  .toList(),
              Row(
                children: [
                  Expanded(
                      child: _buildCheckbox('Alkol', _alkol,
                          (val) => setState(() => _alkol = val ?? false))),
                  SizedBox(width: 16),
                  Expanded(
                      child: _buildCheckbox('Sigara', _sigara,
                          (val) => setState(() => _sigara = val ?? false))),
                ],
              ),
              SizedBox(height: 15),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.medical_information,
            color: primaryGreen,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
        checkColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
