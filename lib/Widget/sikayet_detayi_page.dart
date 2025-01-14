import 'package:e_anamnez/ai/ai.dart';
import 'package:flutter/material.dart';

class SikayetDetayiPage extends StatefulWidget {
  final String sikayetId;
  final Map<String, dynamic> sikayetData;

  SikayetDetayiPage({required this.sikayetId, required this.sikayetData});

  @override
  State<SikayetDetayiPage> createState() => _SikayetDetayiPageState();
}

class _SikayetDetayiPageState extends State<SikayetDetayiPage> {
  final DiseasePredictor _predictor = DiseasePredictor();
  String sikayetText = '';
  String _aiResultText = ' ';
  String doctorResultText = 'Henüz değerlendirilmedi';

  @override
  void initState() {
    super.initState();
    processSikayetData();
    _initializePredictor();
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

  Future<void> _initializePredictor() async {
    await _predictor.loadModel();
    // Model yüklendikten sonra tahmin yap
    String prediction = await _predictor.predictDisease(sikayetText);
    setState(() {
      _aiResultText = prediction;
    });
  }

  @override
  void dispose() {
    _predictor.dispose();
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
