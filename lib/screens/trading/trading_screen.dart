import 'package:flutter/material.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({super.key});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        title: const Text('Trading'),
        backgroundColor: const Color(0xFF0A1728),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Trading Screen'),
      ),
    );
  }
}
