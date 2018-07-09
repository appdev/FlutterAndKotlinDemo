package app.efs.flutterplugin

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Parcelable
import android.util.Log
import com.google.gson.Gson
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

class RouterPlugin private constructor(private val registrar: Registrar) : MethodCallHandler, PluginRegistry.ActivityResultListener {

    companion object {

        @JvmStatic
        private val TAG = RouterPlugin::class.java.simpleName

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val instance = RouterPlugin(registrar)
            val channel = MethodChannel(registrar.messenger(), "router_plugin")
            registrar.addActivityResultListener(instance)
            channel.setMethodCallHandler(instance)
        }

    }

    private var methodCall: MethodCall? = null
    private var pendingResult: Result? = null
    private var requestCode: Int = 0

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (this.pendingResult != null) {
            Log.e(TAG, "RouterPlugin is already active.")
            return
        }
        val activity = registrar.activity()
        if (activity == null) {
            Log.e(TAG, "RouterPlugin requires a foreground activity.")
            return
        }
        this.methodCall = call
        this.pendingResult = result
        val activityClassName = if (!call.hasArgument("activity")) null else call.argument<String>("activity")
        if (activityClassName.isNullOrEmpty()) {
            Log.e(TAG, "RouterPlugin requires a activity class name.")
            return
        }
        val arguments = if (!call.hasArgument("arguments")) null else call.argument<Map<String, Any>?>("arguments")
        when (call.method) {
            "startActivity" -> {
                activity.startActivity(getActivityIntent(activity, activityClassName!!, arguments))
                result.success(null)
                this.methodCall = null
                this.pendingResult = null
            }
            "startActivityForResult" -> {
                val requestCode = if (!call.hasArgument("requestCode")) -1 else call.argument("requestCode")
                if (requestCode == -1) {
                    Log.e(TAG, "RequestCode cannot be null")
                    return
                }
                this.requestCode = requestCode
                activity.startActivityForResult(getActivityIntent(activity, activityClassName!!, arguments), requestCode)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == this.requestCode) {
            if (resultCode == Activity.RESULT_OK) {
                val ret: MutableMap<String, Any> = mutableMapOf()
                data?.extras?.keySet()?.forEach {
                    ret[it] = data.extras[it]
                }
                println("---------->信息：$ret")
                this.pendingResult?.success(if (ret.isEmpty()) null else ret)
            }
            this.methodCall = null
            this.pendingResult = null
            this.requestCode = 0
            return true
        }
        return false
    }

    private fun getActivityIntent(context: Context, activityClassName: String, params: Map<String, Any>? = null): Intent {
        val intent = Intent(context, Class.forName(activityClassName))
        with(intent) {
            params?.apply {
                for (entry in this.entries) {
                    val key = entry.key
                    when (entry.value) {
                        is Char -> putExtra(key, entry.value as Char)
                        is Short -> putExtra(key, entry.value as Short)
                        is Int -> putExtra(key, entry.value as Int)
                        is Long -> putExtra(key, entry.value as Long)
                        is Float -> putExtra(key, entry.value as Float)
                        is Double -> putExtra(key, entry.value as Double)
                        is Boolean -> putExtra(key, entry.value as Boolean)
                        is String -> putExtra(key, entry.value as String)
                        is CharArray -> putExtra(key, entry.value as CharArray)
                        is ShortArray -> putExtra(key, entry.value as ShortArray)
                        is IntArray -> putExtra(key, entry.value as IntArray)
                        is LongArray -> putExtra(key, entry.value as LongArray)
                        is FloatArray -> putExtra(key, entry.value as FloatArray)
                        is DoubleArray -> putExtra(key, entry.value as DoubleArray)
                        is BooleanArray -> putExtra(key, entry.value as BooleanArray)
                        is Parcelable -> putExtra(key, entry.value as Parcelable)
                        else -> putExtra(key, Gson().toJson(entry.value as String)) //复杂类型会被转换成JSON-String
                    }

                }
            }


        }
        return intent
    }

}
