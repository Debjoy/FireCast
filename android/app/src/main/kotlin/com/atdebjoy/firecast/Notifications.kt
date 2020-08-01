package com.atdebjoy.firecast

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat

object Notifications {
    const val NOTIFICATION_ID_BACKGROUND_SERVICE = 1

    private const val CHANNEL_ID_BACKGROUND_SERVICE = "FireCast_Service"

    fun createNotificationChannels(context: Context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID_BACKGROUND_SERVICE,
                "FireCast Service",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager =
                context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    fun buildForegroundNotification(context: Context): Notification {
        return NotificationCompat
            .Builder(context, CHANNEL_ID_BACKGROUND_SERVICE)
            .setSmallIcon(R.drawable.ic_television_2)
            .setContentTitle("FireCast Service")
            .setContentText("Keeping FireCast active 😀")
            .build()
    }
}