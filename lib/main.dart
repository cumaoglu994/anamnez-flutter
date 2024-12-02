import 'package:e_anamnez/main_srceen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: MainScreen.id,
      theme: ThemeData(
        primarySwatch: Colors.green, // Sağlık için daha uygun bir ana renk
        scaffoldBackgroundColor: Color.fromARGB(
            255, 240, 255, 250), // Çok açık mavi yeşil tonunda arka plan
        appBarTheme: AppBarTheme(
          backgroundColor:
              Colors.green.withOpacity(0.8), // AppBar arka plan rengi
          elevation: 4, // AppBar'ın hafif gölgesi
          titleTextStyle: TextStyle(
            color: Colors.white, // Başlık metni rengi
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(
            color: Colors.white, // AppBar ikon rengi
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // Alt navigasyon barı rengi
          selectedItemColor: Colors.green, // Seçili öğe rengi
          unselectedItemColor: Colors.grey, // Seçilmeyen öğe rengi
        ),
        fontFamily: 'Poppins',
      ),
      home: MainScreen(),
    );
  }
}
