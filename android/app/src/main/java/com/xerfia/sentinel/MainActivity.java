package com.xerfia.sentinel;


import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.VpnService;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.util.Log;
import android.view.MenuItem;
import android.widget.Toast;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {



    private static final String CHANNEL = "com.xerfia.sentinel/sentinel";
    private static final String TAG = "Firewall.Main";

    private boolean running = true;

    private MenuItem searchItem;
    private static final int REQUEST_VPN = 1;
    public interface AsyncResponse {
        void processFinish(Object output);
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    private void reset(String network) {
        SharedPreferences other = getSharedPreferences(network, Context.MODE_PRIVATE);
        SharedPreferences.Editor edit = other.edit();
        for (String key : other.getAll().keySet())
            edit.remove(key);
        edit.apply();

        SinkService.reload(network, MainActivity.this);
    }

    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.i(TAG, "Create");


        GeneratedPluginRegistrant.registerWith(this);
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);

        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @SuppressLint("StaticFieldLeak")
            @TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                running = true;
                if (methodCall.method.equals("first")) {

                    result.success("connection to native successful");
                }
                if (methodCall.method.equals("Printy")) {

                    result.success("connection to native successful");
                }
                if (methodCall.method.equals("connectVPN")) {
                    Boolean isChecked = true;
                    if (isChecked) {
                        Log.i(TAG, "Switch on");
                        Intent prepare = VpnService.prepare(MainActivity.this);
                        if (prepare == null) {
                            Log.e(TAG, "Prepare done");
                            onActivityResult(REQUEST_VPN, RESULT_OK, null);
                        } else {
                            Log.i(TAG, "Start intent=" + prepare);
                            try {
                                startActivityForResult(prepare, REQUEST_VPN);
                            } catch (Throwable ex) {
                                Log.e(TAG, ex.toString() + "\n" + Log.getStackTraceString(ex));
                                onActivityResult(REQUEST_VPN, RESULT_CANCELED, null);
                                Toast.makeText(MainActivity.this, ex.toString(), Toast.LENGTH_LONG).show();
                            }
                        }
                    } else {
                        Log.i(TAG, "Switch off");
                        prefs.edit().putBoolean("enabled", false).apply();
                        SinkService.stop(MainActivity.this);
                    }
                }
                if(methodCall.method.equals("whitelist")){
                    String iface = methodCall.argument("iface");
                    Boolean status = Boolean.parseBoolean(methodCall.argument("status"));
//                    "whitelist_wifi
                    Log.e(TAG,iface);
                    Log.e(TAG,status.toString());
                    SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(MainActivity.this);
                    prefs.edit().putBoolean("whitelist_"+iface, status).apply();
                    SinkService.reload(iface,MainActivity.this);
                }
                if (methodCall.method.equals("search")) {

                    Log.e(TAG,"yo");
                    new AsyncTask<Object, Object, List<Rule>>() {
                        public AsyncResponse delegate = null;

                        @Override
                        protected List<Rule> doInBackground(Object... arg) {
                            return Rule.getRules(MainActivity.this);
                        }

                        @Override
                        protected void onPostExecute(List<Rule> result) {
                            Log.e(TAG,"insideexcute");
                            if (running) {
                                Log.e(TAG,"insiderunn");
                                if (searchItem != null)
                                    Log.e(TAG,"insideSeach");
                                Log.e(TAG,result.toString());
                                for(Rule rule : result){
                                    Log.e(TAG,rule.info.packageName);
                                    rule.wifi_blocked = true;
                                    SharedPreferences prefs = MainActivity.this.getSharedPreferences("wifi", Context.MODE_PRIVATE);
                                    prefs.edit().putBoolean(rule.info.packageName, true).apply();
                                    SinkService.reload("wifi",MainActivity.this);

                                }

                            }

                        }

                    }.execute();


                }
                if (methodCall.method.equals("reset_rules")) {

                    String iface = methodCall.argument("iface");
                    reset(iface);
                }
                if (methodCall.method.equals("disconnectVPN")) {
                    SinkService.stop(MainActivity.this);
                }
                if (methodCall.method.equals("blockBrowser")) {

                    Log.e(TAG,"blockBROWSER");
                    new AsyncTask<Object, Object, List<Rule>>() {
                        public AsyncResponse delegate = null;

                        @Override
                        protected List<Rule> doInBackground(Object... arg) {
                            return Rule.getRules(MainActivity.this);
                        }

                        @Override
                        protected void onPostExecute(List<Rule> R) {
                            Log.e(TAG,"insideexcute");
                            if (running) {

                                ArrayList<String> pkgNames=new ArrayList<String>();
                                String temp;
                                for(Rule rule : R){


                                    temp = rule.name+"::"+rule.info.packageName;
                                    pkgNames.add(temp);
                                }

                                result.success(pkgNames);
//
//                                    if(rule.info.packageName.equals("com.android.browser")){
//                                        Log.e(TAG,rule.info.packageName);
//                                    rule.wifi_blocked = false;
//                                    SharedPreferences prefs = MainActivity.this.getSharedPreferences("wifi", Context.MODE_PRIVATE);
//                                    prefs.edit().putBoolean(rule.info.packageName, false).apply();
//                                    }
//
//                                }

                            }
                        }
                    }.execute();



                }
                if (methodCall.method.equals("setRuleReload")) {
                    String pkgname = methodCall.argument("pkgname");
                    String nwkType = methodCall.argument("nwktype");

                    Boolean rule_bool = !Boolean.parseBoolean(methodCall.argument("rule"));


                    Log.e(TAG,rule_bool.toString());
                    new AsyncTask<Object, Object, List<Rule>>() {
                        public AsyncResponse delegate = null;

                        @Override
                        protected List<Rule> doInBackground(Object... arg) {
                            return Rule.getRules(MainActivity.this);
                        }

                        @Override
                        protected void onPostExecute(List<Rule> R) {
                            Log.e(TAG,"insideexcute");
                            if (running) {

                                ArrayList<String> pkgNames=new ArrayList<String>();
                                String temp;
                                SharedPreferences prefs = MainActivity.this.getSharedPreferences(nwkType, Context.MODE_PRIVATE);
                                prefs.edit().putBoolean(pkgname, rule_bool).apply();
                                SinkService.reload(nwkType,MainActivity.this);





                            }
                        }
                    }.execute();



                }if(methodCall.method.equals("cacheClean")){
                    File[] files = getBaseContext().getCacheDir().listFiles();

                    for (File file : files) {
                        file.delete();
                    }

                }



            }
        });

    }
    @TargetApi(Build.VERSION_CODES.GINGERBREAD)
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_VPN) {
            // Update enabled state
            SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
            prefs.edit().putBoolean("enabled", resultCode == RESULT_OK).apply();

            // Start service
            if (resultCode == RESULT_OK)
                SinkService.start(this);

        } else
            super.onActivityResult(requestCode, resultCode, data);
    }

}