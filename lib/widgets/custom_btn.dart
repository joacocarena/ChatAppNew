import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  
  final String text;
  final Function() onPressed;

  const CustomBtn({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      highlightElevation: 5,
      shape: const StadiumBorder(),
      color: Colors.blue[600],
      onPressed: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * .5,
        height: 55,
        child: Center(
          child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }
}