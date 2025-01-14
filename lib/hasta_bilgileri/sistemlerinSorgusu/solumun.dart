import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:e_anamnez/navigation_Screens/sikayetlerim_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Solumun extends StatefulWidget {
  @override
  _SolumunPageState createState() => _SolumunPageState();
}

class _SolumunPageState extends State<Solumun> {
  final Map<String, bool> _symptoms = {
    'Öksürük  ': false,
    'Balgam ': false,
    'Ağır solunum yetmezliği  ': false,
    'Hapşırma ': false,
    'Nefes darlığı ': false,
    'Hırıltı solunum ': false,
    'Göğüs ağrısı  ': false,
  };

  Future<void> _updateUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .collection('sikayetlerim')
            .doc(DoctorInformation.sikayetId)
            .set(_symptoms, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Bilgiler başarıyla kaydedildi'),
              ],
            ),
            backgroundColor: Color.fromARGB(255, 33, 243, 173),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bilgiler güncellenemedi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildSymptomCard(String symptom) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: _symptoms[symptom] ?? false
            ? LinearGradient(
                colors: [
                  Colors.blueAccent,
                  Color.fromARGB(255, 33, 243, 173),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
        color: _symptoms[symptom] ?? false ? null : Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              _symptoms[symptom] = !(_symptoms[symptom] ?? false);
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _symptoms[symptom] ?? false
                          ? Colors.white
                          : Colors.grey.shade400,
                      width: 2,
                    ),
                    color: _symptoms[symptom] ?? false
                        ? Colors.white
                        : Colors.transparent,
                  ),
                  child: _symptoms[symptom] ?? false
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.blueAccent,
                        )
                      : null,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    symptom,
                    style: TextStyle(
                      fontSize: 16,
                      color: _symptoms[symptom] ?? false
                          ? Colors.white
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color.fromARGB(255, 33, 243, 173).withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Color.fromARGB(255, 33, 243, 173),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Hasta Solumun öykü',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: _symptoms.keys
                      .map((symptom) => _buildSymptomCard(symptom))
                      .toList(),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await _updateUserInfo();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return SikayetlerimPage(); // Kendi UserScreen'iniz burada
                    }),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent,
                        const Color.fromARGB(255, 104, 228, 109)
                      ], // Gradyan arka plan
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(25), // Yuvarlatılmış köşeler
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5), // Gölge rengi
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3), // Gölge konumu
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "KAYDET",
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 45, 62, 72), // Hafif koyu ton

                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
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
}
