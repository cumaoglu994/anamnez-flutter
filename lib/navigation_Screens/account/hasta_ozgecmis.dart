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
  bool _sigara = false; // Varsayılan değer false
  bool _alkol = false; // Varsayılan değer false
  final TextEditingController _hastalikController = TextEditingController();
  final TextEditingController _kulandigiIlacController =
      TextEditingController();
  final TextEditingController _operasyonController = TextEditingController();
  final TextEditingController _kanamaDiyateziController =
      TextEditingController();
  final TextEditingController _allerjiController = TextEditingController();

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
          _hastalikController.text = userData['hastalik'] ?? '';
          _kulandigiIlacController.text = userData['kullandigiIlac'] ?? '';
          _operasyonController.text = userData['operasyon'] ?? '';
          _kanamaDiyateziController.text = userData['kanamaDiyatezi'] ?? '';
          _allerjiController.text = userData['allerji'] ?? '';

          // Varsayılan değer ataması
          _alkol = userData['alkol'] ?? false;
          _sigara = userData['sigara'] ?? false;

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
          'hastalik': _hastalikController.text,
          'kullandigiIlac': _kulandigiIlacController.text,
          'operasyon': _operasyonController.text,
          'kanamaDiyatezi': _kanamaDiyateziController.text,
          'allerji': _allerjiController.text,
          'alkol': _alkol,
          'sigara': _sigara,
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
            Center(
              child: Text(
                'Hasta Özgeçmişi',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            textformu(
              controller: _hastalikController,
              labelText: 'Hastalik',
              keyboardType: TextInputType.text,
            ),
            textformu(
              controller: _kulandigiIlacController,
              labelText: 'Kullandigi Ilac',
              keyboardType: TextInputType.text,
            ),
            textformu(
              controller: _operasyonController,
              labelText: 'Operasyon',
              keyboardType: TextInputType.text,
            ),
            textformu(
              controller: _kanamaDiyateziController,
              labelText: 'Kanama Diyatezi',
              keyboardType: TextInputType.text,
            ),
            textformu(
              controller: _allerjiController,
              labelText: 'Allerji',
              keyboardType: TextInputType.text,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        "Alkol",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      value: _alkol,
                      onChanged: (bool? value) {
                        setState(() {
                          _alkol = value ?? false;
                        });
                      },
                      activeColor: Colors.blue, // Checkbox color when checked
                      controlAffinity: ListTileControlAffinity
                          .leading, // Checkbox on the left
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between checkboxes
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    child: CheckboxListTile(
                      title: Text(
                        "Sigara",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      value: _sigara,
                      onChanged: (bool? value) {
                        setState(() {
                          _sigara = value ?? false;
                        });
                      },
                      activeColor: Colors.blue, // Checkbox color when checked
                      controlAffinity: ListTileControlAffinity
                          .leading, // Checkbox on the left
                    ),
                  ),
                ),
              ],
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
      child: Column(
        children: [
          TextField(
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
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
