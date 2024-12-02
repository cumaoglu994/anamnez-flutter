import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/Widget/custom_text.dart';
import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            Text(
              'welcome',
              style: TextStyle(fontSize: 28),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blueAccent,
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    hint: 'Search your Doctor',
                    textEditingController: null,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('doctor').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No doctors found'));
                  }

                  final doctorDocs = snapshot.data!.docs;

                  return GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      mainAxisExtent: 200,
                    ),
                    itemCount: doctorDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doctorData = doctorDocs[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorInformation(
                                  data:
                                      doctorData), // Detay sayfası için doktor verileri
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.greenAccent.withOpacity(0.3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 100,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                doctorData['name'] ?? 'Doctor Name',
                                style: TextStyle(fontSize: 20),
                              ),

                              Text(
                                doctorData['uzmanlik'] ?? 'uzmanlik Name',
                                style: TextStyle(fontSize: 16),
                              ), // database indexe göre değişecek
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
