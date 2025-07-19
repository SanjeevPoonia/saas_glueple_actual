import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class login_textfield_widget extends StatelessWidget{
  final String title;
  final String hintText;
  var controller;
  final String? Function(String?)? validator;
  login_textfield_widget(this.title,this.hintText,{this.validator,this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  //color: Colors.black
                  color: Colors.black
              )),
        ),


        const SizedBox(height: 7),



        Container(
          // height: 56,
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: TextFormField(
            validator: validator!=null?validator:null,
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFD8D8D8),

                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFD8D8D8),

                ),
              ),


              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: AppTheme.themeGreenColor,

                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Color(0xFF9D9CA0),fontSize: 13),
              hintText: hintText,
              fillColor: Colors.white,
            ),
          ),
        ),



      ],
    );
  }
}

class login_password_textfield_widget extends StatelessWidget{
  final String title;
  final String hintText;
  var controller;
  final String? Function(String?)? validator;
  login_password_textfield_widget(this.title,this.hintText,{this.validator,this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(title,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  //color: Colors.black
                  color: Colors.black
              )),
        ),


        const SizedBox(height: 7),



        Container(
          // height: 56,
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: TextFormField(
            validator: validator!=null?validator:null,
            controller: controller,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFD8D8D8),

                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFD8D8D8),

                ),
              ),


              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide(
                  width: 1,
                  color: AppTheme.themeGreenColor,

                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Color(0xFF9D9CA0),fontSize: 13),
              hintText: hintText,
              fillColor: Colors.white,
            ),
          ),
        ),



      ],
    );
  }
}