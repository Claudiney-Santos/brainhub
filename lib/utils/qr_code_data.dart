import 'dart:convert';

class QrCodeData {
  final String name;
  final String code;

  const QrCodeData({required this.name, required this.code});

  String toQrString() => jsonEncode({'n': name, 'c': code});

  static QrCodeData? fromQrString(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final name = map['n'] as String?;
      final code = map['c'] as String?;
      if (name == null || code == null) return null;
      return QrCodeData(name: name.trim(), code: code.trim());
    } catch (_) {
      return null;
    }
  }
}
