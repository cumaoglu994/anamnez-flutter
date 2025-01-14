import 'package:e_anamnez/auth/Controller/auth_controller.dart';
import 'package:e_anamnez/auth/register_screen.dart';
import 'package:e_anamnez/main_srceen.dart';
import 'package:e_anamnez/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();

  late String email;

  late String password;
  bool _isLoading = false;
  _loginUsers() async {
    setState(() {
      _isLoading = true;
    });
    if (_formkey.currentState!.validate()) {
      String res = await _authController.loginUsers(email, password);
      if (res == 'success') {
        // ignore: use_build_context_synchronously
        return Navigator.pushReplacement(context,
            // ignore: non_ant_identifier_names
            MaterialPageRoute(builder: (BuildContext Context) {
          return MainScreen();
        }));
      } else {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        return showSnakBar(context, res);
      }
    } else {
      return showSnakBar(context, 'Lütfen alan boş olmasın');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Genişlik
                  ),
                  Text(
                    "Hesabına Giriş Yapın",
                    style: TextStyle(
                      fontSize: 28, // Büyük boyut, dikkat çekici
                      fontWeight:
                          FontWeight.w600, // Yarı kalın görünüm, daha şık
                      color: Color.fromARGB(255, 45, 62, 72), // Hafif koyu ton
                      letterSpacing: 1.2, // Daha geniş karakter aralığı
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(50, 0, 0, 0), // Hafif gölge
                          offset: Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center, // Metni ortala
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Arka plan rengi
                        borderRadius:
                            BorderRadius.circular(12), // Kenar yuvarlama
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Gölge etkisi
                          ),
                        ],
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen e-posta alanı boş olmamalıdır';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Lütfen geçerli bir e-posta adresi girin';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'E-postayı Girin',
                          labelStyle: TextStyle(
                              color: Colors.grey[600]), // Etiket rengi
                          prefixIcon: Icon(
                            Icons.email,
                            color: Color.fromARGB(
                                255, 45, 62, 72), // Hafif koyu ton
                          ), // E-posta simgesi
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Kenar yuvarlama
                            borderSide: BorderSide(
                                color: Colors.transparent), // Kenar çizgisi
                          ),
                          filled: true,
                          fillColor: Colors.blue[50], // Arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20), // İçerik için boşluk
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white, // Arka plan rengi
                        borderRadius:
                            BorderRadius.circular(12), // Kenar yuvarlama
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, 3), // Gölge efekti
                          ),
                        ],
                      ),
                      child: TextFormField(
                        obscureText: true, // Şifreyi gizler
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Lütfen şifre alanı boş bırakılmamalıdır';
                          } else if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır';
                          }
                          return null; // Hata yoksa null döndür
                        },
                        onChanged: (value) {
                          password = value; // Şifreyi güncelle
                        },
                        decoration: InputDecoration(
                          labelText: "Şifreyi Girin", // Etiket
                          labelStyle: TextStyle(
                              color: Colors.grey[600]), // Etiket rengi
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(
                                255, 45, 62, 72), // Hafif koyu ton
                          ), // Kilit simgesi
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Kenar yuvarlama
                            borderSide: BorderSide(
                                color: Colors.transparent), // Kenar çizgisi
                          ),
                          filled: true,
                          fillColor: Colors.blue[50], // Arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20), // İçerik için boşluk
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _loginUsers(); // Giriş yapma işlemi
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            const Color.fromARGB(255, 33, 243, 173),
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
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors
                                    .white, // Yüklenme göstergesinin rengi
                              )
                            : Text(
                                'Giriş Yap',
                                style: TextStyle(
                                  fontSize: 20,
                                  letterSpacing: 2, // Harfler arası mesafe
                                  color: Color.fromARGB(
                                      255, 45, 62, 72), // Hafif koyu ton
                                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                                ),
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).size.width * 0.01),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Row içeriğini ortala
                      children: [
                        Text(
                          'Bir hesaba ihtiyacınız var mı? ',
                          style: TextStyle(
                            color: Colors.black87,
                            letterSpacing: 0.5, // Karakter aralığı ekledik
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return RegisterScreen();
                                },
                              ),
                            );
                          },
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              color: Colors.blueAccent, // Buton metninin rengi
                              fontWeight: FontWeight.bold, // Kalın yazı
                              letterSpacing: 1.0, // Daha geniş karakter aralığı
                              shadows: [
                                Shadow(
                                  color: Colors.black26, // Hafif gölge
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0), // Buton içi boşluk
                            backgroundColor:
                                Colors.transparent, // Şeffaf arka plan
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
