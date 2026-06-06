## 0.0.1

Initial release.

- TOTP generation and verification via `GenotpFlutter.generateTotp` / `verifyTotp`
- HOTP generation via `GenotpFlutter.generateHotp`
- Secret generation via `GenotpFlutter.generateSecret`
- `otpauth://` URI builder for QR code display
- Android (API 24+) and iOS (13+) support
- Backed by [genotp-go](https://github.com/robby031/genotp-go) via gomobile
