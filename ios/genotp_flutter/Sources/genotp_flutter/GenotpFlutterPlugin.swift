import Flutter
import Genotp

public class GenotpFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "genotp_flutter", binaryMessenger: registrar.messenger())
        let instance = GenotpFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        do {
            switch call.method {
            case "generateSecret":
                var error: NSError?
                let secret = MobileGenerateSecretBase32(&error)
                if let err = error { throw err }
                result(secret)

            case "generateTotp":
                let args = call.arguments as! [String: Any]
                let secretB32 = args["secretB32"] as! String
                let algorithm = args["algorithm"] as! Int
                let digits = args["digits"] as! Int
                let period = args["period"] as! Int
                var error: NSError?
                let totp = MobileNewTotpHandle(secretB32, algorithm, digits, period, &error)
                if let err = error { throw err }
                var genError: NSError?
                let code = totp!.generate(&genError)
                totp!.clearSecret()
                if let err = genError { throw err }
                result(code)

            case "verifyTotp":
                let args = call.arguments as! [String: Any]
                let secretB32 = args["secretB32"] as! String
                let code = args["code"] as! String
                let algorithm = args["algorithm"] as! Int
                let digits = args["digits"] as! Int
                let period = args["period"] as! Int
                let window = args["window"] as! Int
                var error: NSError?
                let totp = MobileNewTotpHandle(secretB32, algorithm, digits, period, &error)
                if let err = error { throw err }
                var valid: ObjCBool = false
                var verifyError: NSError?
                _ = totp!.verify(code, window: window, ret0_: &valid, error: &verifyError)
                totp!.clearSecret()
                if let err = verifyError { throw err }
                result(valid.boolValue)

            case "buildTotpUri":
                let args = call.arguments as! [String: Any]
                let label = args["label"] as! String
                let secretB32 = args["secretB32"] as! String
                let issuer = args["issuer"] as? String ?? ""
                let algorithm = args["algorithm"] as? String ?? "SHA1"
                let digits = args["digits"] as! Int
                let period = args["period"] as! Int
                let uri = MobileBuildTotpUri(label, secretB32, issuer, algorithm, digits, period)
                result(uri)

            case "generateHotp":
                let args = call.arguments as! [String: Any]
                let secretB32 = args["secretB32"] as! String
                let counter = args["counter"] as! Int
                let algorithm = args["algorithm"] as! Int
                let digits = args["digits"] as! Int
                var error: NSError?
                let hotp = MobileNewHotpHandle(secretB32, algorithm, digits, &error)
                if let err = error { throw err }
                var genError: NSError?
                let code = hotp!.generate(Int64(counter), error: &genError)
                hotp!.clearSecret()
                if let err = genError { throw err }
                result(code)

            case "buildHotpUri":
                let args = call.arguments as! [String: Any]
                let label = args["label"] as! String
                let secretB32 = args["secretB32"] as! String
                let issuer = args["issuer"] as? String ?? ""
                let algorithm = args["algorithm"] as? String ?? "SHA1"
                let digits = args["digits"] as! Int
                let counter = args["counter"] as! Int
                let uri = MobileBuildHotpUri(label, secretB32, issuer, algorithm, digits, Int64(counter))
                result(uri)

            default:
                result(FlutterMethodNotImplemented)
            }
        } catch {
            result(FlutterError(code: "GENOTP_ERROR", message: error.localizedDescription, details: nil))
        }
    }
}
