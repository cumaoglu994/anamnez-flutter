import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation extends StatefulWidget {
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformation> {
  String? _maritalStatus;
  String? _gender;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          _nameController.text = userData['name'] ?? '';
          _surnameController.text = userData['surname'] ?? '';
          _phoneController.text = userData['phoneNumber'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _gender = userData['gender'];
          _maritalStatus = userData['maritalStatus'];
          _ageController.text = userData['age'] ?? '';
          _weightController.text = userData['weight'] ?? '';
          _occupationController.text = userData['occupation'] ?? '';

          setState(() {});
        }
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Kullanıcı bilgileri çekilirken hata: $e');
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .set({
          'name': _nameController.text,
          'surname': _surnameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
          'gender': _gender,
          'maritalStatus': _maritalStatus,
          'age': _ageController.text,
          'weight': _weightController.text,
          'occupation': _occupationController.text,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bilgiler başarıyla güncellendi')),
        );
      } else {
        print('Kullanıcı bulunamadı.');
      }
    } catch (e) {
      print('Güncelleme hatası: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bilgiler güncellenemedi.')),
      );
    }
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Her bir alan arasına boşluk eklemek için
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
          filled: true,
          fillColor:
              Colors.grey.shade100, // Arka plana hafif bir renk eklemek için
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),

          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }

// Cinsiyet seçeneğini oluşturan widget
  buildGenderOption({
    required String label,
    required IconData icon,
    required String value,
    required bool isSelected, // Seçili durumunu belirten parametre
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = value; // Seçili cinsiyeti güncelle
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[100] : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey[700]),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.blue : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Medeni durum seçeneğini oluşturan widget
  buildMaritalStatusOption({
    required String label,
    required IconData icon,
    required String value,
    required bool isSelected, // Seçili durumunu belirten parametre
  }) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _maritalStatus = value; // Seçili medeni durumu güncelle
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[100] : Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey[700]),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.blue : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hesabım'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Kişisel bilgiler',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildTextField(
              'Ad',
              _nameController,
              icon: Icons.person,
              keyboardType: TextInputType.name,
            ),
            _buildTextField(
              'Soyad',
              _surnameController,
              icon: Icons.person_outline,
              keyboardType: TextInputType.name,
            ),
            _buildTextField(
              'Telefon Numarası',
              _phoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildGenderOption(
                  label: 'Erkek',
                  icon: Icons.male,
                  value: 'Erkek',
                  isSelected: _gender == 'Erkek', // Seçili durumu kontrol et
                ),
                SizedBox(width: 30),
                buildGenderOption(
                  label: 'Kadın',
                  icon: Icons.female,
                  value: 'Kadın',
                  isSelected: _gender == 'Kadın', // Seçili durumu kontrol et
                ),
              ],
            ),
            _buildTextField(
              'Adres',
              _addressController,
              icon: Icons.home,
              keyboardType: TextInputType.streetAddress,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildMaritalStatusOption(
                  label: 'Evli',
                  icon: Icons.family_restroom,
                  value: 'Evli',
                  isSelected:
                      _maritalStatus == 'Evli', // Seçili durumu kontrol et
                ),
                SizedBox(width: 20),
                buildMaritalStatusOption(
                  label: 'Bekar',
                  icon: Icons.person_add,
                  value: 'Bekar',
                  isSelected:
                      _maritalStatus == 'Bekar', // Seçili durumu kontrol et
                ),
                SizedBox(width: 20),
                buildMaritalStatusOption(
                  label: 'Dul',
                  icon: Icons.heart_broken,
                  value: 'Dul',
                  isSelected:
                      _maritalStatus == 'Dul', // Seçili durumu kontrol et
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildDatePickerField(
              'Dogum Tarahi',
              _ageController,
              icon: Icons.cake,
            ),
            _buildTextField(
              'Kilo',
              _weightController,
              icon: Icons.monitor_weight,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              'Meslek',
              _occupationController,
              icon: Icons.work,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 20.0),
              ),
              onPressed: () async {
                await _updateUserInfo();
                Navigator.pop(
                    context); // Güncelleme sonrası mevcut sayfayı kapatır ve önceki ekrana döner
              },
              child: Text('KAYDET'),
            ),
          ],
        ),
      ),
    );
  } // Kullanıcının seçtiği tarih

  DateTime? _selectedDate;
  Widget _buildDatePickerField(String label, TextEditingController controller,
      {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true, // Kullanıcının elle tarih girmesini engeller
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 16),
          filled: true,
          fillColor: Colors.grey.shade100,
          prefixIcon:
              icon != null ? Icon(icon, color: Colors.blueAccent) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900), // Geçerli bir tarih aralığı belirleyin
            lastDate: DateTime.now(),
          );

          if (pickedDate != null) {
            setState(() {
              _selectedDate = pickedDate;
              controller.text =
                  "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
            });
          }
        },
        style: TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
