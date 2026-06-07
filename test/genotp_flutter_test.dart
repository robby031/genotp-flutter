import 'package:flutter_test/flutter_test.dart';
import 'package:genotp_flutter/genotp_flutter.dart';
import 'package:genotp_flutter/genotp_flutter_method_channel.dart';
import 'package:genotp_flutter/genotp_flutter_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGenotpFlutterPlatform
    with MockPlatformInterfaceMixin
    implements GenotpFlutterPlatform {
  @override
  Future<String> generateSecret() async => 'SECRET';

  @override
  Future<String> generateTotp({
    required String secretB32,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
  }) async => '123456';

  @override
  Future<bool> verifyTotp({
    required String secretB32,
    required String code,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
    int window = 1,
  }) async => true;

  @override
  Future<String> buildTotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int period = 30,
  }) async => 'otpauth://totp/mock';

  @override
  Future<String> generateHotp({
    required String secretB32,
    required int counter,
    int algorithm = 0,
    int digits = 6,
  }) async => '654321';

  @override
  Future<String> buildHotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int counter = 0,
  }) async => 'otpauth://hotp/mock';

  @override
  Future<String> buildOtpAuthMigrationUri({
    required String accountsJson,
    int version = 1,
    int batchSize = 1,
    int batchIndex = 0,
    int batchId = 0,
  }) async => 'otpauth-migration://offline?data=mock';

  @override
  Future<String> parseOtpAuthMigrationUri({required String uri}) async =>
      '{"accounts":[{"type":1,"label":"alice@example.com","issuer":"Example","secretB32":"JBSWY3DPEHPK3PXP","algorithm":0,"digits":6,"period":30,"counter":0}],"version":1,"batchSize":1,"batchIndex":0,"batchId":10}';
}

void main() {
  final initialPlatform = GenotpFlutterPlatform.instance;

  test('$MethodChannelGenotpFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGenotpFlutter>());
  });

  test('parseOtpAuthMigrationUri returns typed payload', () async {
    GenotpFlutterPlatform.instance = MockGenotpFlutterPlatform();

    final payload = await GenotpFlutter.parseOtpAuthMigrationUri(
      'otpauth-migration://offline?data=mock',
    );

    expect(payload.version, 1);
    expect(payload.batchId, 10);
    expect(payload.accounts, hasLength(1));
    expect(payload.accounts.first.label, 'alice@example.com');
    expect(payload.accounts.first.algorithm, 'SHA1');
    expect(payload.accounts.first.isHotp, isFalse);
  });
}
