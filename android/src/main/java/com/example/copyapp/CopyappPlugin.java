package com.example.copyapp;

import android.app.Activity;
import android.content.Context;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.EventChannel;

/** CopyappPlugin */
public class CopyappPlugin implements FlutterPlugin {

  public static EventChannel.EventSink eventSink;
  public static boolean running = true;
  public static Activity activity;
  public static Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    init(flutterPluginBinding.getFlutterEngine().getDartExecutor());
  }

  public static void init(BinaryMessenger flutterEngine){

    new MethodChannel(flutterEngine, "jsz_plugin_method").setMethodCallHandler(new MethodCallHandler() {
      @Override
      public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("checkRunning")) {
          result.success("系统调用正常");
        }
        else if(call.method.equals("getRunning")){
          result.success(running);
        }
        else if(call.method.equals("setRunning")){
          boolean r = call.argument("running");
          running = r;
          result.success(running);
        }
        else if(call.method.equals("toast")){
          String msg = call.argument("msg");
          CopyappPlugin.toast(msg);
        }
        else {
          result.notImplemented();
        }
      }
    });

    new EventChannel(flutterEngine, "jsz_plugin_event").setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object arguments, EventChannel.EventSink events) {
        CopyappPlugin.eventSink = events;
      }

      @Override
      public void onCancel(Object arguments) {

      }
    });
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    context = registrar.context();
    init(registrar.messenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  public static void toast(String msg){
    View toastRoot = activity.getLayoutInflater().inflate(R.layout.toast_layout, null);
    Toast toast = new Toast(context);
    toast.setView(toastRoot);
    TextView tv = (TextView)toastRoot.findViewById(R.id.TextViewInfo);
    tv.setText(msg);
    toast.show();
//    Toast.makeText(context, msg,Toast.LENGTH_LONG).show();
  }
}
