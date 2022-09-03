@file:Suppress("DEPRECATION")

package com.minh.momo_vn
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import android.content.pm.PackageManager


class MomoVnPlugin(private var registrar: Registrar) : MethodCallHandler,FlutterPlugin {
    private val momoVnPluginDelegate = MomoVnPluginDelegate(registrar)
    init {
        registrar.addActivityResultListener(momoVnPluginDelegate)
    }
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val momoPaymentPlugin = MomoVnPlugin(registrar)
        val channel = MethodChannel(registrar.messenger(), MomoVnConfig.CHANNEL_NAME)
        channel.setMethodCallHandler(momoPaymentPlugin)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            MomoVnConfig.METHOD_REQUEST_PAYMENT -> {
                this.momoVnPluginDelegate.openCheckout(call.arguments, result)
            }
            else -> result.notImplemented()
        }
    }
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


}