import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'genotp_flutter_platform_interface.dart';

class MethodChannelGenotpFlutter extends GenotpFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('genotp_flutter');

  @override
  Future<String> generateSecret() async {
    return await methodChannel.invokeMethod<String>('generateSecret') ?? '';
  }

  @override
  Future<String> generateTotp({
    required String secretB32,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
  }) async {
    return await methodChannel.invokeMethod<String>('generateTotp', {
          'secretB32': secretB32,
          'algorithm': algorithm,
          'digits': digits,
          'period': period,
        }) ??
        '';
  }

  @override
  Future<bool> verifyTotp({
    required String secretB32,
    required String code,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
    int window = 1,
  }) async {
    return await methodChannel.invokeMethod<bool>('verifyTotp', {
          'secretB32': secretB32,
          'code': code,
          'algorithm': algorithm,
          'digits': digits,
          'period': period,
          'window': window,
        }) ??
        false;
  }

  @override
  Future<String> buildTotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int period = 30,
  }) async {
    return await methodChannel.invokeMethod<String>('buildTotpUri', {
          'label': label,
          'secretB32': secretB32,
          'issuer': issuer,
          'algorithm': algorithm,
          'digits': digits,
          'period': period,
        }) ??
        '';
  }

  @override
  Future<String> generateHotp({
    required String secretB32,
    required int counter,
    int algorithm = 0,
    int digits = 6,
  }) async {
    return await methodChannel.invokeMethod<String>('generateHotp', {
          'secretB32': secretB32,
          'counter': counter,
          'algorithm': algorithm,
          'digits': digits,
        }) ??
        '';
  }

  @override
  Future<String> buildHotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int counter = 0,
  }) async {
    return await methodChannel.invokeMethod<String>('buildHotpUri', {
          'label': label,
          'secretB32': secretB32,
          'issuer': issuer,
          'algorithm': algorithm,
          'digits': digits,
          'counter': counter,
        }) ??
        '';
  }

  @override
  Future<String> buildOtpAuthMigrationUri({
    required String accountsJson,
    int version = 1,
    int batchSize = 1,
    int batchIndex = 0,
    int batchId = 0,
  }) async {
    return await methodChannel
            .invokeMethod<String>('buildOtpAuthMigrationUri', {
              'accountsJson': accountsJson,
              'version': version,
              'batchSize': batchSize,
              'batchIndex': batchIndex,
              'batchId': batchId,
            }) ??
        '';
  }

  @override
  Future<String> parseOtpAuthMigrationUri({required String uri}) async {
    return await methodChannel.invokeMethod<String>(
          'parseOtpAuthMigrationUri',
          {'uri': uri},
        ) ??
        '';
  }
}
