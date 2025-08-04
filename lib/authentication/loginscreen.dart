import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saas_glueple/widget/textfield_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../dashboard/user_dashboard_screen.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../utils/gradient_button.dart';

class LoginScreen extends StatefulWidget{
  _loginState createState()=>_loginState();
}
class _loginState extends State<LoginScreen>{
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passwordVisible=true;
  var emailId = "";
  String fcmToken="";
  bool rememberMe=false;


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true,
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top logo section
                        Stack(
                          children: [
                            const Row(
                              children: [
                                Image(
                                  image: AssetImage("assets/login_ic.png"),
                                  height: 200,
                                ),
                                Spacer(),
                              ],
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: SvgPicture.asset(
                                "assets/glueple_logo.svg",
                                width: 150,
                                height: 50,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // This pushes the login section to the bottom
                        const Spacer(),
                        // Login form starts here
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Sign in",
                                style: TextStyle(
                                  fontSize: 26.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Access your complete HR suite with one secure sign-in.",
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.login_message_gray,
                                ),
                              ),
                              const SizedBox(height: 20),
                              login_textfield_widget(
                                "Email / Employee Id",
                                "Enter Here",
                                controller: usernameController,
                                validator: checkEmptyString,
                              ),
                              const SizedBox(height: 20),
                              login_password_textfield_widget(
                                "Password",
                                "Enter Here",
                                controller: passwordController,
                                validator: null,
                              ),
                              const SizedBox(height: 20),
                              /*Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      activeColor: AppTheme.themeGreenColor,
                                      value: rememberMe,
                                      onChanged: (bool? value){
                                        setState(() {
                                          rememberMe=value??false;
                                        });
                                      },),
                                    const Text("Remember me",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Colors.black),),
                                  ],
                                ),
                              const SizedBox(height: 20,),*/
                              GradientButton(
                                text: "Continue",
                                margin: 0,
                                borderRadius: 30,
                                onTap: _submitHandler,
                              ),
                              const SizedBox(height: 20),
                             /* const SizedBox(height: 10,),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: (){},
                                  child: const Text("Forget password?",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                  ),
                                  ),
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? checkEmptyString(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);
    //if (value!.isEmpty || !regex.hasMatch(value)) {
    if (value!.isEmpty) {
      return 'Please enter Your Email or Employee Id';
    }
    return null;
  }
  bool checkPassword(String? value){
    if(value!.isEmpty){
      Toast.show("Please enter Valid Password",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate() || !checkPassword(passwordController.text)) {
      return;
    }
    _formKey.currentState!.save();
    getClientOrg();
    //
  }
  getClientOrg() async{
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, "Please wait...");
    var request={
      "username":usernameController.text
    };
    ApiBaseHelper helper= new ApiBaseHelper();
    var response = await helper.orgHelperApi(request, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if(responseJSON['success'] == true){

      if(responseJSON['data']!=null) {

        String baseUrl = responseJSON['data']['base_url'].toString();
        String orgCode = responseJSON['data']['org_code'].toString();
        String client_code = responseJSON['data']['client_code'].toString();
        String logo = responseJSON['data']['logo'].toString();
        saveOrgDetails("$baseUrl/", orgCode, logo, client_code);

      }else{
        Toast.show("The Email/Employee Id entered is invalid. Please verify and try again.",
            duration: 5,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    }else {
      Toast.show(responseJSON['errorMessage'].toString(),
          duration: 5,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  saveOrgDetails(String baseUrl,String orgCode,String orgLogo,String clientCode){
    MyUtils.saveSharedPreferences('base_url', baseUrl);
    MyUtils.saveSharedPreferences('client_code', clientCode);
    MyUtils.saveSharedPreferences('org_code', orgCode);
    MyUtils.saveSharedPreferences('client_logo', orgLogo);
    loginUser();
  }
  loginUser() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Please Wait...');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl=prefs.getString('base_url')??'';
    String clientCode=prefs.getString('client_code')??'';
    print(baseUrl);

    var requestModel = {
      "email": usernameController.text,
    };

    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();

    var response = await helper.postApiForLogin(baseUrl,'login', requestModel, context,passwordController.text);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      String token=responseJSON['data']['token'].toString();
      String id=responseJSON['data']['user']['id'].toString();
      String email=responseJSON['data']['user']['email'].toString();
      String designation_id=responseJSON['data']['user']['designation_id'].toString();
      String department_id=responseJSON['data']['user']['department_id'].toString();
      String employee_reporting_manager=responseJSON['data']['user']['reported_to']??'';
      String name=responseJSON['data']['user']['name'].toString();
      String role_id=responseJSON['data']['user']['role_id'].toString();
      String emp_id=responseJSON['data']['user']['emp_id'].toString();

      MyUtils.saveSharedPreferences("user_id", id);
      MyUtils.saveSharedPreferences("email", email);
      MyUtils.saveSharedPreferences("emailId", usernameController.text);
      MyUtils.saveSharedPreferences("designation_id", designation_id);
      MyUtils.saveSharedPreferences("department_id", department_id);
      MyUtils.saveSharedPreferences("manager", employee_reporting_manager);
      MyUtils.saveSharedPreferences("role", role_id);
      MyUtils.saveSharedPreferences("full_name", name);
      MyUtils.saveSharedPreferences("token", token);
      MyUtils.saveSharedPreferences("emp_id", emp_id);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => UserDashboardScreen()),
              (Route<dynamic> route) => false);
    } else {
            Toast.show(responseJSON['errorMessage'].toString(),
                duration: 5,
                gravity: Toast.bottom,
                backgroundColor: Colors.red);
          }
  }


}