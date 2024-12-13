import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/Widget/doctor_information.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(225, 19, 220, 123),
        title: Row(
          children: [
            Icon(
              Icons.local_hospital,
              color: Colors.white,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Welcome',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: const Color.fromARGB(225, 19, 220, 123),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search your Doctor',
                      hintStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: _searchQuery.isEmpty
                    ? FirebaseFirestore.instance
                        .collection('doctor')
                        .orderBy('name')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('doctor')
                        .where('name', isGreaterThanOrEqualTo: _searchQuery)
                        .where('name', isLessThan: _searchQuery + '\uf8ff')
                        .snapshots(),
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
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      mainAxisExtent: 220,
                    ),
                    itemCount: doctorDocs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doctorData = doctorDocs[index].data();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DoctorInformation(data: doctorData),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.grey[200],
                                backgroundImage: AssetImage(
                                  doctorData['gender'] == "erkek"
                                      ? 'assets/images/male.jpg'
                                      : 'assets/images/female.jpg',
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                doctorData['name'] ?? 'Doctor Name',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2),
                              Text(
                                doctorData['uzmanlik'] ?? 'Specialization',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
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
