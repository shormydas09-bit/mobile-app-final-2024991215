import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 65,
                backgroundImage: AssetImage('assets/profile.jpg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'SHORMY SHOMILY DAS',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Student ID: 2024991215',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text('Recipe Explorer', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
