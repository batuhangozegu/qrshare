import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_cardInfo.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qr.dart';

class HomeScreenQRCodeCard extends StatelessWidget {
  final String data;
  final String title;
  final List<Color> gradientColors;
  final VoidCallback? onCopy;
  final VoidCallback? onTap;
  final bool showData;

  const HomeScreenQRCodeCard({
    super.key,
    required this.data,
    required this.title,
    this.gradientColors = const [Colors.blue, Colors.yellow],
    this.onCopy,
    this.onTap,
    this.showData = true,
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
          HomeScreenCardInfo(
            title: title,
            data: data,
            onCopy: onCopy,
            onTap: onTap,
            showData: showData,
          ),
        ],
      ),
    );
  }
}
