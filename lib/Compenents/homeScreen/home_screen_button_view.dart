import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/custom_button.dart';

class HomeScreenButtonView extends StatelessWidget {
  const HomeScreenButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          icon: Icons.add,
          backgroundColor: Colors.blue.shade900,
          label: "QR Kod Oluştur",
          onTap: () => print("Qr kod oluştur"),
        ),
        CustomButton(
          icon: Icons.list_alt_rounded,
          label: "QR Kodlarım",
          onTap: () => print("Qr kodlarım"),
        ),
        CustomButton(
          icon: Icons.edit,
          label: "Qr Değiştir",
          onTap: () => print("Qr kod oluştur"),
        ),
      ],
    );
  }
}
