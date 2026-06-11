## 0.0.8

- Bump package version to `0.0.8`
- Update native mobile artifacts to `genotp-mobile v1.2.4` for 16KB memory page compatibility

## 0.0.7

- Stabilize Android Gradle configuration for CI with Flutter 3.44 by using a compatible AGP/Kotlin setup in `example/android`
- Resolve `dev.flutter.flutter-gradle-plugin` startup crash during AGP 9 migration by reverting incompatible migration flags
- Fix Kotlin/Java JVM target mismatch in the Android plugin module by aligning Kotlin compiler target to JVM 17

## 0.0.6

- Improve Android build compatibility by aligning the example project to Gradle 8.10.2 and AGP 8.7.3
- Make Android AAR bundling more reliable in CI by setting up Android SDK and ensuring Gradle wrapper files/scripts are available before `:genotp_flutter:bundleReleaseAar`
- Add Gradle wrapper scripts and wrapper JAR to `example/android` for reproducible local/CI builds
- Bump package version to `0.0.6`

## 0.0.5

- Fix Android plugin compilation by applying the Kotlin Android plugin so `GenotpFlutterPlugin` is available in consumer release builds

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
