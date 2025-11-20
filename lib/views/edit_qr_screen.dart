// lib/views/edit_qr_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:qrshare/Compenents/custom_button.dart';
import 'package:qrshare/Compenents/homeScreen/QrCard/home_screen_qr.dart';
import 'package:qrshare/constants/qr_colors.dart';
import '../models/qr_data_model.dart';
import '../models/qr_type.dart';
import '../services/qr_storage_service.dart';

//Yapay Zeka İle Yapıldı

class EditQRScreen extends StatefulWidget {
  final String initialData;
  final String? initialTitle;
  final List<Color> initialColors;
  final bool isCreating;
  final String? qrId;
  final QRType? initialType;

  const EditQRScreen({
    super.key,
    this.initialTitle,
    this.initialData = "",
    this.initialColors = const [Colors.blue, Colors.yellow],
    this.isCreating = false,
    this.qrId,
    this.initialType,
  });

  @override
  State<EditQRScreen> createState() => _EditQRScreenState();
}

class _EditQRScreenState extends State<EditQRScreen> {
  late TextEditingController _titleController;
  late TextEditingController _dataController;
  late TextEditingController _wifiPasswordController;
  late List<Color> selectedColors;
  bool useCustomColors = false;
  late QRType _selectedType;
  String _wifiSecurity = 'WPA';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _dataController = TextEditingController(text: widget.initialData);
    _wifiPasswordController = TextEditingController();
    selectedColors = List.from(widget.initialColors);
    _selectedType = widget.initialType ?? QRType.link;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dataController.dispose();
    _wifiPasswordController.dispose();
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

  String _getFormattedData() {
    return _selectedType.formatData(
      _dataController.text,
      wifiPassword: _wifiPasswordController.text,
      wifiSecurity: _wifiSecurity,
    );
  }

  Future<void> _saveQR() async {
    if (_dataController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen gerekli alanları doldurun')),
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir başlık girin')),
      );
      return;
    }

    final storageService = QRStorageService();

    final qrData = QRDataModel(
      id: widget.qrId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      data: _getFormattedData(),
      gradientColors: selectedColors,
      title: _titleController.text.isEmpty ? 'QR Kod' : _titleController.text,
      createdAt: DateTime.now(),
      type: _selectedType,
    );

    final success = await storageService.saveQRCode(qrData);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.isCreating ? 'QR kod oluşturuldu' : 'QR kod güncellendi')),
        );
        Navigator.pop(context, qrData);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bir hata oluştu')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCreating ? 'QR Oluştur' : 'QR Düzenle'),
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
                          ? _selectedType.placeholder
                          : _getFormattedData(),
                      gradientColors: selectedColors,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // QR Tipi Seçimi veya Gösterimi
                const Text(
                  'QR Tipi',
                  style: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.isCreating)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2127),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        children: QRType.values.map((type) {
                          final isSelected = _selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    type.icon,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(type.displayName),
                                ],
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedType = type;
                                  _dataController.clear();
                                });
                              },
                              backgroundColor: const Color(0xFF2C3137),
                              selectedColor: Colors.blue.shade900,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : const Color(0xFFE1E1E1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2127),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _selectedType.icon,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedType.displayName,
                          style: const TextStyle(
                            color: Color(0xFFE1E1E1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                // Başlık alanı (hem oluşturma hem düzenleme için)
                const Text(
                  'Başlık',
                  style: TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Color(0xFFE1E1E1)),
                  decoration: InputDecoration(
                    hintText: 'QR kodun başlığı (ör: Instagram Profil)',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFF1C2127),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.title,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Dinamik Input Alanları
                Text(
                  _selectedType.displayName,
                  style: const TextStyle(
                    color: Color(0xFFE1E1E1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _dataController,
                  style: const TextStyle(color: Color(0xFFE1E1E1)),
                  keyboardType: _selectedType == QRType.phone
                      ? TextInputType.phone
                      : _selectedType == QRType.email
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                  decoration: InputDecoration(
                    hintText: _selectedType.placeholder,
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFF1C2127),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: Icon(
                      _selectedType == QRType.link
                          ? Icons.link
                          : _selectedType == QRType.iban
                              ? Icons.account_balance
                              : _selectedType == QRType.phone
                                  ? Icons.phone
                                  : _selectedType == QRType.email
                                      ? Icons.email
                                      : _selectedType == QRType.wifi
                                          ? Icons.wifi
                                          : Icons.text_fields,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // WiFi için ekstra alanlar
                if (_selectedType == QRType.wifi) ...[
                  TextField(
                    controller: _wifiPasswordController,
                    style: const TextStyle(color: Color(0xFFE1E1E1)),
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'WiFi Şifresi',
                      hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                      filled: true,
                      fillColor: const Color(0xFF1C2127),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C2127),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: DropdownButton<String>(
                      value: _wifiSecurity,
                      isExpanded: true,
                      dropdownColor: const Color(0xFF1C2127),
                      underline: const SizedBox(),
                      style: const TextStyle(color: Color(0xFFE1E1E1)),
                      items: ['WPA', 'WEP', 'nopass'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value == 'nopass' ? 'Şifresiz' : value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _wifiSecurity = newValue!;
                        });
                      },
                    ),
                  ),
                ],
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
                        icon: widget.isCreating ? Icons.add : Icons.check,
                        label: widget.isCreating ? 'Oluştur' : 'Kaydet',
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
