import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomeScreenQR extends StatelessWidget {
  final String data;
  final List<Color> gradientColors;

  const HomeScreenQR({
    super.key,
    required this.data,
    this.gradientColors = const [Colors.blue, Colors.yellow],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: PrettyQrView.data(
                data: data,
                decoration: const PrettyQrDecoration(
                  shape: PrettyQrSmoothSymbol(
                    color: Colors.white,
                    roundFactor: 1,
                  ),
                  background: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
