## 0.0.4

- Fix Android release builds on modern AGP by packaging the native Android binding as `genotp.jar` plus `jniLibs`, instead of a direct local `.aar` dependency
- Add `tool/sync_mobile_artifacts.sh` to pull versioned native artifacts from `genotp-mobile` releases

## 0.0.3

- Add `otpauth-migration://` build/parse APIs for Google Authenticator multi-account QR flows
- Expose typed Dart models for migration payloads and accounts

## 0.0.2

- Fix iOS build: xcframework now properly included under `ios/genotp_flutter/` for Flutter SPM support
- Fix Swift error bridging for gomobile-generated ObjC API

## 0.0.1

Initial release.

- TOTP generation and verification via `GenotpFlutter.generateTotp` / `verifyTotp`
- HOTP generation via `GenotpFlutter.generateHotp`
- Secret generation via `GenotpFlutter.generateSecret`
- `otpauth://` URI builder for QR code display
- Android (API 24+) and iOS (13+) support
- Backed by [genotp-go](https://github.com/robby031/genotp-go) via gomobile
