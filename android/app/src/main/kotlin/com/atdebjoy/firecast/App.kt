package com.atdebjoy.firecast

import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}