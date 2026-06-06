import 'genotp_flutter_platform_interface.dart';

class GenotpFlutter {
  static Future<String> generateSecret() {
    return GenotpFlutterPlatform.instance.generateSecret();
  }

  static Future<String> generateTotp({
    required String secretB32,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
  }) {
    return GenotpFlutterPlatform.instance.generateTotp(
      secretB32: secretB32,
      algorithm: algorithm,
      digits: digits,
      period: period,
    );
  }

  static Future<bool> verifyTotp({
    required String secretB32,
    required String code,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
    int window = 1,
  }) {
    return GenotpFlutterPlatform.instance.verifyTotp(
      secretB32: secretB32,
      code: code,
      algorithm: algorithm,
      digits: digits,
      period: period,
      window: window,
    );
  }

  static Future<String> buildTotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int period = 30,
  }) {
    return GenotpFlutterPlatform.instance.buildTotpUri(
      label: label,
      secretB32: secretB32,
      issuer: issuer,
      algorithm: algorithm,
      digits: digits,
      period: period,
    );
  }

  static Future<String> generateHotp({
    required String secretB32,
    required int counter,
    int algorithm = 0,
    int digits = 6,
  }) {
    return GenotpFlutterPlatform.instance.generateHotp(
      secretB32: secretB32,
      counter: counter,
      algorithm: algorithm,
      digits: digits,
    );
  }

  static Future<String> buildHotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int counter = 0,
  }) {
    return GenotpFlutterPlatform.instance.buildHotpUri(
      label: label,
      secretB32: secretB32,
      issuer: issuer,
      algorithm: algorithm,
      digits: digits,
      counter: counter,
    );
  }
}
