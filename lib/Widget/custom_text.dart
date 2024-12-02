import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  late final String hint;
  late final TextEditingController? textEditingController;

  CustomText({
    super.key,
    required this.hint,
    required this.textEditingController,
  });

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1), // Hafif dolgu rengi
        contentPadding:
            EdgeInsets.symmetric(vertical: 16, horizontal: 20), // İç boşluk
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blueAccent, // Odaklanıldığında kenarlık rengi
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.5),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.7),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
