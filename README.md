# genotp_flutter

Flutter plugin for TOTP/HOTP one-time password generation and verification,
powered by [genotp-go](https://github.com/robby031/genotp-go) via gomobile.

Supports Android and iOS. The cryptographic engine runs natively on-device —
no network call required.

## Platform support

| Android | iOS |
|:-------:|:---:|
| 24+     | 13+ |

## Installation

```yaml
dependencies:
  genotp_flutter: ^0.0.7
```

## Usage

### Generate a new secret

```dart
import 'package:genotp_flutter/genotp_flutter.dart';

final secret = await GenotpFlutter.generateSecret();
// e.g. "JBSWY3DPEHPK3PXP"
```

### Generate a TOTP code

```dart
final code = await GenotpFlutter.generateTotp(secretB32: secret);
// e.g. "123456"
```

With custom parameters:

```dart
final code = await GenotpFlutter.generateTotp(
  secretB32: secret,
  algorithm: 0, // 0=SHA1  1=SHA256  2=SHA512
  digits: 6,
  period: 30,
);
```

### Verify a TOTP code

```dart
final valid = await GenotpFlutter.verifyTotp(
  secretB32: secret,
  code: userInput,
);
```

With custom window tolerance (default `window=1` allows +-1 period skew):

```dart
final valid = await GenotpFlutter.verifyTotp(
  secretB32: secret,
  code: userInput,
  window: 1,
);
```

### Build an `otpauth://` URI for QR code display

```dart
final uri = await GenotpFlutter.buildTotpUri(
  label: 'alice@example.com',
  secretB32: secret,
  issuer: 'MyApp',
);
// otpauth://totp/alice%40example.com?secret=...&issuer=MyApp&algorithm=SHA1&digits=6&period=30
```

Pass this URI to any QR code library to let users scan it into their
authenticator app (Google Authenticator, Authy, etc.).

### Build and parse `otpauth-migration://` URIs

```dart
final migrationUri = await GenotpFlutter.buildOtpAuthMigrationUri(
  accounts: const [
    OtpAuthMigrationAccount(
      label: 'alice@example.com',
      issuer: 'Example',
      secretB32: 'JBSWY3DPEHPK3PXP',
    ),
    OtpAuthMigrationAccount(
      label: 'ops@example.com',
      issuer: 'Ops',
      secretB32: 'MFRGGZDFMZTWQ2LK',
      algorithm: 'SHA256',
      digits: 8,
      isHotp: true,
      counter: 42,
    ),
  ],
  version: 1,
  batchSize: 2,
  batchIndex: 0,
  batchId: 123456,
);

final payload = await GenotpFlutter.parseOtpAuthMigrationUri(migrationUri);
print(payload.accounts.length); // 2
```

### HOTP

```dart
// Generate
final code = await GenotpFlutter.generateHotp(
  secretB32: secret,
  counter: 0,
);

// Build URI
final uri = await GenotpFlutter.buildHotpUri(
  label: 'alice@example.com',
  secretB32: secret,
  issuer: 'MyApp',
  counter: 0,
);
```

## Algorithm constants

| Value | Algorithm |
|-------|-----------|
| `0`   | SHA1 (default, widest compatibility) |
| `1`   | SHA256 |
| `2`   | SHA512 |

## Error handling

All methods throw a `PlatformException` on failure (invalid secret, bad
base32 encoding, etc.).

```dart
try {
  final code = await GenotpFlutter.generateTotp(secretB32: secret);
} on PlatformException catch (e) {
  print('OTP error: ${e.message}');
}
```

## How it works

```
Flutter (Dart)
    |  MethodChannel
Android (Kotlin)              iOS (Swift)
    |  mobile.Mobile.*            |  MobileNewTotpHandle()
genotp.jar + libgojni.so      Genotp.xcframework
    |                             |
    +------ genotp-go (Go) -------+
```

The native binary is compiled from
[genotp-go](https://github.com/robby031/genotp-go) using
[gomobile bind](https://pkg.go.dev/golang.org/x/mobile/cmd/gomobile).
To rebuild the native artifacts after updating genotp-go, see the
[genotp-mobile](https://github.com/robby031/genotp-mobile) repository.

To sync the Flutter plugin with a released
[genotp-mobile](https://github.com/robby031/genotp-mobile) version:

```bash
./tool/sync_mobile_artifacts.sh v1.2.3
```

## CI

GitHub Actions verifies this plugin on every push to `main` and every pull request:

- `flutter analyze`
- `flutter test`
- `dart pub publish --dry-run`
- `:genotp_flutter:bundleReleaseAar` in `example/android`
- `flutter build ios --release --no-codesign` in `example/`
