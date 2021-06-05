package com.minh.momo_vn

import android.annotation.TargetApi
import android.app.Activity
import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import vn.momo.momo_partner.AppMoMoLib
import 	java.util.Base64

@Suppress("DEPRECATION")
class MomoVnPluginDelegate(private var registrar: PluginRegistry.Registrar? = null) : ActivityResultListener {

    private var pendingResult: Result? = null
    private var pendingReply: Map<String, Any>? = null

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

        AppMoMoLib.getInstance().requestMoMoCallBack(registrar?.activity(), paymentInfo)
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