package de.enercity.smartethermostate
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.wifi.WifiManager
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.PatternMatcher
import androidx.annotation.RequiresApi
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiConfiguration
import android.content.Context

import android.provider.Settings
import android.content.Intent



class MainActivity: FlutterActivity() {
    //Native code implementation for Android platform
    //Impemtation kept for future reference of native code implementation in Android
    

//    private val CHANNEL = "org/eurotronic/smartLiving/android/wificonnect"
//
//        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
//            super.configureFlutterEngine(flutterEngine)
//            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
//                    call, result ->
//                println("Have come inside native code base call");
//                if (call.method == "connectToWiFi") {
//                    connectToWifi();
//
//                }
//
//                // This method is invoked on the main thread.
//                // TODO
//            }
//        }
//
//    @RequiresApi(Build.VERSION_CODES.Q)
//    fun connectToWifi() {
////        val connectivityManager =
////            this.getSystemService(Context.CONNECTIVITY_SERVICE) as
////                    ConnectivityManager
////        val specifier = WifiNetworkSpecifier.Builder()
////            .setSsid("Comet WiFi")
////            .setWpa2Passphrase("11223344")
////            .setSsidPattern(PatternMatcher("Comet WiFi", PatternMatcher.PATTERN_PREFIX))
////            .build()
////        val request = NetworkRequest.Builder()
////            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
////            //.removeCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
////            .setNetworkSpecifier(specifier)
////            .build()
////        val networkCallback = object : ConnectivityManager.NetworkCallback() {
////            override fun onAvailable(network: Network) {
////                super.onAvailable(network)
////                println("connection_success")
////            }
////
////            override fun onUnavailable() {
////                super.onUnavailable()
////                println("connection_fail")
////            }
////
////            override fun onLost(network: Network) {
////                super.onLost(network)
////                println("out_of_range")
////            }
////        }
////        connectivityManager.requestNetwork(request, networkCallback)
//
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
//                val panelIntent = Intent(Settings.Panel.ACTION_INTERNET_CONNECTIVITY)
//                startActivityForResult(panelIntent, 545)
//            }
//        }

    }

