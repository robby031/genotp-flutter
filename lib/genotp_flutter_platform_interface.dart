import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'genotp_flutter_method_channel.dart';

abstract class GenotpFlutterPlatform extends PlatformInterface {
  GenotpFlutterPlatform() : super(token: _token);

  static final Object _token = Object();
  static GenotpFlutterPlatform _instance = MethodChannelGenotpFlutter();

  static GenotpFlutterPlatform get instance => _instance;
  static set instance(GenotpFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String> generateSecret();

  Future<String> generateTotp({
    required String secretB32,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
  });

  Future<bool> verifyTotp({
    required String secretB32,
    required String code,
    int algorithm = 0,
    int digits = 6,
    int period = 30,
    int window = 1,
  });

  Future<String> buildTotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int period = 30,
  });

  Future<String> generateHotp({
    required String secretB32,
    required int counter,
    int algorithm = 0,
    int digits = 6,
  });

  Future<String> buildHotpUri({
    required String label,
    required String secretB32,
    String issuer = '',
    String algorithm = 'SHA1',
    int digits = 6,
    int counter = 0,
  });
}
