import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_cardInfo';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qr.dart';

class HomeScreenQRCodeCard extends StatelessWidget {
  final String data;
  final List<Color> gradientColors;

  const HomeScreenQRCodeCard({
    super.key,
    required this.data,
    this.gradientColors = const [Colors.blue, Colors.yellow],
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: const Color(0xFF1C2127),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: HomeScreenQR(data: data, gradientColors: gradientColors),
          ),
          HomeScreenCardInfo(),
        ],
      ),
    );
  }
}
