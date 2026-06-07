import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:genotp_flutter/genotp_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelGenotpFlutter();
  const channel = MethodChannel('genotp_flutter');
  final log = <MethodCall>[];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'parseOtpAuthMigrationUri':
              return '{"accounts":[],"version":1,"batchSize":1,"batchIndex":0,"batchId":0}';
            default:
              return 'ok';
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('buildOtpAuthMigrationUri forwards expected payload', () async {
    await platform.buildOtpAuthMigrationUri(
      accountsJson: '[{"label":"alice@example.com"}]',
      version: 1,
      batchSize: 2,
      batchIndex: 1,
      batchId: 99,
    );

    expect(log, hasLength(1));
    expect(log.first.method, 'buildOtpAuthMigrationUri');
    expect(log.first.arguments, {
      'accountsJson': '[{"label":"alice@example.com"}]',
      'version': 1,
      'batchSize': 2,
      'batchIndex': 1,
      'batchId': 99,
    });
  });

  test('parseOtpAuthMigrationUri forwards expected payload', () async {
    final result = await platform.parseOtpAuthMigrationUri(
      uri: 'otpauth-migration://offline?data=abc',
    );

    expect(result, contains('"version":1'));
    expect(log, hasLength(1));
    expect(log.first.method, 'parseOtpAuthMigrationUri');
    expect(log.first.arguments, {
      'uri': 'otpauth-migration://offline?data=abc',
    });
  });
}
