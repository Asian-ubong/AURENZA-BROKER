import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: const Color(0xFF0A1728),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Support Screen'),
      ),
    );
  }
}
