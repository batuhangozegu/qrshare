import 'package:flutter/material.dart';
import 'package:custom_qr_generator/custom_qr_generator.dart';

class HomeScreenQR extends StatelessWidget {
  const HomeScreenQR({super.key});

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;

          return Center(
            child: CustomPaint(
              size: Size(size, size),
              painter: QrPainter(
                data: 'https://www.instagram.com/batuhangozegu',
                options: const QrOptions(
                  padding: 0,
                  shapes: QrShapes(
                    darkPixel: QrPixelShapeRoundCorners(),
                    frame: QrFrameShapeRoundCorners(cornerFraction: 1),
                    ball: QrBallShapeRoundCorners(cornerFraction: 1),
                  ),
                  colors: QrColors(
                    dark: QrColorLinearGradient(
                      colors: [Colors.blue, Colors.yellow],
                      orientation: GradientOrientation.leftDiagonal,
                    ),
                    background: QrColorSolid(Colors.transparent),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
