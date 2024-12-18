import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class SikayetDetayiPage extends StatefulWidget {
  final String sikayetId;
  final Map<String, dynamic> sikayetData;

  SikayetDetayiPage({required this.sikayetId, required this.sikayetData});

  @override
  State<SikayetDetayiPage> createState() => _SikayetDetayiPageState();
}

class _SikayetDetayiPageState extends State<SikayetDetayiPage> {
  Interpreter? _interpreter;
  String sikayetText = '';
  String _aiResultText = ' ';
  String doctorResultText = 'Henüz değerlendirilmedi';
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    processSikayetData();
    _loadModel();
  }

  void processSikayetData() {
    widget.sikayetData.forEach((key, value) {
      if (key == 'sikayet') {
        sikayetText = value;
      } else if (key != 'tarih' && value == true) {
        sikayetText += ', $key';
      }
    });
  }

  Future<void> _loadModel() async {
    try {
      _interpreter =
          await Interpreter.fromAsset('assets/hastalik_tahmin_model.tflite');
      setState(() {
        _isModelLoaded = true;
      });
      print("Model başarıyla yüklendi.");
      _runModel(sikayetText); // Model yüklendikten sonra çalıştır.
    } catch (e) {
      print("Model yüklenirken hata oluştu: $e");
    }
  }

  Future<void> _runModel(String input) async {
    if (!_isModelLoaded || _interpreter == null) {
      print("Model henüz yüklenmedi.");
      return;
    }

    try {
      List<String> stringInputs = input.split(" "); // Girdiyi boşluklarla ayır
      List<int> tokenizedInput =
          stringInputs.map((word) => _wordToToken(word)).toList();

      var inputTensor = [tokenizedInput];
      var outputShape = _interpreter!.getOutputTensor(0).shape;
      var output = List.filled(outputShape[1], 0).reshape([1, outputShape[1]]);

      _interpreter!.run(inputTensor, output);

      setState(() {
        _aiResultText = "Tahmin Sonucu: ${output[0][0].toStringAsFixed(2)}";
      });
    } catch (e) {
      print("Model çalıştırılırken hata oluştu: $e");
    }
  }

  int _wordToToken(String word) {
    return word.hashCode % 1000; // Basit bir token dönüşümü
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Şikayet Detayı',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green[600],
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isModelLoaded) Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              _buildDetailCard('Şikayet Detayı', sikayetText, Colors.green),
              SizedBox(height: 20),
              _buildDetailCard('Yapay Zeka Tahmin Sonucu',
                  'Tahmin edilen hastalık $_aiResultText', Colors.blue),
              SizedBox(height: 20),
              _buildDetailCard('Doktor Değerlendirme Sonucu', doctorResultText,
                  Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String content, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
