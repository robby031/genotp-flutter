package com.robby031.genotp_flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import mobile.Mobile

class GenotpFlutterPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "genotp_flutter")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "generateSecret" -> result.success(Mobile.generateSecretBase32())

                "generateTotp" -> {
                    val secretB32 = call.argument<String>("secretB32")!!
                    val algorithm = call.argument<Int>("algorithm")!!.toLong()
                    val digits = call.argument<Int>("digits")!!.toLong()
                    val period = call.argument<Int>("period")!!.toLong()
                    val totp = Mobile.newTotpHandle(secretB32, algorithm, digits, period)
                    val code = totp.generate()
                    totp.clearSecret()
                    result.success(code)
                }

                "verifyTotp" -> {
                    val secretB32 = call.argument<String>("secretB32")!!
                    val code = call.argument<String>("code")!!
                    val algorithm = call.argument<Int>("algorithm")!!.toLong()
                    val digits = call.argument<Int>("digits")!!.toLong()
                    val period = call.argument<Int>("period")!!.toLong()
                    val window = call.argument<Int>("window")!!.toLong()
                    val totp = Mobile.newTotpHandle(secretB32, algorithm, digits, period)
                    val valid = totp.verify(code, window)
                    totp.clearSecret()
                    result.success(valid)
                }

                "buildTotpUri" -> {
                    val label = call.argument<String>("label")!!
                    val secretB32 = call.argument<String>("secretB32")!!
                    val issuer = call.argument<String>("issuer") ?: ""
                    val algorithm = call.argument<String>("algorithm") ?: "SHA1"
                    val digits = call.argument<Int>("digits")!!.toLong()
                    val period = call.argument<Int>("period")!!.toLong()
                    result.success(Mobile.buildTotpUri(label, secretB32, issuer, algorithm, digits, period))
                }

                "generateHotp" -> {
                    val secretB32 = call.argument<String>("secretB32")!!
                    val counter = call.argument<Int>("counter")!!.toLong()
                    val algorithm = call.argument<Int>("algorithm")!!.toLong()
                    val digits = call.argument<Int>("digits")!!.toLong()
                    val hotp = Mobile.newHotpHandle(secretB32, algorithm, digits)
                    val code = hotp.generate(counter)
                    hotp.clearSecret()
                    result.success(code)
                }

                "buildHotpUri" -> {
                    val label = call.argument<String>("label")!!
                    val secretB32 = call.argument<String>("secretB32")!!
                    val issuer = call.argument<String>("issuer") ?: ""
                    val algorithm = call.argument<String>("algorithm") ?: "SHA1"
                    val digits = call.argument<Int>("digits")!!.toLong()
                    val counter = call.argument<Int>("counter")!!.toLong()
                    result.success(Mobile.buildHotpUri(label, secretB32, issuer, algorithm, digits, counter))
                }

                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("GENOTP_ERROR", e.message, null)
        }
    }
}
