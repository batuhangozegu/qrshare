import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/qr_data_model.dart';

class QRStorageService {
  static const String _storageKey = 'qr_codes';

  Future<List<QRDataModel>> getAllQRCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final String? qrCodesJson = prefs.getString(_storageKey);

    if (qrCodesJson == null) {
      return [];
    }

    final List<dynamic> qrCodesList = jsonDecode(qrCodesJson);
    return qrCodesList.map((json) => QRDataModel.fromJson(json)).toList();
  }

  Future<bool> saveQRCode(QRDataModel qrCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final qrCodes = await getAllQRCodes();

      final existingIndex = qrCodes.indexWhere((qr) => qr.id == qrCode.id);
      if (existingIndex != -1) {
        qrCodes[existingIndex] = qrCode;
      } else {
        qrCodes.add(qrCode);
      }

      final String qrCodesJson = jsonEncode(qrCodes.map((qr) => qr.toJson()).toList());
      return await prefs.setString(_storageKey, qrCodesJson);
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteQRCode(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final qrCodes = await getAllQRCodes();

      qrCodes.removeWhere((qr) => qr.id == id);

      final String qrCodesJson = jsonEncode(qrCodes.map((qr) => qr.toJson()).toList());
      return await prefs.setString(_storageKey, qrCodesJson);
    } catch (e) {
      return false;
    }
  }

  Future<QRDataModel?> getQRCodeById(String id) async {
    final qrCodes = await getAllQRCodes();
    try {
      return qrCodes.firstWhere((qr) => qr.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteAllQRCodes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_storageKey);
    } catch (e) {
      return false;
    }
  }
}
