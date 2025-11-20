import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/custom_button.dart';

class HomeScreenButtonView extends StatelessWidget {
  final VoidCallback onCreateQR;
  final VoidCallback onMyQRs;
  final VoidCallback onEditQR;

  const HomeScreenButtonView({
    super.key,
    required this.onCreateQR,
    required this.onMyQRs,
    required this.onEditQR,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          icon: Icons.add,
          backgroundColor: Colors.blue.shade900,
          label: "QR Kod Oluştur",
          onTap: onCreateQR,
        ),
        CustomButton(
          icon: Icons.list_alt_rounded,
          label: "QR Kodlarım",
          onTap: onMyQRs,
        ),
        CustomButton(icon: Icons.edit, label: "Qr Değiştir", onTap: onEditQR),
      ],
    );
  }
}
