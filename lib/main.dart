import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:saas_glueple/utils/app_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/splashscreen.dart';

void main()async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString('token')??'';
  print(token);
  if(token!='')
  {
    AppModel.setTokenValue(token.toString());
    AppModel.setLoginToken(true);
  }

  runApp(MyApp(token));
}

class MyApp extends StatelessWidget {

  final String token;

  MyApp(this.token, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Glueple',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            fontFamily: 'Acumin'
        ),
        home:SplashScreen(token)
    );
  }

}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
