
class AppModel{


  static bool isLogin=false;
  static Map<String,dynamic> groupData={};
  static String token='';


  static bool setLoginToken(bool value)
  {
    isLogin=value;
    return isLogin;
  }
  static String setTokenValue(String value)
  {
    token=value;
    return token;
  }

  static Map<String,dynamic> setGroupData(Map<String,dynamic> data)
  {
    groupData=data;
    return groupData;
  }

}
