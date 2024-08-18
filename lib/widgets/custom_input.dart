import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController textController; //? obtain the value of the text field
  final TextInputType keyboardType; //? email, password ...
  final bool isPassword;

  const CustomInput({
    super.key, 
    required this.icon, 
    required this.placeholder, 
    required this.textController, 
    required this.keyboardType, 
    required this.isPassword
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20) ,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            offset: const Offset(0, 5),
            blurRadius: 5
          )
        ]
      ),
      child: TextField(
        obscureText: isPassword,
        controller: textController,
        autocorrect: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: placeholder
        ),
      )
    );
  }
}