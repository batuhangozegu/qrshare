// lib/views/edit_qr_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qrshare/Compenents/custom_button.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qr.dart';
import 'package:qrshare/constants/qr_colors.dart';
import 'package:qrshare/constants/qr_logos.dart';

//Yapay Zeka İle Yapıldı

class EditQRScreen extends StatefulWidget {
  final String initialData;
  final List<Color> initialColors;

  const EditQRScreen({
    super.key,
    required this.initialData,
    required this.initialColors,
  });

  @override
  State<EditQRScreen> createState() => _EditQRScreenState();
}

class _EditQRScreenState extends State<EditQRScreen> {
  late TextEditingController _dataController;
  late List<Color> selectedColors;
  bool useCustomColors = false;

  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.initialData);
    selectedColors = List.from(widget.initialColors);
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  void _pickColor(int colorIndex) {
    showDialog(
      context: context,
      builder: (context) {
        Color pickerColor = selectedColors[colorIndex];

        return AlertDialog(
          backgroundColor: const Color(0xFF1C2127),
          title: Text(
            colorIndex == 0 ? 'İlk Rengi Seç' : 'İkinci Rengi Seç',
            style: const TextStyle(color: Color(0xFFE1E1E1)),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                pickerColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  selectedColors[colorIndex] = pickerColor;
                  useCustomColors = true;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Seç'),
            ),
          ],
        );
      },
    );
  }

  void _saveQR() {
    Navigator.pop(context, {
      'data': _dataController.text,
      'colors': selectedColors,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Düzenle'),
        backgroundColor: const Color(0xFF101922),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF101922)),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // QR Önizleme
                AspectRatio(
                  aspectRatio: 1,
                  child: Material(
                    elevation: 4,
                    color: const Color(0xFF1C2127),
                    borderRadius: BorderRadius.circular(12),
                    child: HomeScreenQR(
                      data: _dataController.text.isEmpty
                          ? 'https://example.com'
                          : _dataController.text,
                      gradientColors: selectedColors,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Link Input
                const Text(
                  'Link',
                  style: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dataController,
                  style: const TextStyle(color: Color(0xFFE1E1E1)),
                  decoration: InputDecoration(
                    hintText: 'https://example.com',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFF1C2127),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.link,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Renk Seçimi - Hazır Temalar
                const Text(
                  'Renk Teması',
                  style: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: QRColorPresets.all.length,
                    itemBuilder: (context, index) {
                      final colors = QRColorPresets.all.values.elementAt(index);

                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColors = List.from(colors);
                              useCustomColors = false;
                            });
                          },
                          child: Container(
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: colors),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Özel Renk Seçimi
                const Text(
                  'Özel Renk',
                  style: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickColor(0),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: selectedColors[0],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.colorize, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickColor(1),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: selectedColors[1],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(Icons.colorize, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Colors.blue.shade900,
                        icon: Icons.refresh,
                        label: 'Önizleme',
                        onTap: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        backgroundColor: Colors.blue.shade900,
                        icon: Icons.check,
                        label: 'Kaydet',
                        onTap: _saveQR,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
