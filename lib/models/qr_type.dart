enum QRType {
  link,
  iban,
  phone,
  email,
  wifi,
  text,
}

extension QRTypeExtension on QRType {
  String get displayName {
    switch (this) {
      case QRType.link:
        return 'Link/URL';
      case QRType.iban:
        return 'IBAN';
      case QRType.phone:
        return 'Telefon';
      case QRType.email:
        return 'E-posta';
      case QRType.wifi:
        return 'WiFi';
      case QRType.text:
        return 'Metin';
    }
  }

  String get icon {
    switch (this) {
      case QRType.link:
        return '🔗';
      case QRType.iban:
        return '💳';
      case QRType.phone:
        return '📱';
      case QRType.email:
        return '📧';
      case QRType.wifi:
        return '📶';
      case QRType.text:
        return '📝';
    }
  }

  String get placeholder {
    switch (this) {
      case QRType.link:
        return 'https://example.com';
      case QRType.iban:
        return 'TR00 0000 0000 0000 0000 0000 00';
      case QRType.phone:
        return '+90 555 555 5555';
      case QRType.email:
        return 'ornek@email.com';
      case QRType.wifi:
        return 'WiFi Adı';
      case QRType.text:
        return 'Herhangi bir metin';
    }
  }

  String formatData(String data, {String? wifiPassword, String? wifiSecurity}) {
    switch (this) {
      case QRType.link:
        if (!data.startsWith('http://') && !data.startsWith('https://')) {
          return 'https://$data';
        }
        return data;
      case QRType.iban:
        return data.replaceAll(' ', '');
      case QRType.phone:
        return 'tel:$data';
      case QRType.email:
        return 'mailto:$data';
      case QRType.wifi:
        return 'WIFI:S:$data;T:${wifiSecurity ?? "WPA"};P:${wifiPassword ?? ""};;';
      case QRType.text:
        return data;
    }
  }
}
