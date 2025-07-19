
import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class APIDialog
{
  static Future<void> showAlertDialog(BuildContext context,String dialogText) async {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.themeGreenColor),
          ),
          Expanded(child: Container(margin: const EdgeInsets.only(left: 9,), child: Text(dialogText,maxLines:2,style: const TextStyle(color:Colors.blueGrey,fontFamily: 'OpenSans',fontSize: 12),)),),

        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


}






