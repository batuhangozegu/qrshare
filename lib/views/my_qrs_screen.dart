import 'package:flutter/material.dart';
import '../models/qr_data_model.dart';
import '../services/qr_storage_service.dart';
import 'qr_detail_screen.dart';
import 'edit_qr_screen.dart';

class MyQRsScreen extends StatefulWidget {
  const MyQRsScreen({super.key});

  @override
  State<MyQRsScreen> createState() => _MyQRsScreenState();
}

class _MyQRsScreenState extends State<MyQRsScreen> {
  final QRStorageService _storageService = QRStorageService();
  List<QRDataModel> _qrCodes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQRCodes();
  }

  Future<void> _loadQRCodes() async {
    setState(() => _isLoading = true);
    final qrCodes = await _storageService.getAllQRCodes();
    setState(() {
      _qrCodes = qrCodes;
      _isLoading = false;
    });
  }

  Future<void> _deleteQRCode(String id) async {
    final success = await _storageService.deleteQRCode(id);
    if (success) {
      _loadQRCodes();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('QR kod silindi')));
      }
    }
  }

  Future<void> _editQRCode(QRDataModel qr) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQRScreen(
          initialData: qr.data,
          initialTitle: qr.title,
          initialColors: qr.gradientColors,
          isCreating: false,
          qrId: qr.id,
          initialType: qr.type,
        ),
      ),
    );

    if (result != null) {
      _loadQRCodes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101922),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
        title: const Text('QR Kodlarım'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _qrCodes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, size: 100, color: Colors.grey.shade700),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz QR kodunuz yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _qrCodes.length,
              itemBuilder: (context, index) {
                final qr = _qrCodes[index];
                return Card(
                  color: const Color(0xFF1C2127),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRDetailScreen(qrData: qr),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: qr.gradientColors,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.qr_code_2,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  qr.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE1E1E1),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  qr.data,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF8E8E93),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editQRCode(qr),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: const Color(0xFF1C2127),
                                  title: const Text('QR Kodu Sil'),
                                  content: Text(
                                    '${qr.title} QR kodunu silmek istediğinize emin misiniz?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('İptal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _deleteQRCode(qr.id);
                                      },
                                      child: const Text(
                                        'Sil',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
