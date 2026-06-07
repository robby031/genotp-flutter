import 'dart:convert';

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

  static Future<String> buildOtpAuthMigrationUri({
    required List<OtpAuthMigrationAccount> accounts,
    int version = 1,
    int batchSize = 1,
    int batchIndex = 0,
    int batchId = 0,
  }) {
    return GenotpFlutterPlatform.instance.buildOtpAuthMigrationUri(
      accountsJson: jsonEncode(
        accounts.map((account) => account.toJson()).toList(),
      ),
      version: version,
      batchSize: batchSize,
      batchIndex: batchIndex,
      batchId: batchId,
    );
  }

  static Future<OtpAuthMigrationPayload> parseOtpAuthMigrationUri(
    String uri,
  ) async {
    final json = await GenotpFlutterPlatform.instance.parseOtpAuthMigrationUri(
      uri: uri,
    );

    return OtpAuthMigrationPayload.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );
  }
}

class OtpAuthMigrationAccount {
  const OtpAuthMigrationAccount({
    required this.label,
    required this.secretB32,
    this.issuer = '',
    this.algorithm = 'SHA1',
    this.digits = 6,
    this.period = 30,
    this.counter = 0,
    this.isHotp = false,
  });

  final String label;
  final String issuer;
  final String secretB32;
  final String algorithm;
  final int digits;
  final int period;
  final int counter;
  final bool isHotp;

  Map<String, dynamic> toJson() => {
    'type': isHotp ? 0 : 1,
    'label': label,
    'issuer': issuer,
    'secretB32': secretB32,
    'algorithm': _algorithmToInt(algorithm),
    'digits': digits,
    'period': period,
    'counter': counter,
  };

  factory OtpAuthMigrationAccount.fromJson(Map<String, dynamic> json) {
    final type = (json['type'] as num?)?.toInt() ?? 1;

    return OtpAuthMigrationAccount(
      label: json['label'] as String? ?? '',
      issuer: json['issuer'] as String? ?? '',
      secretB32: json['secretB32'] as String? ?? '',
      algorithm: _algorithmFromInt((json['algorithm'] as num?)?.toInt() ?? 0),
      digits: (json['digits'] as num?)?.toInt() ?? 6,
      period: (json['period'] as num?)?.toInt() ?? 30,
      counter: (json['counter'] as num?)?.toInt() ?? 0,
      isHotp: type == 0,
    );
  }

  static int _algorithmToInt(String value) {
    switch (value.toUpperCase()) {
      case 'SHA256':
        return 1;
      case 'SHA512':
        return 2;
      default:
        return 0;
    }
  }

  static String _algorithmFromInt(int value) {
    switch (value) {
      case 1:
        return 'SHA256';
      case 2:
        return 'SHA512';
      default:
        return 'SHA1';
    }
  }
}

class OtpAuthMigrationPayload {
  const OtpAuthMigrationPayload({
    required this.accounts,
    required this.version,
    required this.batchSize,
    required this.batchIndex,
    required this.batchId,
  });

  final List<OtpAuthMigrationAccount> accounts;
  final int version;
  final int batchSize;
  final int batchIndex;
  final int batchId;

  factory OtpAuthMigrationPayload.fromJson(Map<String, dynamic> json) {
    final rawAccounts = json['accounts'] as List<dynamic>? ?? const [];
    return OtpAuthMigrationPayload(
      accounts: rawAccounts
          .map(
            (item) =>
                OtpAuthMigrationAccount.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      version: (json['version'] as num?)?.toInt() ?? 1,
      batchSize: (json['batchSize'] as num?)?.toInt() ?? 0,
      batchIndex: (json['batchIndex'] as num?)?.toInt() ?? 0,
      batchId: (json['batchId'] as num?)?.toInt() ?? 0,
    );
  }
}
