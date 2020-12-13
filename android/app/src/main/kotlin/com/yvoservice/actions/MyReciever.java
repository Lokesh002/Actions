package com.example.methodchanel;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MyReciever extends BroadcastReceiver {
    MethodChannel methodChannel;
    MyReciever(MethodChannel methodChannel){
        this.methodChannel=methodChannel;
    }

    @Override
    public void onReceive(final Context context, Intent intent) {
        methodChannel.invokeMethod("I say hello every minute!!","");
    }
}
