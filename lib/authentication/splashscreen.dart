import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:toast/toast.dart';

import '../dashboard/user_dashboard_screen.dart';
import '../utils/app_theme.dart';
import '../utils/gradient_button.dart';
import 'loginscreen.dart';

class SplashScreen extends StatefulWidget{
  final String token;
  const SplashScreen(this.token, {super.key});
  _splashState createState()=>_splashState();
}
class _splashState extends State<SplashScreen>{

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              //color: AppTheme.bottomDisabledColor,
              color: Colors.white,
              /*image: DecorationImage(
                image: AssetImage('assets/login_bg.png'),
                fit: BoxFit.contain,
              ),*/
            ),
          ),

          Center(
            child: Container(
              height: 200,
              margin: const EdgeInsets.only(top: 30),
              child: Center(
                /*child: SvgPicture.asset(
                  'assets/app_logo.svg',
                ),*/
                child: Lottie.asset("assets/splash_loader.json"),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    redirectFun();
  }
  redirectFun() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orgDetails=prefs.getString('base_url')??'';
    String? panelRole=prefs.getString('role')??'';
    String clientCode=prefs.getString('client_code')??'';
    print("Organization Details"+orgDetails);
    bool isDevelopment=false;
    bool isMockLocation=false;
    if(Platform.isAndroid){
      try{
       // isDevelopment = await FlutterJailbreakDetection.developerMode;
        print("is Development Mode Enabled $isDevelopment");

      }on PlatformException catch(e){
        print("Platform Error ${e.message}");
      }
    }

    if(isDevelopment || isMockLocation){
      _showSettingDialog(isDevelopment, isMockLocation);
    }else{
      if(orgDetails==''){
        Timer(
            const Duration(seconds: 4),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen())));
      }
      else{
        if(widget.token!='')
        {
          print(widget.token);
          Timer(
              const Duration(seconds: 4),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => UserDashboardScreen())));
        } else {
          Timer(
              const Duration(seconds: 4),
                  () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen())));
        }
      }

    }







  }
  void _showSettingDialog(bool isDevelopment, bool isMockLocation) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text(
            "WARNING",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Lottie.asset("assets/warning_anim.json"),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "This application relies on accurate, real-time device location for essential features.\n\n"
                      "Developer Mode and Mock Location apps can interfere with proper functionality and may compromise the integrity of the app's operations.\n\n"
                      "To continue, please disable Developer Mode and uninstall or disable any Mock Location applications on your device.\n\n"
                      "How to turn off Developer Mode:\n"
                      "Settings → Search for “Developer Options” → Toggle the switch Off.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.orangeColor,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            GradientButton(
              onTap: (){
                Navigator.of(ctx).pop();
                redirectToSettings();
              },
              text: "Go To Settings",
            ),
            /*TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                redirectToSettings();
              },
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: AppTheme.themeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Go To Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  redirectToSettings(){
    AppSettings.openAppSettings(type: AppSettingsType.device);
  }

}