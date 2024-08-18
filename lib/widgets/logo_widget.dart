import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  
  final String title;

  const Logo({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(top: 50),
        child: SafeArea(
          child: Column(
            children: [
              Image.asset('assets/logo.png'),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 30)),
            ],
          ),
        ),
      ),
    );
  }
}