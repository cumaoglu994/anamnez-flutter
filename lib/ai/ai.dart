import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DiseasePredictor {
  late Interpreter _interpreter;
  late List<String> _vocabulary;
  late List<String> _labels;
  static const int MAX_WORDS = 1000; // Vectorizer'ın vocabulary boyutu

  Future<void> loadModel() async {
    // Model dosyasını yükle
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/symptom_disease_model.tflite');

      // Vocabulary'yi yükle
      String vocabString = await rootBundle.loadString('assets/vocabulary.txt');
      _vocabulary = vocabString.split('\n')..removeLast();

      // Etiketleri yükle
      String labelString = await rootBundle.loadString('assets/labels.txt');
      _labels = List<String>.from(json.decode(labelString));
    } catch (e) {
      print('Model yükleme hatası: $e');
      rethrow;
    }
  }

  List<double> _vectorizeText(String text) {
    // Metni küçük harfe çevir ve gereksiz karakterleri temizle
    text = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');

    // Kelimelere ayır
    List<String> words = text.split(' ');

    // Count vectorizer mantığını uygula
    List<double> vector = List<double>.filled(MAX_WORDS, 0);
    for (String word in words) {
      int? index = _vocabulary.indexOf(word);
      if (index != -1) {
        vector[index] += 1;
      }
    }

    return vector;
  }

  Future<String> predictDisease(String symptoms) async {
    // Metni vektöre dönüştür
    List<double> inputVector = _vectorizeText(symptoms);

    // Model giriş şeklini ayarla
    var input = [inputVector];

    // Çıkış tensörünü hazırla
    var output =
        List<double>.filled(_labels.length, 0).reshape([1, _labels.length]);

    // Tahmin yap
    _interpreter.run(input, output);

    // En yüksek olasılıklı hastalığı bul
    int maxIndex = 0;
    double maxValue = output[0][0];
    for (int i = 1; i < _labels.length; i++) {
      if (output[0][i] > maxValue) {
        maxValue = output[0][i];
        maxIndex = i;
      }
    }

    // Hastalık adını döndür
    return _labels[maxIndex];
  }

  void dispose() {
    _interpreter.close();
  }
}
