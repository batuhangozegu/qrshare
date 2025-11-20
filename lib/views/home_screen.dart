import 'package:flutter/material.dart';

import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qrcode_card.dart';
import 'package:qrshare/Compenents/homeScreen/home_screen_button_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [Icon(Icons.qr_code_2_outlined), Text("QRShare")],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0x00101922)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(flex: 4, child: const HomeScreenQRCodeCard()),
                const SizedBox(height: 16),
                Expanded(flex: 2, child: HomeScreenButtonView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
