import 'package:flutter/material.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      appBar: AppBar(
        title: const Text('Wallet'),
        backgroundColor: const Color(0xFF0A1728),
        elevation: 0,
      ),
      body: const Center(
        child: Text('Wallet Screen'),
      ),
    );
  }
}
