package com.atdebjoy.firecast

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setNavigationBarColored(this)
        GeneratedPluginRegistrant.registerWith(this)

        Notifications.createNotificationChannels(this)


        MethodChannel(flutterView, "com.example/background_service").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "startService") {
                    val callbackRawHandle = method.arguments as Long
                    BackgroundService.startService(this@MainActivity, callbackRawHandle)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterView, "com.example/app_retain").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "sendToBackground") {
                    moveTaskToBack(true)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onBackPressed() {
        super.onBackPressed()
    }
    fun setNavigationBarColored( activity: MainActivity ){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            activity.window!!.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
            activity.window!!.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
            activity.window!!.navigationBarColor = Color.WHITE;
        }
    }




}
