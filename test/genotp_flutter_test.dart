import 'package:flutter_test/flutter_test.dart';
import 'package:genotp_flutter/genotp_flutter.dart';
import 'package:genotp_flutter/genotp_flutter_platform_interface.dart';
import 'package:genotp_flutter/genotp_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGenotpFlutterPlatform
    with MockPlatformInterfaceMixin
    implements GenotpFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GenotpFlutterPlatform initialPlatform = GenotpFlutterPlatform.instance;

  test('$MethodChannelGenotpFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGenotpFlutter>());
  });

  test('getPlatformVersion', () async {
    GenotpFlutter genotpFlutterPlugin = GenotpFlutter();
    MockGenotpFlutterPlatform fakePlatform = MockGenotpFlutterPlatform();
    GenotpFlutterPlatform.instance = fakePlatform;

    expect(await genotpFlutterPlugin.getPlatformVersion(), '42');
  });
}
