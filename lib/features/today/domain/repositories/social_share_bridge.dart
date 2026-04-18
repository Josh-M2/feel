import 'dart:typed_data';

abstract class SocialShareBridge {
  Future<bool> shareImage({
    required Uint8List imageBytes,
    required String fileName,
  });
}
