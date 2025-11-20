import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/custom_button.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qrcode_card.dart';

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
                Expanded(
                  flex: 3, // QR Card için alan
                  child: const HomeScreenQRCodeCard(),
                ),
                const SizedBox(height: 1),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CustomButton(
                        label: "Deneme",
                        onTap: () => print("tıklandı"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
