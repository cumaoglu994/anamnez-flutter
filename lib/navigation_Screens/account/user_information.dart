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
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;

  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'surname': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'age': TextEditingController(),
    'weight': TextEditingController(),
    'occupation': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _controllers['name']?.text = userData['name'] ?? '';
            _controllers['surname']?.text = userData['surname'] ?? '';
            _controllers['phone']?.text = userData['phoneNumber'] ?? '';
            _controllers['address']?.text = userData['address'] ?? '';
            _controllers['age']?.text = userData['age'] ?? '';
            _controllers['weight']?.text = userData['weight'] ?? '';
            _controllers['occupation']?.text = userData['occupation'] ?? '';
            _gender = userData['gender'];
            _maritalStatus = userData['maritalStatus'];
          });
        }
      }
    } catch (e) {
      _showErrorSnackBar('Bilgiler yüklenirken bir hata oluştu');
    }
  }

  Future<void> _updateUserInfo() async {
    try {
      if (!_formKey.currentState!.validate()) return;

      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await FirebaseFirestore.instance
            .collection('hasta')
            .doc(currentUser.uid)
            .set({
          'name': _controllers['name']?.text,
          'surname': _controllers['surname']?.text,
          'phoneNumber': _controllers['phone']?.text,
          'address': _controllers['address']?.text,
          'gender': _gender,
          'maritalStatus': _maritalStatus,
          'age': _controllers['age']?.text,
          'weight': _controllers['weight']?.text,
          'occupation': _controllers['occupation']?.text,
        }, SetOptions(merge: true));

        _showSuccessSnackBar('Bilgileriniz başarıyla güncellendi');
        Navigator.pop(context);
      }
    } catch (e) {
      _showErrorSnackBar('Güncelleme sırasında bir hata oluştu');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: Colors.green) : null,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red.shade300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentedButton(
    String title,
    List<Map<String, dynamic>> options,
    String? selectedValue,
    Function(String) onSelect,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: options.map((option) {
              bool isSelected = selectedValue == option['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSelect(option['value']),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color.fromARGB(177, 76, 175, 79)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          option['icon'],
                          color:
                              isSelected ? Colors.white : Colors.grey.shade600,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          option['label'],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _controllers['age'],
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Doğum Tarihi',
          prefixIcon: Icon(Icons.calendar_today, color: Colors.green),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate ?? DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Theme.of(context).primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            setState(() {
              _selectedDate = picked;
              _controllers['age']?.text =
                  "${picked.day}/${picked.month}/${picked.year}";
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Kişisel Bilgiler',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),

            // Form Fields
            _buildTextField(
              'Ad',
              _controllers['name'],
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Bu alan zorunludur' : null,
            ),
            _buildTextField(
              'Soyad',
              _controllers['surname'],
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Bu alan zorunludur' : null,
            ),
            _buildTextField(
              'Telefon',
              _controllers['phone'],
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Bu alan zorunludur' : null,
            ),

            _buildSegmentedButton(
              'Cinsiyet',
              [
                {'label': 'Erkek', 'value': 'Erkek', 'icon': Icons.male},
                {'label': 'Kadın', 'value': 'Kadın', 'icon': Icons.female},
              ],
              _gender,
              (value) => setState(() => _gender = value),
            ),

            _buildSegmentedButton(
              'Medeni Durum',
              [
                {'label': 'Evli', 'value': 'Evli', 'icon': Icons.favorite},
                {'label': 'Bekar', 'value': 'Bekar', 'icon': Icons.person},
                {'label': 'Dul', 'value': 'Dul', 'icon': Icons.heart_broken},
              ],
              _maritalStatus,
              (value) => setState(() => _maritalStatus = value),
            ),

            SizedBox(height: 10),
            _buildDateField(),
            _buildTextField(
              'Kilo (kg)',
              _controllers['weight'],
              icon: Icons.monitor_weight_outlined,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              'Meslek',
              _controllers['occupation'],
              icon: Icons.work_outline,
            ),
            /*    _buildTextField(
              'Adres',
              _controllers['address'],
              icon: Icons.home_outlined,
              keyboardType: TextInputType.multiline,
            ),*/
            ElevatedButton(
              onPressed: _updateUserInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(177, 76, 175, 79),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Bilgileri Güncelle',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }
}
