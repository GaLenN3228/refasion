package ru.refashioned_app

import android.os.Bundle

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine;
import androidx.annotation.NonNull;

import com.yandex.mapkit.MapKitFactory


import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager
class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        MapKitFactory.setApiKey("721bea2e-5bfb-48d2-9a3f-f5e6311769e9")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }
}