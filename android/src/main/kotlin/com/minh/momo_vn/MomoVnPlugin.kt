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
import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.PluginRegistry.Registrar
import androidx.core.content.ContextCompat
import android.annotation.TargetApi
import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import vn.momo.momo_partner.AppMoMoLib
import 	java.util.Base64

class MomoVnPlugin : MethodCallHandler,FlutterPlugin,ActivityAware,ActivityResultListener   {
    private var pendingResult: Result? = null
    private var pendingReply: Map<String, Any>? = null
    private lateinit var activity: Activity
    private lateinit var ab: ActivityPluginBinding

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("AppLog","zzzz")

        val channel = MethodChannel(flutterPluginBinding.binaryMessenger, MomoVnConfig.CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            MomoVnConfig.METHOD_REQUEST_PAYMENT -> {
                this.openCheckout(call.arguments, result)
            }
            else -> {
                result.notImplemented()

            }
        }
    }
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

    }
    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        activity = activityBinding.activity
        ab = activityBinding
        ab.addActivityResultListener(this)
    }
    override fun onDetachedFromActivityForConfigChanges() {
    }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }
    override fun onDetachedFromActivity() {
    }
    fun openCheckout(momoRequestPaymentData: Any, result: Result) {
        this.pendingResult = result;
        AppMoMoLib.getInstance().setAction(AppMoMoLib.ACTION.PAYMENT)
        AppMoMoLib.getInstance().setActionType(AppMoMoLib.ACTION_TYPE.GET_TOKEN)

        val paymentInfo: HashMap<String, Any> = momoRequestPaymentData as HashMap<String, Any>
        val isTestMode: Boolean? = paymentInfo["isTestMode"] as Boolean?

        if (isTestMode == null || !isTestMode) {
            AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.PRODUCTION)
        } else {
            AppMoMoLib.getInstance().setEnvironment(AppMoMoLib.ENVIRONMENT.DEVELOPMENT)
        }

        AppMoMoLib.getInstance().requestMoMoCallBack(activity, paymentInfo)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (resultCode == Activity.RESULT_OK) {
            if (requestCode == AppMoMoLib.getInstance().REQUEST_CODE_MOMO) {
                _handleResult(data)
            }
        }
        return true
    }
    private fun sendReply(data: Map<String, Any>) {
        if (this.pendingResult != null) {
            this.pendingResult?.success(data)
            pendingReply = null
        } else {
            pendingReply = data
        }
    }

    private fun _handleResult(data: Intent?) {
        data?.let {
            val status = data.getIntExtra("status", -1)
            var isSuccess: Boolean = false
            if (status == MomoVnConfig.CODE_PAYMENT_SUCCESS) isSuccess = true
            val token = data.getStringExtra("data")
            val phonenumber = data.getStringExtra("phonenumber")
            val message = data.getStringExtra("message")
            val extra = data.getStringExtra("extra")
            val data: MutableMap<String, Any> = java.util.HashMap()
            data.put("isSuccess", isSuccess)
            data.put("status", status)
            data.put("phoneNumber", phonenumber.toString())
            data.put("token", token.toString())
            data.put("message", message.toString())
            data.put("extra", extra.toString())
            sendReply(data)
        } ?: run {
            val data: MutableMap<String, Any> = java.util.HashMap()
            data.put("isSuccess", false)
            data.put("status", 7);
            data.put("phoneNumber", "")
            data.put("token", "")
            data.put("message", "")
            data.put("extra", "")
            sendReply(data)
        }
    }
}