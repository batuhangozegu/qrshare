import 'package:flutter/material.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qrcode_card.dart';
import 'package:qrshare/Compenents/homeScreen/home_screen_button_view.dart';
import 'package:qrshare/views/edit_qr_screen.dart'; // Ekle

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String qrData = 'https://www.instagram.com/batuhangozegu';
  List<Color> qrColors = [Colors.blue, Colors.yellow];

  void _createQR() {
    print("QR oluştur ekranına git");
    // Daha sonra yapacağız
  }

  void _showMyQRs() {
    print("Kayıtlı QR'ları göster");
    // Daha sonra yapacağız
  }

  void _editQR() async {
    // EditQRScreen'e git ve sonucu bekle
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditQRScreen(initialData: qrData, initialColors: qrColors),
      ),
    );

    // Kullanıcı kaydet dediyse, sonucu al ve güncelle
    if (result != null) {
      setState(() {
        qrData = result['data'];
        qrColors = result['colors'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.qr_code_2_outlined),
            SizedBox(width: 8),
            Text("QRShare"),
          ],
        ),
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF101922)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: HomeScreenQRCodeCard(
                    data: qrData,
                    gradientColors: qrColors,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  flex: 2,
                  child: HomeScreenButtonView(
                    onCreateQR: _createQR,
                    onMyQRs: _showMyQRs,
                    onEditQR: _editQR,
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
