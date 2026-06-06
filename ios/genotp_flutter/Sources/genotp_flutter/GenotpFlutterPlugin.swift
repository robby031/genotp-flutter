import Flutter
import Genotp

public class GenotpFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "genotp_flutter", binaryMessenger: registrar.messenger())
        let instance = GenotpFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var err: NSError?

        switch call.method {
        case "generateSecret":
            let secret = MobileGenerateSecretBase32(&err)
            guard err == nil else { return fail(result, err!) }
            result(secret)

        case "generateTotp":
            let args = call.arguments as! [String: Any]
            guard let totp = MobileNewTotpHandle(
                args["secretB32"] as! String,
                args["algorithm"] as! Int,
                args["digits"] as! Int,
                args["period"] as! Int,
                &err
            ) else { return fail(result, err) }
            let code = totp.generate(&err)
            totp.clearSecret()
            guard err == nil else { return fail(result, err!) }
            result(code)

        case "verifyTotp":
            let args = call.arguments as! [String: Any]
            guard let totp = MobileNewTotpHandle(
                args["secretB32"] as! String,
                args["algorithm"] as! Int,
                args["digits"] as! Int,
                args["period"] as! Int,
                &err
            ) else { return fail(result, err) }
            var valid: ObjCBool = false
            do {
                try totp.verify(args["code"] as! String, window: args["window"] as! Int, ret0_: &valid)
            } catch let e as NSError {
                totp.clearSecret()
                return fail(result, e)
            }
            totp.clearSecret()
            result(valid.boolValue)

        case "buildTotpUri":
            let args = call.arguments as! [String: Any]
            let uri = MobileBuildTotpUri(
                args["label"] as! String,
                args["secretB32"] as! String,
                args["issuer"] as? String ?? "",
                args["algorithm"] as? String ?? "SHA1",
                args["digits"] as! Int,
                args["period"] as! Int
            )
            result(uri)

        case "generateHotp":
            let args = call.arguments as! [String: Any]
            guard let hotp = MobileNewHotpHandle(
                args["secretB32"] as! String,
                args["algorithm"] as! Int,
                args["digits"] as! Int,
                &err
            ) else { return fail(result, err) }
            let code = hotp.generate(Int64(args["counter"] as! Int), error: &err)
            hotp.clearSecret()
            guard err == nil else { return fail(result, err!) }
            result(code)

        case "buildHotpUri":
            let args = call.arguments as! [String: Any]
            let uri = MobileBuildHotpUri(
                args["label"] as! String,
                args["secretB32"] as! String,
                args["issuer"] as? String ?? "",
                args["algorithm"] as? String ?? "SHA1",
                args["digits"] as! Int,
                Int64(args["counter"] as! Int)
            )
            result(uri)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func fail(_ result: FlutterResult, _ error: NSError?) {
        result(FlutterError(
            code: "GENOTP_ERROR",
            message: error?.localizedDescription ?? "Unknown error",
            details: nil
        ))
    }
}
