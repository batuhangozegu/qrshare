import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qrcode_card.dart';
import 'package:qrshare/Compenents/homeScreen/home_screen_button_view.dart';
import 'package:qrshare/views/edit_qr_screen.dart';
import 'package:qrshare/views/my_qrs_screen.dart';
import 'package:qrshare/views/qr_detail_screen.dart';
import '../services/qr_storage_service.dart';
import '../models/qr_data_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final QRStorageService _storageService = QRStorageService();

  // Özel QR (ana ekranda her zaman görünür)
  QRDataModel _personalQR = QRDataModel(
    id: 'personal',
    data: 'https://www.instagram.com/batuhangozegu',
    title: 'Detaylar için QR kodu okutun',
    gradientColors: [const Color(0xFF833AB4), const Color(0xFFFD1D1D)],
    createdAt: DateTime.now(),
  );

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPersonalQR();
  }

  Future<void> _loadPersonalQR() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final personalQRJson = prefs.getString('personal_qr');

    if (personalQRJson != null) {
      final json = jsonDecode(personalQRJson);
      _personalQR = QRDataModel.fromJson(json);
    }

    setState(() => _isLoading = false);
  }

  Future<void> _savePersonalQR(QRDataModel qr) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('personal_qr', jsonEncode(qr.toJson()));
    setState(() => _personalQR = qr);
  }

  void _createQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditQRScreen(isCreating: true),
      ),
    );

    if (result != null && result is QRDataModel && mounted) {
      // Yeni oluşturulan QR storage'a zaten kaydedildi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR kod oluşturuldu ve kaydedildi')),
      );
    }
  }

  void _showMyQRs() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MyQRsScreen(),
      ),
    );
  }

  void _editQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQRScreen(
          initialData: _personalQR.data,
          initialTitle: _personalQR.title,
          initialColors: _personalQR.gradientColors,
          qrId: _personalQR.id,
          initialType: _personalQR.type,
          isCreating: false,
        ),
      ),
    );

    if (result != null && result is QRDataModel) {
      await _savePersonalQR(result);
    }
  }

  void _showQRDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRDetailScreen(qrData: _personalQR),
      ),
    );
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 4,
                        child: HomeScreenQRCodeCard(
                          data: _personalQR.data,
                          title: _personalQR.title,
                          gradientColors: _personalQR.gradientColors,
                          onCopy: () {},
                          onTap: _showQRDetail,
                          showData: false,
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
