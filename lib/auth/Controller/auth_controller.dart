import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUsers(String email, String name, String password) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        // Firestore kaydı
        await _firestore.collection('hasta').doc(cred.user!.uid).set({
          'email': email,
          'userId': cred.user!.uid,
          'name': name,
          'createdAt': FieldValue.serverTimestamp(), // Oluşturulma tarihi
        });
        res = 'success';
      } else {
        res = 'please Fieleds must not be empty';
      }
    } catch (e) {
      res = e.toString(); // Hata durumunda mesaj döndürme
    }
    return res;
  }

  loginUsers(String email, String password) async {
    String res = 'Something went wrong ';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please Fields must not be empty ';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
