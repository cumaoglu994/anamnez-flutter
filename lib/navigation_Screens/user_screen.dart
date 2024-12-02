import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_anamnez/auth/login_screen.dart';
import 'package:e_anamnez/navigation_Screens/account/hasta_ozgecmis.dart';
import 'package:e_anamnez/navigation_Screens/account/hasta_soygecmisi.dart';
import 'package:e_anamnez/navigation_Screens/account/user_information.dart';
import 'package:e_anamnez/main_srceen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı kimliğini al
    User? currentUser = FirebaseAuth.instance.currentUser;
    // Firestore'dan alıcı koleksiyonunu al
    CollectionReference hasta = FirebaseFirestore.instance.collection('hasta');

    // Eğer kullanıcı giriş yapmamışsa, kullanıcı giriş ekranına yönlendir
    if (currentUser == null) {
      return const KullanciYok();
    }

    // Kullanıcı verilerini al
    return FutureBuilder<DocumentSnapshot>(
      future: hasta.doc(currentUser.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Center(child: Text("Bir şeyler yanlış gitti.")),
                ListTile(
                  leading: const Icon(Icons.logout, size: 30),
                  title:
                      const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Başarıyla çıkış yapıldı!')),
                        // burada ise hemen KullanciYok() wedget gostersin
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    } catch (e) {
                      /*  ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Çıkış yaparken hata oluştu: $e')),
                        );*/
                    }
                  },
                ),
              ],
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const KullanciYok(); //const Center(child: Text("Kullanıcı verisi bulunamadı."));
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        // Kullanıcı profil ekranı
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Profil',
              style: TextStyle(
                letterSpacing: 4,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            actions: const [
              Padding(
                padding: EdgeInsets.all(18.0),
                child: Icon(Icons.dark_mode),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const SizedBox(height: 16), // Görsel ve metin arasında boşluk
                Center(
                  child: Text(
                    data['name'] ?? 'Anonim Kullanıcı',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(
                    thickness: 2,
                    color: Colors.black45,
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.medical_services, size: 30),
                  title: const Text('kişisel bilgiler',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // UserInformation sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInformation()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, size: 30),
                  title: const Text('Hasta Özgeçmişi',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // UserInformation sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HastaOzgecmis(data: data)),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.family_restroom_rounded, size: 30),
                  title: const Text('Hasta Soygeçmişi',
                      style: TextStyle(fontSize: 18)),
                  onTap: () {
                    // UserInformation sayfasına yönlendirme
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HastaSoygecmisi(data: data)),
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.logout, size: 30),
                  title:
                      const Text('Çıkış Yap', style: TextStyle(fontSize: 18)),
                  onTap: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Başarıyla çıkış yapıldı!')),
                        // burada ise hemen KullanciYok() wedget gostersin
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    } catch (e) {
                      /*  ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Çıkış yaparken hata oluştu: $e')),
                      );*/
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class KullanciYok extends StatelessWidget {
  const KullanciYok({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Giriş yapmadınız."),
            ElevatedButton(
              onPressed: () {
                // Giriş ekranına yönlendirme kodu buraya gelecek
                Navigator.pushReplacement(
                  context,
                  // ignore: non_constant_identifier_names
                  MaterialPageRoute(builder: (BuildContext Context) {
                    return LoginScreen();
                  }),
                );
              },
              child: const Text("Giriş Yap"),
            ),
          ],
        ),
      ),
    );
  }
}
