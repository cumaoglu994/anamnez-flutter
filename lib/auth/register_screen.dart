import 'package:e_anamnez/auth/Controller/auth_controller.dart';
import 'package:e_anamnez/auth/login_screen.dart';
import 'package:e_anamnez/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late String email;

  late String name;

  late String password;
  bool _isloading = false;

  _signUpUsers() async {
    setState(() {
      _isloading = true;
    });
    if (_formkey.currentState!.validate()) {
      await _authController.signUpUsers(email, name, password).whenComplete(() {
        setState(() {
          _formkey.currentState!.reset();
          _isloading = false;
        });
      });
      return showSnakBar(
          // ignore: use_build_context_synchronously
          context,
          'Congratulations An Account Has Been Created For You ');
    } else {
      setState(() {
        _isloading = false;
      });
      return showSnakBar(context, 'Please fieled Must no be empty ');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png', width: 200, // Genişlik
                      height: 200, // Yükseklik
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Hesap Oluştur",
                      style: TextStyle(
                        fontSize: 36, // Yazı boyutunu biraz daha büyüttük
                        fontWeight:
                            FontWeight.w600, // Yarı kalınlık, daha şık görünüm
                        color: Color.fromARGB(
                            255, 45, 62, 72), // Hafif daha koyu ton
                        letterSpacing:
                            1.2, // Karakterler arasında boşluk, daha rahat okuma sağlar
                        shadows: [
                          Shadow(
                            color: Color.fromARGB(50, 0, 0,
                                0), // Hafif gölge, yazıya derinlik katar
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center, // Metni ortalayın
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0), // Daha geniş bir boşluk
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Kullanıcı adı boş olamaz.";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          name = value;
                        },
                        decoration: InputDecoration(
                          labelText: "Kullanıcı Adı Girin",

                          labelStyle: TextStyle(
                              color: Colors.grey[600]), // Etiket rengi
                          prefixIcon: Icon(Icons.person,
                              color: Colors.blue), // Kilit simgesi
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Kenar yuvarlama
                            borderSide: BorderSide(
                                color: Colors.transparent), // Kenar çizgisi
                          ),
                          filled: true,
                          fillColor: Colors.blue[50], // Arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0), // Boşluk artırıldı
                      child: TextFormField(
                        keyboardType: TextInputType
                            .emailAddress, // E-posta girişi için uygun klavye türü
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "E-postayı boş olamaz."; // Boş kontrolü
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                              .hasMatch(value)) {
                            return "Geçerli bir e-posta adresi girin."; // Geçerlilik kontrolü
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: InputDecoration(
                          labelText: 'E-postayı Girin',
                          labelStyle: TextStyle(
                              color: Colors.grey[600]), // Etiket rengi
                          prefixIcon: Icon(Icons.email,
                              color: Colors.blue), // E-posta simgesi
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Kenar yuvarlama
                            borderSide: BorderSide(
                                color: Colors.transparent), // Kenar çizgisi
                          ),
                          filled: true,
                          fillColor: Colors.blue[50], // Arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0), // Daha geniş bir boşluk
                      child: TextFormField(
                        obscureText: true, // Şifre gizleme
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Şifre boş olamaz.";
                          } else if (value.length < 6) {
                            return "Şifre en az 6 karakter olmalıdır."; // Uzunluk kontrolü
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: InputDecoration(
                          labelText: "Şifreyi Girin", // Etiket
                          labelStyle: TextStyle(
                              color: Colors.grey[600]), // Etiket rengi
                          prefixIcon: Icon(Icons.lock,
                              color: Colors.blue), // Kilit simgesi
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(12), // Kenar yuvarlama
                            borderSide: BorderSide(
                                color: Colors.transparent), // Kenar çizgisi
                          ),
                          filled: true,
                          fillColor: Colors.blue[50], // Arka plan rengi
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _signUpUsers();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: _isloading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Kayıt Ol",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 4),
                                  )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Ortalanmış bir hizalama
                      children: [
                        Text(
                          "Zaten bir hesabım var ! ",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54), // Düzgün font stili
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return LoginScreen();
                              }),
                            );
                          },
                          child: Text(
                            "Giriş Yap",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue, // Mavi renk ile vurgulama
                              fontWeight: FontWeight.bold, // Kalın yazı
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
