import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/bas_boyun.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/gastrointestinal.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/gilt.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/kalp.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/kas.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/santral_sinir.dart';
import 'package:e_anamnez/hasta_bilgileri/sistemlerinSorgusu/solumun.dart';
import 'package:e_anamnez/main_srceen.dart';
import 'package:flutter/material.dart';

class SistemlerinSorgusu extends StatefulWidget {
  @override
  _SistemlerinSorgusuPageState createState() => _SistemlerinSorgusuPageState();
}

class _SistemlerinSorgusuPageState extends State<SistemlerinSorgusu> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Sistemlerin Sorgusu',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.face, size: 30, color: Colors.blueGrey),
              title: const Text('Baş ve Boyun', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Baş ve boyun sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BasBoyun(data: {})),
                ).then((_) {
                  // Ana ekrana döndüğünde yapılacak işlemler
                  setState(() {}); // Ekranı yenilemek için
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, size: 30, color: Colors.red),
              title: const Text('Kalp Damar Sistemi',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // Kalp damar sistemi sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kalp(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.air, size: 30),
              title:
                  const Text('Solunum Sistemi', style: TextStyle(fontSize: 18)),
              onTap: () {
                // Solunum sistemi sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Solumun(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_dining, size: 30),
              title: const Text('Gastrointestinal Sistemi',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // Gastrointestinal sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Gastrointestinal(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology, size: 30),
              title: const Text('Santral Sinir Sistemi',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // UserInformation sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SantralSinir(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, size: 30),
              title: const Text('Kas ve iskelet sistemi',
                  style: TextStyle(fontSize: 18)),
              onTap: () {
                // UserInformation sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Kas(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.spa, size: 30),
              title: const Text('Cilt', style: TextStyle(fontSize: 18)),
              onTap: () {
                // UserInformation sayfasına yönlendirme
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Gilt(data: {})),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Buton rengi
                padding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              onPressed: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MainScreen();
                  }),
                );
              },
              child: Text('KAYDET'),
            ),
          ],
        ),
      ),
    );
  }
}
