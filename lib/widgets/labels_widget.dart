import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  
  final String route;
  final String title;
  final String subTitle;

  const Labels({super.key, required this.route, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w400)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => Navigator.pushReplacementNamed(context, route),
          child: Text(
            subTitle, 
            style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold)
          )
        )
      ],
    );
  }
}