import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:logging/logging.dart' show Logger;
import 'package:qr/qr.dart' show QrImage, QrCode, QrErrorCorrectLevel;

const defaultSize = 256;
const defaultAssetImg = 'assets/images/scan.png';
const defaultBgColor = Color.fromRGBO(255, 255, 255, 1.0);

// Build QR Code Image from string data
// Note that the margin is not considered.
class QrCodeImage extends StatelessWidget {
  final String data;
  final int size;
  final Color bgColor;
  QrCodeImage({
    super.key,
    required this.data,
    this.size = defaultSize,
    this.bgColor = defaultBgColor,
  });
  final _logger = Logger('QrCodeImage');

  @override
  Widget build(BuildContext context) {
    final params = getQrParams(data.length);
    if (params == null) {
      return Image.asset(defaultAssetImg);
    }

    try {
      final qrCode = QrCode(params["version"], params["ecc"])..addData(data);
      final qrImage = QrImage(qrCode);
      final count = qrImage.moduleCount;
      // actual image.size is integer multiple of the module count (count * ratio)
      // which is typically smaller than the size, yielding resizing in the end
      final ratio = size ~/ count;
      final image = img.Image(width: count * ratio, height: count * ratio);
      // iterate over modules
      for (var x = 0; x < count; x++) {
        for (var y = 0; y < count; y++) {
          if (!qrImage.isDark(y, x)) {
            // get square range for the module on the image
            final pixels = image.getRange(x * ratio, y * ratio, ratio, ratio);
            // paint with white color
            while (pixels.moveNext()) {
              pixels.current.setRgb(
                bgColor.r * 255,
                bgColor.g * 255,
                bgColor.b * 255,
              );
            }
          }
        }
      }
      return Image.memory(
        img.encodePng(image),
        width: size.toDouble(),
        height: size.toDouble(),
        fit: BoxFit.fill,
      );
    } catch (e) {
      _logger.warning(e.toString());
      return Image.asset(defaultAssetImg);
    }
  }
}

//
// Calculate version number and ecc leven depending on the size of data
// https://www.qrcode.com/en/about/version.html
//
Map<String, dynamic>? getQrParams(int length) {
  // Note: The equation below is experimental with one bit margin
  // and does not follow the specification described in above link.
  final maxMixedBits = 4 + 8 + 8 * (length);
  // priority is version number then ecc level
  if (maxMixedBits < 152) {
    return {
      "version": 1,
      "ecc": maxMixedBits < 128 ? QrErrorCorrectLevel.M : QrErrorCorrectLevel.L,
    };
  } else if (maxMixedBits < 272) {
    return {
      "version": 2,
      "ecc": maxMixedBits < 224 ? QrErrorCorrectLevel.M : QrErrorCorrectLevel.L,
    };
  } else if (maxMixedBits < 440) {
    return {
      "version": 3,
      "ecc": maxMixedBits < 352 ? QrErrorCorrectLevel.M : QrErrorCorrectLevel.L,
    };
  } else if (maxMixedBits < 640) {
    return {
      "version": 4,
      "ecc": maxMixedBits < 512 ? QrErrorCorrectLevel.M : QrErrorCorrectLevel.L,
    };
  } else if (maxMixedBits < 864) {
    return {
      "version": 5,
      "ecc": maxMixedBits < 688 ? QrErrorCorrectLevel.M : QrErrorCorrectLevel.L,
    };
  } else if (maxMixedBits < 1088) {
    return {"version": 6, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 1248) {
    return {"version": 7, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 1552) {
    return {"version": 8, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 1865) {
    return {"version": 9, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 2192) {
    return {"version": 10, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 2592) {
    return {"version": 11, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 2960) {
    return {"version": 12, "ecc": QrErrorCorrectLevel.L};
  } else if (maxMixedBits < 3424) {
    return {"version": 13, "ecc": QrErrorCorrectLevel.L};
  } else {
    return null;
  }
}
