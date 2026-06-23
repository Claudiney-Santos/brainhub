import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:zxing2/qrcode.dart';

String? decodeQrFromBytes(Uint8List bytes) {
  try {
    final image = img.decodeImage(bytes);
    if (image == null) return null;

    final rgbaBytes = image.getBytes(order: img.ChannelOrder.rgba);
    final pixels = Int32List(image.width * image.height);
    for (var i = 0; i < pixels.length; i++) {
      final offset = i * 4;
      final r = rgbaBytes[offset];
      final g = rgbaBytes[offset + 1];
      final b = rgbaBytes[offset + 2];
      final a = rgbaBytes[offset + 3];
      pixels[i] = (a << 24) | (r << 16) | (g << 8) | b;
    }

    final luminanceSource = RGBLuminanceSource(image.width, image.height, pixels);
    final bitmap = BinaryBitmap(HybridBinarizer(luminanceSource));
    final result = QRCodeReader().decode(bitmap);

    return result.text;
  } catch (_) {
    return null;
  }
}
