import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../../domain/repositories/social_share_bridge.dart';

class MethodChannelSocialShareBridge implements SocialShareBridge {
  MethodChannelSocialShareBridge({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel('feel/social_share');

  final MethodChannel _channel;

  @override
  Future<bool> shareImage({
    required Uint8List imageBytes,
    required String fileName,
  }) async {
    try {
      final bool? didLaunch = await _channel.invokeMethod<bool>(
        'shareImage',
        <String, dynamic>{'imageBytes': imageBytes, 'fileName': fileName},
      );
      return didLaunch == true;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
