import 'package:flutter/material.dart';
import 'qr_type.dart';

//yapay zeka
class QRDataModel {
  final String id;
  final String data;
  final List<Color> gradientColors;
  final String? logoPath;
  final String title;
  final DateTime createdAt;
  final QRType type;

  QRDataModel({
    required this.id,
    required this.data,
    required this.gradientColors,
    this.logoPath,
    required this.title,
    required this.createdAt,
    this.type = QRType.link,
  });

  QRDataModel copyWith({
    String? id,
    String? data,
    List<Color>? gradientColors,
    String? logoPath,
    String? title,
    DateTime? createdAt,
    QRType? type,
  }) {
    return QRDataModel(
      id: id ?? this.id,
      data: data ?? this.data,
      gradientColors: gradientColors ?? this.gradientColors,
      logoPath: logoPath ?? this.logoPath,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data': data,
      'gradientColors': gradientColors.map((c) => c.value).toList(),
      'logoPath': logoPath,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'type': type.index,
    };
  }

  factory QRDataModel.fromJson(Map<String, dynamic> json) {
    return QRDataModel(
      id: json['id'],
      data: json['data'],
      gradientColors: (json['gradientColors'] as List)
          .map((colorValue) => Color(colorValue))
          .toList(),
      logoPath: json['logoPath'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      type: json['type'] != null ? QRType.values[json['type']] : QRType.link,
    );
  }
}
