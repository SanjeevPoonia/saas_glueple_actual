import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:video_player/video_player.dart';
import '../dashboard/user_dashboard_screen.dart';
import '../utils/app_theme.dart';
import 'dart:io';

import '../utils/gradient_button.dart';
import 'loginscreen.dart';

class AppSplashScreen extends StatefulWidget{
  final String token;
  AppSplashScreen(this.token);
  _appSplashState createState()=> _appSplashState();
}
class _appSplashState extends State<AppSplashScreen>{
  late VideoPlayerController _controller;
  VideoPlayerOptions videoPlayerOptions = VideoPlayerOptions(mixWithOthers: true);
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              AppTheme.themeGreenColor, // Start (corner)
              AppTheme.loginBackPink,   // Blend starts
              AppTheme.loginBackPink,   // Stays pink longer
              AppTheme.themeGreenColor, // End (corner)
            ],
            stops: [0.0, 0.2, 0.8, 1.0], // Control gradient transition
          ),
        ),
        child:Stack(
          children: [
            // Centered Video Player
            if (_controller.value.isInitialized)
              Center(

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 175,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            // Bottom-positioned SVG
            Positioned(
              bottom: 24, // Add some padding from bottom
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: SvgPicture.asset(
                    "assets/powered_by.svg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash_video.mp4',
        videoPlayerOptions: videoPlayerOptions)
      ..initialize().then((_) {
        _controller.addListener(() async {
          if (_controller.value.position == _controller.value.duration) {
          }
        });
        _controller.play();
        setState(() {});
      });
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
                    color: AppTheme.themeGreenColor,
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
