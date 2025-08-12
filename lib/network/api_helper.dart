import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../authentication/loginscreen.dart';
import 'app_exceptions.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class ApiBaseHelper {
  final String _baseUrl = AppConstant.appBaseURL;
  final String _centerlizeBaseUrl=AppConstant.centeralizeBaseUrl;

  Future<dynamic> get(String url, BuildContext context) async {
    var responseJson;
    print(_baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(_baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getWithBase(String baseUrl,String url, BuildContext context) async {
    var responseJson;
    print(baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> getClientInfo(String url, BuildContext context) async {
    var responseJson;
    print(_baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(

          Uri.parse(_baseUrl + url),
          headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest'
      });
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> getWithToken(String baseUrl,String url,String token, String clientCode,BuildContext context) async {
    var responseJson;
    print(baseUrl+url+'  API CALLED');
    try {
      final response = await http.get(Uri.parse(baseUrl + url), headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
        'X-Requested-With':'XMLHttpRequest',
        'authtoken':token,
        'client-code':clientCode,
        'client_type':'mobile',
        'authsession':'Session $token'
      });

      print(response.body.toString());
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
     // throw FetchDataException('No Internet connection');
      var respo={'success':false,'code':200,'message':"Socket Exception or No Internet Available"};
      return respo;
    }
    return responseJson;
  }
  Future<dynamic> postAPI(String baseUrl,
      String url, var apiParams, BuildContext context) async {
    print(baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest'
          }
          );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> deleteWithHeader(String baseUrl,String url, var apiParams, BuildContext context,String token) async {
    print(baseUrl+url+'  API CALLED');
    print("Token");
    print(token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.delete(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'x-auth-token':token
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> orgHelperApi(var apiParams,BuildContext context) async {
    print("orgUrl"+AppConstant.centeralizeBaseUrl);
    var responseJson;
    try {
      final response = await http.post(Uri.parse("${_centerlizeBaseUrl}org-info-by-emp"),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postApiForLogin(String baseUrl,String url, var apiParams, BuildContext context,String password,String clientCode) async {
    print(baseUrl+url+'  API CALLED');
    print("Token");
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'password':password,
            'client_type':'mobile',
            'client-code':clientCode
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);
      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postAPIWithHeader(String baseUrl,String url, var apiParams, BuildContext context,String token,String clientCode) async {
    print(baseUrl+url+'  API CALLED');
    print("Token");
    print(token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'authtoken':token,
            'client-code':clientCode,
            'client_type':'mobile',
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postAPIWithHeaderWithoutContext(String baseUrl,String url, var apiParams,String token) async {
    print(baseUrl+url+'  API CALLED');
    print("Token");
    print(token);
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'x-auth-token':token
          }
      );
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponseWithoutContext(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  Future<dynamic> postWithAuthorization(String baseUrl,String url, var apiParams, BuildContext context,String token) async {
    print(baseUrl+url+'  API CALLED');
    print(apiParams.toString());
    var responseJson;
    try {
      final response = await http.post(Uri.parse(baseUrl + url),
          body: json.encode(apiParams),
          headers: {
            'Content-Type': 'application/json',
            'Accept':'application/json',
            'X-Requested-With':'XMLHttpRequest',
            'Authorization':token
          }
      );

      print(response.body.toString());
      var decodedJson=jsonDecode(response.body.toString());
      print(decodedJson);

      responseJson = _returnResponse(response, context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }
  dynamic _returnResponseWithoutContext(http.Response response) {
    // var responseJson = jsonDecode(response.body.toString());
    print(response.statusCode.toString() +'Status Code******* ');

    // log('api helper response $response');
    switch (response.statusCode) {
      case 200:

        return response;
      case 302:

        return response;
      case 201:

        return response;
      case 400:

        return response;
      case 404:

        return response;
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);

        return response;
      case 422:

        return response;
      case 403:

        throw UnauthorisedException(response.body.toString());
      case 500:
        return response;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  dynamic _returnResponse(http.Response response, BuildContext context) {
   // var responseJson = jsonDecode(response.body.toString());
    print(response.statusCode.toString() +'Status Code******* ');

   // log('api helper response $response');
    switch (response.statusCode) {
      case 200:
        log(response.body.toString());
        return response;
      case 302:
        print(response.body.toString());
        return response;
      case 201:
        print(response.body.toString());
        return response;
      case 400:
        print(response.body.toString());
        return response;
      case 404:
        print(response.body.toString());
        return response;
      case 401:
        Toast.show('Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        print(response.body.toString());
        return response;
      case 422:
        print(response.body.toString());
        return response;
      case 403:
        Toast.show('Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black);
        _logOut(context);
        throw UnauthorisedException(response.body.toString());
      case 500:
        return response;
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route<dynamic> route) => false);
  }
}
