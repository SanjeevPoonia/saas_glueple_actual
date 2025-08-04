import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_svg/svg.dart';


//import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saas_glueple/attendance/attendancehome.dart';
import 'package:saas_glueple/attendance/capture_image_from_camera.dart';
import 'package:saas_glueple/authentication/logout_functionality.dart';
import 'package:saas_glueple/dashboard/holiday_screen.dart';
import 'package:saas_glueple/dashboard/profile_screen.dart';
import 'package:saas_glueple/leave_management/leave_management_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';




import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/loader.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../utils/app_theme.dart';
import '../utils/gradient_button.dart';
import '../widget/dotted_divider.dart';

/*import '../qd_attendance/QD_Requested_Correction_Screen.dart';
import '../task_manegment/alltask_screen.dart';
import '../ticket_management/createticket_screen.dart';
import '../views/AttendanceApprovalScreen.dart';
import '../views/MarkAttendanceScreen.dart';
import '../views/applyleave_screen_ub.dart';
import '../views/attendance_details_screen.dart';
import '../views/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/firebase/message.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';*/

class UserDashboardScreen extends StatefulWidget{
  _userDashboardScreen createState()=>_userDashboardScreen();
}
class _userDashboardScreen extends State<UserDashboardScreen>{
  var userIdStr="";
  var designationStr="";
  var token="";
  var fullNameStr="";
  var empId="";
  var baseUrl="";
  var clientCode="";
  var platform="";
  var isAttendanceAccess="1";
  var firstName="";
  var userProfile="";

  String notiStr="Your attendance correction of 14 july 2025 will get locked by today.";
  bool isNotiLoading=false;

  String dayStr="";
  String mnthStr="";
  String dateStr="";
  String timeStr="";
  String monthStr="";

  var userShowProfile="";
  String logedInHour="00";
  String logedInMinute="00";
  String logedInSec="00";

  bool showCheckIn=true;

  List<String> titleList = [
    "Birthday\nToday",
    "Anniversary\nToday",
    "New\nJoinee",
    "Kudos",
    "Write a Post"
  ];
  List<String> descriptionList = [
    "No One have birthday today",
    "No One have anniversary today",
    "No One have Joined today",
    "No One received KUDOS today",
    "Share your thoughts, give wishes and know about your colleagues"
  ];

  late PageController _pageController;
  int activePage = 0;

  bool attStatus=false;
  bool leaveBalanceStatus=false;
  bool teamLeaveStatus=false;

  String attDate="";
  String inTime="-";
  String outTime="-";
  String breakTime="-";
  String shiftStartTime="";
  String shiftEndTime="";

  Timer? countdownTimer;
  Duration? myDuration;

  String plBalance="0";
  String compBalance="0";
  String clBalance="0";


  String team1ImageLeave="";
  String team2ImageLeave="";
  String remainingTeamLeave="";
  bool isTeamOnLeave=false;
  int totalTeamLeangth=0;
  List<dynamic>teamLeaveList=[];



  var currentVersionCode="";
  var currentVersionName="";

  Position? _currentPosition;
  List<dynamic> locationList=[];
  int locationRadius=101;

  XFile? capturedImage;
  File? capturedFile;
  XFile? imageFile;
  File? file;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableLandmarks: true,
    ),
  );

  bool communityLoading=false;
  List<dynamic> birthdayList=[];
  List<dynamic> anniversaryList=[];
  List<dynamic> newJoineeList=[];
  List<dynamic> kudosList=[];

  bool ticketLoading=false;
  String assignedTicketCount="0";
  String pendingTicketCount="0";
  String myTicketCount="0";


  bool showMyTeam=false;
  int myTeamCount=0;
  int totalPresentCount=0;
  int totalAbsentCount=0;
  int unplannedLeaveCount=0;
  int plannedLeaveCount=0;

  bool isTaskBoxLoading=false;
  String leaveCount="0";
  String tourCount="0";
  String cOffCount="0";
  String correctionCount="0";
  String mrfCount="0";

  String leaveType="";
  String tourType="";
  String compOffType="";
  String correctionType="";
  String mrfType="";

  bool analysisLoading=false;
  String presentDaysCount="0";
  String absentDaysCount="0";
  String correctionDaysCount="0";
  String leaveDaysCount="0";
  String totalLeaveBalance="0";
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return MaterialApp(
      theme: ThemeData(fontFamily: "RobotoFlex"),
      home: Scaffold(
        body: Column(
          children: [
            Expanded(child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 0),
                  decoration: const BoxDecoration(
                      color: AppTheme.dashboard_back_pink
                  ),
                ),
                ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    Container(
                      color: Colors.black,
                      height: 50,
                    ),

                    //Correction Notification
                    isNotiLoading?
                    Center(child: Loader(),):
                    notiStr.isNotEmpty?
                    Container(
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: AppTheme.qdNotiBack,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(right: 5,left: 5,top: 8),
                        child: Marquee(
                          text: notiStr,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20,
                          velocity: 60,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10,
                          accelerationDuration: Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      ),
                    )
                        :
                    Container(),

                    //Attendance Card
                    Container(
                      margin: EdgeInsets.only(bottom: 40),
                      height: 450,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                          gradient: LinearGradient(
                            colors: const [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
                            begin: alignmentFromAngle(137),
                            end: alignmentFromAngle(317),
                          )
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()),);
                                  },
                                  child:  userShowProfile==""?
                                  const CircleAvatar(
                                    backgroundImage: AssetImage("assets/profile.png"),
                                    radius: 30,)
                                      :
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(60.0),
                                    child: CachedNetworkImage(
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      imageUrl: userShowProfile,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => Image.asset("assets/profile.png"),
                                    ),
                                    //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                  ),
                                ),

                                const SizedBox(width: 10,),
                                Expanded(flex: 1,child: InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()),);
                                  },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [

                                        RichText(
                                          text: TextSpan(
                                              text: 'Hi,',
                                              style: const TextStyle(
                                                  fontSize: 17.5,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: firstName,
                                                  style: const TextStyle(
                                                      fontSize: 17.5,
                                                      fontWeight: FontWeight.w900,
                                                      color: Colors.white
                                                  ),
                                                ),

                                              ]
                                          ),
                                        ),
                                        const SizedBox(height: 5,),
                                        Text(empId,style: const TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white
                                        ),)
                                      ],
                                    ),
                                ),),
                                const SizedBox(width: 10,),


                                IconButton(
                                  onPressed: () {
                                    showLogoutConfirmation(context, () { LogoutUserFromApp.logOut(context);});
                                  },
                                  icon: const Icon(
                                    Icons.logout,                                      color: Colors.white, // optional
                                    size: 24.0,        // optional
                                  ),
                                  tooltip: 'Logout', // optional, shows a tooltip on long press
                                ),
                                /*InkWell(
                                  onTap: (){
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()),);

                                  },
                                  child: SvgPicture.asset("assets/ic_noti.svg",width: 30,height: 30,),

                                ),
                                const SizedBox(width: 7,),
                                InkWell(
                                  onTap: (){
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen()),);
                                  },
                                  child: SvgPicture.asset("assets/ic_menu.svg",width: 30,height: 30,),

                                ),*/
                                const SizedBox(width: 10,),

                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                            height: 270,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: attStatus?Center(child: Loader(),):Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(dayStr,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black),),
                                          Text(mnthStr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Expanded(flex:1,child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Date and Time",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 14,color: AppTheme.dashborad_gray),),
                                        Text(timeStr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20,color: Colors.black),),
                                      ],
                                    )),
                                    const SizedBox(width: 5,),
                                    SvgPicture.asset(getImageForTime(),width: 50,height: 50,)
                                  ],
                                ),
                                const SizedBox(height: 20,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 53,
                                      height: 53,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        //border: Border.all(color: Colors.grey,),
                                        color: AppTheme.themeBlueColor.withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Text(logedInHour,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 53,
                                      height: 53,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        //border: Border.all(color: Colors.grey,),
                                        color: AppTheme.themeBlueColor.withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Text(logedInMinute,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 53,
                                      height: 53,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        //border: Border.all(color: Colors.grey,),
                                        color: AppTheme.themeBlueColor.withOpacity(0.20),
                                      ),
                                      child: Center(
                                        child: Text(logedInSec,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 28,
                                                color: Colors.black)),
                                      ),
                                    ),
                                    const SizedBox(width: 10,),
                                    const Text("HRS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900,color: AppTheme.dashborad_gray_hours),),

                                  ],
                                ),
                                const SizedBox(height: 20,),
                                isAttendanceAccess=="1"?
                                InkWell(
                                  onTap: (){
                                     _checkDeveloperOption();
                                  },
                                  child: Container(
                                    width: 180,
                                    height: 49,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: const [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
                                          begin: alignmentFromAngle(137),
                                          end: alignmentFromAngle(317),
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.play_arrow, color: Colors.white),
                                        SizedBox(width: 9),
                                        Text(showCheckIn==true?"Punch In":"Punch Out",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ):Container(),
                                const SizedBox(height: 20,),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Your Shift Time ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12.5,
                                            color: AppTheme.dashborad_gray_hours
                                        ),
                                        children: [
                                          TextSpan(
                                            text: shiftStartTime,
                                            style: const TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.themeBlueColor
                                            ),
                                          ),
                                          TextSpan(
                                            text: " to ",
                                            style: const TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w300,
                                                color: AppTheme.themeBlueColor
                                            ),
                                          ),
                                          TextSpan(
                                            text: shiftEndTime,
                                            style: const TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w900,
                                                color: AppTheme.themeBlueColor
                                            ),
                                          ),
                                        ]
                                    ),
                                  ),
                                ),

                              ],
                            ),


                          ),
                          Transform.translate(offset: const Offset(0,40),
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("In Time",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: AppTheme.dashborad_gray_hours),),
                                      Text(inTime,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeBlueColor),),
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Out Time",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: AppTheme.dashborad_gray_hours),),
                                      Text(outTime,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeBlueColor),),
                                    ],
                                  )),
                                  Expanded(child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Break",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: AppTheme.dashborad_gray_hours),),
                                      Text(breakTime,style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: AppTheme.themeBlueColor),),
                                    ],
                                  ))
                                ],
                              ),

                            ),)
                        ],
                      ),
                    ),

                    
                   

                    const SizedBox(height: 20,),

                    // Attendance Analysis Card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: Text(
                                "Attendance Analysis",
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14.5,
                                    color: Colors.black
                                ),
                              ),flex: 1,),
                              Text(monthStr, style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black
                              ),)
                            ],
                          ),
                          SizedBox(height: 20,),
                          analysisLoading?
                          Center(child: Loader(),):
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AttendanceHomeScreen()),).then((value) => getAttendanceCardDetails());
                            },
                            child: Row(children: [
                              Expanded(child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.themeGreenColor.withOpacity(0.10),
                                    shape: BoxShape.rectangle
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF1F56AE).withOpacity(0.19),
                                          shape: BoxShape.circle
                                      ),
                                      height: 65,
                                      width: 65,
                                      child: Center(
                                        child: Text(presentDaysCount,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19.5,
                                                color: Color(0xFF1F56AE))),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Present",style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              )),
                              SizedBox(width: 5,),
                              Expanded(child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.themeGreenColor.withOpacity(0.10),
                                    shape: BoxShape.rectangle
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFAE1F1F).withOpacity(0.19),
                                          shape: BoxShape.circle

                                      ),
                                      height: 65,
                                      width: 65,
                                      child: Center(

                                        child: Text(absentDaysCount,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19.5,
                                                color: Color(0xFFFB1F1F))),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Absent",style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              )),
                              SizedBox(width: 5,),
                              Expanded(child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.themeGreenColor.withOpacity(0.10),
                                    shape: BoxShape.rectangle
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFFF2A20B).withOpacity(0.19),
                                          shape: BoxShape.circle
                                      ),
                                      height: 65,
                                      width: 65,
                                      child: Center(
                                        child: Text(correctionDaysCount,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19.5,
                                                color: Color(0xFFF2A20B))),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Correction",style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              )),
                              SizedBox(width: 5,),
                              Expanded(child: Container(
                                padding: EdgeInsets.all(5),

                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppTheme.themeGreenColor.withOpacity(0.10),
                                    shape: BoxShape.rectangle
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10,),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0xFF13E0B0).withOpacity(0.19),
                                          shape: BoxShape.circle

                                      ),
                                      height: 65,
                                      width: 65,
                                      child: Center(

                                        child: Text(leaveDaysCount,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 19.5,
                                                color: Color(0xFF13E0B0))),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Leave",style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black
                                    ),),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ))

                            ],),
                          )

                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),

                    //Apply for Leaves card
                    Container(
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              InkWell(

                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveManagementScreen()),);
                                  /*clientCode=="MH100"?
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MhApplyLeaveScreen()),):
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ApplyLeave_Screen_UB()),);*/

                                },
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Apply for leaves",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 14.5,
                                              color: Colors.black
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        leaveBalanceStatus?
                                        Center(child: Loader(),):
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Text("Available Leaves",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black)
                                                ),
                                                const SizedBox(width: 10),
                                                Text(totalLeaveBalance,
                                                    style: const TextStyle(
                                                        fontSize: 26, color: AppTheme.themeBlueColor)),
                                                const SizedBox(width: 5),
                                                const Text("Days",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: Color(0xFF707070))),

                                                /*SizedBox(width: 25),
                                                Text(compBalance,
                                                    style: TextStyle(
                                                        fontSize: 26, color: Colors.black)),
                                                SizedBox(width: 3),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Comp. Off",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            height: 1,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black)),
                                                    Text("Days",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF707070))),
                                                  ],
                                                ),*/
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                           /* Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(clBalance,
                                                    style: TextStyle(
                                                        fontSize: 26, color: Colors.black)),
                                                SizedBox(width: 3),
                                                Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Casual Leave",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            height: 1,
                                                            fontWeight: FontWeight.w500,
                                                            color: Colors.black)),
                                                    Text("Days",
                                                        style: TextStyle(
                                                            fontSize: 11,
                                                            fontWeight: FontWeight.w500,
                                                            color: Color(0xFF707070))),
                                                  ],
                                                ),
                                              ],
                                            ),*/
                                          ],
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      height: 135,
                                      width: 100,
                                      child: OverflowBox(
                                        minHeight: 135,
                                        maxHeight: 164,
                                        child: Icon(Icons.arrow_circle_right_sharp,color: AppTheme.themeGreenColor,size: 42,),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              // Teams on Leave
                             /* Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: AppTheme.themeBlueColor.withOpacity(0.20),
                                    borderRadius: const BorderRadius.all(Radius.circular(4))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Today Team Leaves",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14.5,
                                            color: Colors.black)),
                                    SizedBox(height: 5),
                                    Container(
                                        height: 66,
                                        padding: EdgeInsets.all(8),
                                        child: teamLeaveStatus?
                                        Center(child: Loader(),):
                                        isTeamOnLeave?
                                        Row(
                                          children: [
                                            totalTeamLeangth==1?
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(width: 1,color: Colors.white),
                                              ),
                                              child: team1ImageLeave==""?
                                              const CircleAvatar(
                                                backgroundImage: AssetImage("assets/profile.png"),
                                                radius: 15,)
                                                  :
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(50.0),
                                                child: CachedNetworkImage(
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  imageUrl: team1ImageLeave,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      CircularProgressIndicator(value: downloadProgress.progress),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                                //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                              ),
                                            ):
                                            Row(children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(width: 1,color: Colors.white),
                                                ),
                                                child: team1ImageLeave==""?
                                                const CircleAvatar(
                                                  backgroundImage: AssetImage("assets/profile.png"),
                                                  radius: 15,)
                                                    :
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  child: CachedNetworkImage(
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    imageUrl: team1ImageLeave,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                        CircularProgressIndicator(value: downloadProgress.progress),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  ),
                                                  //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                                ),
                                              ),
                                              Container(
                                                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(width: 1,color: Colors.white),
                                                ),
                                                child: team2ImageLeave==""?
                                                const CircleAvatar(
                                                  backgroundImage: AssetImage("assets/profile.png"),
                                                  radius: 15,)
                                                    :
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(50.0),
                                                  child: CachedNetworkImage(
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                    imageUrl: team2ImageLeave,
                                                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                        CircularProgressIndicator(value: downloadProgress.progress),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  ),
                                                  //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                                ),
                                              ),
                                            ],),
                                            Padding(
                                              padding: EdgeInsets.only(left: 0),
                                              child: Text(remainingTeamLeave,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14,
                                                      color: Colors.black)),
                                            ),
                                            const Spacer(),
                                            InkWell(
                                              onTap: (){
                                                //_showTeamLeaveAlertNew(context);
                                              },
                                                child: Container(
                                                  height: 45,
                                                  width: 130,
                                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    gradient: const LinearGradient(
                                                      colors: [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
                                                      begin: Alignment.topLeft,
                                                      end: Alignment.bottomRight,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: const Text(
                                                    "View Details",
                                                    style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                            ),


                                          ],
                                        ):
                                        const Center(child: Text("No one is on Leave today",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: AppTheme.themeGreenColor),),)

                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),*/
                            ],
                          ),
                    ),
                    const SizedBox(height: 20,),

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HolidayScreen()));
                      },
                      child: Container(
                          margin: EdgeInsets.all(10.0),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6.0,
                                ),
                              ],
                              color: const Color(0XFFD1E6ED)

                            /*image: DecorationImage(
              fit: BoxFit.cover, image: CachedNetworkImageProvider(images[pagePosition]))*/
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 3),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text("Holiday List",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 18,
                                                  height: 1.2,
                                                  color: Colors.black))),
                                      SizedBox(height: 3),
                                      Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Text("",
                                              style:
                                              TextStyle(fontSize: 15, color: AppTheme.themeBlueColor))),
                                      SizedBox(height: 3),
                                      Container(
                                        width: 125,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: const [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
                                              begin: alignmentFromAngle(137),
                                              end: alignmentFromAngle(317),
                                            ),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("View Details",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                height: 110,
                                width: 100,
                                child: OverflowBox(
                                  minHeight: 180,
                                  maxHeight: 180,
                                  child: Lottie.asset("assets/holiday.json"),
                                ),
                              ),
                            ],
                          )),
                    ),



                    // Taskbox
                    //My Team Card
                    /*showMyTeam?
                    Column(
                      children: [
                        // Taskbox
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF8F8F8),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text(
                                    "My Task Box",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14.5,
                                        color: Colors.black
                                    ),
                                  ),flex: 1,),
                                  Text(monthStr, style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black
                                  ),)
                                ],
                              ),
                              SizedBox(height: 20,),
                              isTaskBoxLoading?
                              Center(child: Loader(),): Column(
                                children: [
                                  InkWell(
                                    onTap:(){
                                     // navigateScreen(leaveType);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color(0xFFFFFFFF),
                                        boxShadow: const <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.0,
                                        ),],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/ic_task1.png",width: 36,height: 36,),
                                          const SizedBox(width:10),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  leaveCount=="0"?
                                                  Text("Leave Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),):
                                                  Text("$leaveCount Leave Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),),
                                                  SizedBox(height: 5,),
                                                  leaveCount=="0"?
                                                  Text("No Data",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: Colors.grey),):
                                                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: AppTheme.orangeColor),),
                                                ],
                                              )),

                                        ],
                                      ),

                                    ),
                                  ),

                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap:(){
                                     // navigateScreen(correctionType);
                                    },
                                    child:Container(
                                      margin: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color(0xFFFFFFFF),
                                        boxShadow: const <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.0,
                                        ),],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/ic_task2.png",width: 36,height: 36,),
                                          const SizedBox(width:10),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  correctionCount=="0"?
                                                  Text("Attendance Correction",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),):
                                                  Text("$correctionCount Attendance Correction",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),),
                                                  SizedBox(height: 5,),
                                                  correctionCount=="0"?
                                                  Text("No Data",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: Colors.grey),):
                                                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: AppTheme.orangeColor),),


                                                ],
                                              )),

                                        ],
                                      ),

                                    ),

                                  ),

                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap:(){
                                     // navigateScreen(mrfType);
                                    },
                                    child:Container(
                                      margin: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color(0xFFFFFFFF),
                                        boxShadow: const <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.0,
                                        ),],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/ic_task3.png",width: 36,height: 36,),
                                          const SizedBox(width:10),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  mrfCount=="0"?
                                                  Text("MRF Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),):
                                                  Text("$mrfCount MRF Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),),
                                                  SizedBox(height: 5,),
                                                  mrfCount=="0"?
                                                  Text("No Data",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: Colors.grey),):
                                                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: AppTheme.orangeColor),),
                                                ],
                                              )),

                                        ],
                                      ),

                                    ),

                                  ),

                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap:(){
                                      //navigateScreen(tourType);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color(0xFFFFFFFF),
                                        boxShadow: const <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.0,
                                        ),],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/ic_task5.png",width: 36,height: 36,),
                                          const SizedBox(width:10),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  tourCount=="0"?
                                                  Text("Tour Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),):
                                                  Text("$tourCount Tour Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),),
                                                  SizedBox(height: 5,),
                                                  tourCount=="0"?
                                                  Text("No Data",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: Colors.grey),):
                                                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: AppTheme.orangeColor),),

                                                ],
                                              )),

                                        ],
                                      ),

                                    ),

                                  ),

                                  SizedBox(height: 10,),
                                  InkWell(
                                    onTap:(){
                                      //navigateScreen(compOffType);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 7,right: 7,bottom: 7),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: const Color(0xFFFFFFFF),
                                        boxShadow: const <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 1.0,
                                        ),],
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/ic_task4.png",width: 36,height: 36,),
                                          const SizedBox(width:10),
                                          Expanded(
                                              flex: 1,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  cOffCount=="0"?
                                                  Text("Comp-Off Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),):
                                                  Text("$cOffCount Comp-Off Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 14.5,color: Colors.black),),
                                                  SizedBox(height: 5,),
                                                  cOffCount=="0"?
                                                  Text("No Data",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: Colors.grey),):
                                                  Text("Pending",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 12.5,color: AppTheme.orangeColor),),
                                                ],
                                              )),

                                        ],
                                      ),

                                    ),

                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),

                        //My Team Card
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 7),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(0xFFF8F8F8),
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(child: Text(
                                  "My Team",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14.5,
                                      color: Colors.black
                                  ),
                                ),flex: 1,),
                                InkWell(
                                    onTap: (){
                                    //  Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child:const Text("View More", style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black
                                    ),)
                                )
                              ],),
                              SizedBox(height: 20,),
                              Row(
                                children: [
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/ic_team1.png",width: 36,height: 36,),
                                                Spacer(),
                                                Text("$myTeamCount", style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF707070),
                                                    fontSize: 30.5
                                                ),),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("My Team",style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),),
                                          ]
                                      ),
                                    ),
                                  )),
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/ic_team2.png",width: 36,height: 36,),
                                                Spacer(),
                                                Text("$totalPresentCount", style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF707070),
                                                    fontSize: 30.5
                                                ),),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("Total Present",style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),),
                                          ]
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/ic_team3.png",width: 36,height: 36,),
                                                Spacer(),
                                                Text("$totalAbsentCount", style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF707070),
                                                    fontSize: 30.5
                                                ),),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("Total Absent",style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),),
                                          ]
                                      ),
                                    ),
                                  )),
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/ic_team4.png",width: 36,height: 36,),
                                                Spacer(),
                                                Text("$unplannedLeaveCount", style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF707070),
                                                    fontSize: 30.5
                                                ),),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("Unplanned Leave",style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),),
                                          ]
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                children: [
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(
                                      height: 90,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset("assets/ic_team5.png",width: 36,height: 36,),
                                                Spacer(),
                                                Text("$plannedLeaveCount", style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    color: Color(0xFF707070),
                                                    fontSize: 30.5
                                                ),),
                                                SizedBox(height: 5,),
                                              ],
                                            ),
                                            const SizedBox(height: 5,),
                                            Text("Planned Leave",style: TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black
                                            ),),
                                          ]
                                      ),
                                    ),
                                  )),
                                  SizedBox(width: 15,),
                                  Expanded(child: InkWell(
                                    onTap: (){
                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTeamAttendance()),);
                                    },
                                    child: Container(),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20,),
                      ],
                    ):Container(),

                    //Ticket Management card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Row(children: [
                            const Expanded(child: Text(
                              "Ticket Management",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                  color: Colors.black
                              ),
                            ),flex: 1,),
                            InkWell(
                              onTap: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTicketManagmentScreen()),);
                              },
                              child:const Text("View More", style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),) ,
                            ),
                          ],),
                          const SizedBox(height: 20,),

                          ticketLoading?
                          Center(child: Loader(),):
                          InkWell(
                            onTap: (){
                             // Navigator.push(context, MaterialPageRoute(builder: (context) => QDTicketManagmentScreen()),);
                            },
                            child: Row(
                              children: [
                                Expanded(child: Container(
                                  height: 100,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.withOpacity(0.10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("$assignedTicketCount", style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF8588A8),
                                          fontSize: 24.5
                                      ),),
                                      const SizedBox(height: 5,),
                                      const Text("Assigned Tickets", style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 14.5
                                      ),),
                                      const SizedBox(height: 5,),
                                    ],
                                  ),
                                )),
                                const SizedBox(width: 10,),
                                Expanded(child: Container(
                                  height: 100,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.withOpacity(0.10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("$pendingTicketCount", style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFFF9B115),
                                          fontSize: 24.5
                                      ),),
                                      const SizedBox(height: 5,),

                                      const Text("Pending Tickets", style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 14.5
                                      ),),
                                      const SizedBox(height: 5,),
                                    ],
                                  ),
                                )),
                                const SizedBox(width: 10,),
                                Expanded(child: Container(
                                  height: 100,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.grey.withOpacity(0.10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("$myTicketCount", style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF2EB85C),
                                          fontSize: 24.5
                                      ),),
                                      const SizedBox(height: 5,),
                                      const Text("My Tickets", style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 14.5
                                      ),),
                                      const SizedBox(height: 5,),
                                    ],
                                  ),
                                )),

                              ],
                            ),
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTicketScreen()),);
                            },
                            child: Container(
                              height: 49,
                              width: 180,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppTheme.themeGreenColor,AppTheme.themeBlueColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Create New Ticket",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20,),

                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),*/

                    //Quick Links
                  /*  Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Expanded(child: Text(
                              "Quick Links",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14.5,
                                  color: Colors.black
                              ),
                            ),flex: 1,),
                            InkWell(
                                onTap: (){
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuScreen()),);
                                },
                                child:const Text("View More", style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black
                                ),)
                            )
                          ],),
                          SizedBox(height: 20,),
                          Row(
                              children: [
                                Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap:(){
                                          // Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                                      },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset("assets/ic_quick_community.svg",width: 32,height: 32,),
                                        SizedBox(width: 5,),
                                        Text("Community", style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                            fontSize: 12
                                        ),),
                                        SizedBox(height: 5,),
                                      ],
                                    ),
                                )),
                                const SizedBox(width: 5,),
                                Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HolidayScreen()));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/ic_quick_travel.svg",width: 32,height: 32,),
                                          SizedBox(width: 5,),
                                          Text("Holidays", style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 12
                                          ),),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    )),
                                const SizedBox(width: 5,),
                                Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap:(){
                                        // Navigator.push(context, MaterialPageRoute(builder: (context) => AllTask_Screen(false)),);
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/ic_quick_taskbox.svg",width: 32,height: 32,),
                                          SizedBox(width: 5,),
                                          Text("Task", style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 12
                                          ),),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    )),
                                const SizedBox(width: 5,),
                                Expanded(
                                    flex:1,
                                    child: InkWell(
                                      onTap:(){
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>QDRequestPayslip()));
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset("assets/ic_quick_payrol.svg",width: 32,height: 32,),
                                          SizedBox(width: 5,),
                                          Text("Payroll", style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                              fontSize: 12
                                          ),),
                                          SizedBox(height: 5,),
                                        ],
                                      ),
                                    )),
                              ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20,),*/

                    //Community
                    /*Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                            ),
                          ],
                        ),
                        child: communityLoading?
                        Center(child: Loader(),):
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                              },
                              child: Container(
                                height: 150,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 150,
                                      child: PageView.builder(
                                          itemCount: titleList.length,
                                          pageSnapping: true,
                                          controller: _pageController,
                                          onPageChanged: (page) {
                                            setState(() {
                                              activePage = page;
                                            });
                                            print("New Active Page is " +
                                                activePage.toString());
                                          },
                                          itemBuilder: (context, pagePosition) {
                                            bool active = pagePosition == activePage;
                                            return slider(
                                                titleList, pagePosition, active);
                                          }),
                                    ),

                                    Positioned(child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: indicators(
                                            titleList.length, activePage)),bottom: 2,left: 2,),
                                  ],
                                ),
                              ),
                            ),



                          ],
                        )
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: activePage==0?
                      birthdayList.isNotEmpty?
                      ListView.builder(
                          itemCount: birthdayList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext cntx,int indx){

                            String postId=birthdayList[indx]['id'].toString();
                            String userName=birthdayList[indx]['username'].toString();
                            String empProfile=birthdayList[indx]['profile_photo'].toString();
                            String designation=birthdayList[indx]['designation'].toString();


                            return InkWell(
                              onTap: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.themeBlueColor.withOpacity(0.11),
                                  boxShadow: const <BoxShadow>[BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                  ),],
                                ),
                                child: Row(
                                  children: [

                                    empProfile==""?
                                    const CircleAvatar(
                                      backgroundImage: AssetImage("assets/profile.png"),
                                      radius: 20,)
                                        :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: empProfile,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            Text(userName,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13.5,color: Colors.black),),
                                            SizedBox(height: 5,),
                                            Text("($designation)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color: Colors.black),),

                                          ],
                                        )),

                                    SizedBox(width: 10,),

                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(

                                          color: Color(0xFFFFFFFF),
                                          boxShadow: <BoxShadow>[BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                          ),],
                                          shape: BoxShape.circle
                                      ),
                                      child: const Center(child: Icon(Icons.arrow_forward_ios_sharp,color: AppTheme.themeBlueColor,),),
                                    ),

                                    SizedBox(width: 10,),

                                  ],
                                ),

                              ),
                            );


                          }
                      ):
                      const Center(child: Text("Nobody have birthday today",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: AppTheme.themeGreenColor),),)
                          :
                      activePage==1?
                      anniversaryList.isNotEmpty?
                      ListView.builder(
                          itemCount: anniversaryList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext cntx,int indx){

                            String postId=anniversaryList[indx]['id'].toString();
                            String userName=anniversaryList[indx]['username'].toString();
                            String empProfile=anniversaryList[indx]['profile_photo'].toString();
                            String designation=anniversaryList[indx]['designation'].toString();


                            return InkWell(
                              onTap: (){
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.themeBlueColor.withOpacity(0.11),
                                  boxShadow: const <BoxShadow>[BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                  ),],
                                ),
                                child: Row(
                                  children: [

                                    empProfile==""?
                                    const CircleAvatar(
                                      backgroundImage: AssetImage("assets/profile.png"),
                                      radius: 20,)
                                        :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: empProfile,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            Text(userName,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13.5,color: Colors.black),),
                                            SizedBox(height: 5,),
                                            Text("($designation)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color: Colors.black),),

                                          ],
                                        )),

                                    SizedBox(width: 10,),

                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(

                                          color: Color(0xFFFFFFFF),
                                          boxShadow: <BoxShadow>[BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                          ),],
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: AppTheme.themeBlueColor,),),
                                    ),

                                    SizedBox(width: 10,),

                                  ],
                                ),

                              ),
                            );


                          }
                      ):
                      const Center(child: Text("Nobody have anniversary today",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: AppTheme.themeGreenColor),),)
                          :
                      activePage==2?
                      newJoineeList.isNotEmpty?
                      ListView.builder(
                          itemCount: newJoineeList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext cntx,int indx){

                            String postId=newJoineeList[indx]['id'].toString();
                            String userName=newJoineeList[indx]['username'].toString();
                            String empProfile=newJoineeList[indx]['profile_photo'].toString();
                            String designation=newJoineeList[indx]['designation'].toString();


                            return InkWell(
                              onTap: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.themeBlueColor.withOpacity(0.11),
                                  boxShadow: const <BoxShadow>[BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                  ),],
                                ),
                                child: Row(
                                  children: [

                                    empProfile==""?
                                    const CircleAvatar(
                                      backgroundImage: AssetImage("assets/profile.png"),
                                      radius: 20,)
                                        :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: empProfile,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            Text(userName,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13.5,color: Colors.black),),
                                            SizedBox(height: 5,),
                                            Text("($designation)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color: Colors.black),),

                                          ],
                                        )),

                                    SizedBox(width: 10,),

                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(

                                          color: Color(0xFFFFFFFF),
                                          boxShadow: <BoxShadow>[BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                          ),],
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: AppTheme.themeBlueColor,),),
                                    ),

                                    SizedBox(width: 10,),

                                  ],
                                ),

                              ),
                            );


                          }
                      ):
                      const Center(child: Text("Nobody have Joined today",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: AppTheme.themeGreenColor),),)
                          :
                      activePage==3?
                      kudosList.isNotEmpty?
                      ListView.builder(
                          itemCount: kudosList.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (BuildContext cntx,int indx){

                            String postId=kudosList[indx]['id'].toString();
                            String userName=kudosList[indx]['username'].toString();
                            String empProfile=kudosList[indx]['profile_photo'].toString();
                            String designation=kudosList[indx]['designation'].toString();


                            return InkWell(
                              onTap: (){
                               // Navigator.push(context, MaterialPageRoute(builder: (context) => CommunityScreen()),);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppTheme.themeBlueColor.withOpacity(0.11),
                                  boxShadow: const <BoxShadow>[BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 1.0,
                                  ),],
                                ),
                                child: Row(
                                  children: [

                                    empProfile==""?
                                    const CircleAvatar(
                                      backgroundImage: AssetImage("assets/profile.png"),
                                      radius: 20,)
                                        :
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(40.0),
                                      child: CachedNetworkImage(
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                        imageUrl: empProfile,
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            CircularProgressIndicator(value: downloadProgress.progress),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      //child: Image.network(empProfile,width: 60,height: 60,fit: BoxFit.cover,),

                                    ),

                                    SizedBox(width: 10,),

                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,

                                          children: [
                                            Text(userName,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 13.5,color: Colors.black),),
                                            SizedBox(height: 5,),
                                            Text("($designation)",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 11.5,color: Colors.black),),

                                          ],
                                        )),

                                    SizedBox(width: 10,),

                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: const BoxDecoration(

                                          color: Color(0xFFFFFFFF),
                                          boxShadow: <BoxShadow>[BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 1.0,
                                          ),],
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(child: Icon(Icons.arrow_forward_ios_sharp,color: AppTheme.themeBlueColor,),),
                                    ),

                                    SizedBox(width: 10,),

                                  ],
                                ),

                              ),
                            );


                          }
                      ):
                      const Center(child: Text("Nobody received KUDOS today",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w700,color: AppTheme.themeGreenColor),),)
                          :
                      Container(),
                    ),*/
                    const SizedBox(height: 20,),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),

    );
  }
  AnimatedContainer slider(images, pagePosition, active) {
    double margin = active ? 8 : 8;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
        //margin: EdgeInsets.all(margin),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
              ),
            ],
            color: pagePosition == 0
                ? const Color(0xFFF0ED86).withOpacity(0.50)
                : pagePosition == 1
                ? const Color(0xFF304C9F).withOpacity(0.20)
                : pagePosition == 2
                ? const Color(0xFFF4EDE3).withOpacity(0.50)
                : pagePosition == 3
                ? const Color(0xFFFFF7C7).withOpacity(1)
                : const Color(0xFFF7F6FD)

          /*image: DecorationImage(
              fit: BoxFit.cover, image: CachedNetworkImageProvider(images[pagePosition]))*/
        ),
        child: Row(
          children: [
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3),
                    Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(titleList[pagePosition],
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 23,
                                height: 1.2,
                                color: Colors.black))),
                    SizedBox(height: 3),
                    Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(descriptionList[pagePosition],
                            style:
                            TextStyle(fontSize: 15, color: AppTheme.themeBlueColor)))
                  ],
                )),
            SizedBox(
              height: 110,
              width: 100,
              child: OverflowBox(
                minHeight: 180,
                maxHeight: 180,
                child: Lottie.asset(pagePosition == 0
                    ? "assets/d1.json"
                    : pagePosition == 1
                    ? "assets/d2.json"
                    : pagePosition == 2
                    ? "assets/d3.json"
                    : pagePosition == 3?
                "assets/d4.json":
                "assets/d5.json"

                ),
              ),
            ),
          ],
        ));
  }
  List<Widget> indicators(imagesLength, currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(7),
        width: 8,
        height: 8,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? Colors.black
                : Colors.grey.withOpacity(0.4),
            shape: BoxShape.circle),
      );
    });
  }
  Alignment alignmentFromAngle(double degrees) {
    final radians = degrees * pi / 180;
    return Alignment(cos(radians), sin(radians));
  }
  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
    _getUserData();
  }
  _getUserData() async {
    userIdStr=await MyUtils.getSharedPreferences("user_id")??"";
    fullNameStr=await MyUtils.getSharedPreferences("full_name")??"";
    firstName=await MyUtils.getSharedPreferences("first_name")??"";
    token=await MyUtils.getSharedPreferences("token")??"";
    designationStr=await MyUtils.getSharedPreferences("designation")??"";
    empId=await MyUtils.getSharedPreferences("emp_id")??"";
    baseUrl=await MyUtils.getSharedPreferences("base_url")??"";
    clientCode=await MyUtils.getSharedPreferences("client_code")??"";
    String? access=await MyUtils.getSharedPreferences("at_access")??'1';
    userProfile=await MyUtils.getSharedPreferences("profile_img")??"";
    String? ratingDurationId=await MyUtils.getSharedPreferences("rating_duration_id")??"";
    isAttendanceAccess=access;

    print("Rating Duration Id:$ratingDurationId******************************");

    if(fullNameStr.isNotEmpty){
      firstName=fullNameStr.split(" ")[0];
    }



    if(Platform.isAndroid){
      platform="android";
    }else if(Platform.isIOS){
      platform="ios";
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    currentVersionName = packageInfo.version;
    currentVersionCode = packageInfo.buildNumber;

    print(appName);
    print(packageName);
    print(currentVersionName);
    print(currentVersionCode);
    print("userId:-"+userIdStr.toString());
    print("token:-"+token.toString());
    print("employee_id:-"+empId.toString());
    print("Base Url:-"+baseUrl.toString());
    print("Platform:-"+platform);
    print("Client Code:-"+clientCode);


    var dateNow=DateTime.now();
    attDate=DateFormat("yyyy-MM-dd").format(dateNow);
    print("Attendace Date $attDate");

    dayStr=DateFormat("dd").format(dateNow);
    mnthStr=DateFormat("MMM").format(dateNow);

    dateStr=DateFormat("MMM dd,yyyy").format(dateNow);
    timeStr=DateFormat("hh:mm a").format(dateNow);
    monthStr=DateFormat("MMMM yyyy").format(dateNow);

    userShowProfile=userProfile;

    setState(() {

    });


    getCorrectionNotificaton();
    getAttendanceCardDetails();
    getAttendanceAnalysis();
    getLeaveBalance();
    getAnnouncements();

    /*getAttendanceDetails();
    getAttendanceAnalysis();
    getLeaveBalance();
    getTeamOnLeave();
    getAnnouncements();
    getTicketCounts();


    getAppUpdateDetails();
    updateVersionOnServer();
    getUserProfileImage();
    if(ratingDurationId.isEmpty){
      getUserProfile();
    }
    getLocationList();
    getTeamAttendance();
    getTaskBox();
    getAlertAnnouncement(context);

    attendaceLocalList.clear();
    attendaceLocalList=await DatabaseHelper.instance.queryAllUsers();
    print("Local Attendance Size : ${attendaceLocalList.length}");
    for(UserAttendanceModel user in attendaceLocalList){
      print("user attendace Data ${user.AttendanceDate} && ${user.AttendanceCheck} ");
    }
    setState(()  {

    });*/



  }


  String getImageForTime() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'assets/ic_morning.svg';
    } else if (hour >= 12 && hour < 17) {
      return 'assets/ic_morning.svg';
    } else if (hour >= 17 && hour < 20) {
      return 'assets/ic_morning.svg';
    } else {
      return 'assets/ic_night.svg';
    }
  }
  getCorrectionNotificaton() async{
    setState(() {
      isNotiLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-correction-notification', token,clientCode, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true){

      List<dynamic> tempData = responseJSON['data']['message'];
      String cleanNotiStr = tempData.map((e) => e.toString()).join();
      notiStr=cleanNotiStr.replaceAll(RegExp(r'<[^>]*>'), ' ');


      setState(() {
        isNotiLoading=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        isNotiLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }else{
      notiStr="";
      setState(() {
        isNotiLoading=false;

      });
    }


  }
  getAttendanceCardDetails() async {

    setState(() {
      attStatus=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-check-in-check-out', token, clientCode, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {

      final attendanceLog = responseJSON['data']['attendanceLog'];
      if(attendanceLog != null && responseJSON['data']['attendanceLog']['log_type']!=null){
        String last_check_status=responseJSON['data']['attendanceLog']['log_type'].toString();
        if(last_check_status=="null"){
            logedInHour="00";
            logedInMinute="00";
            logedInSec="00";
            showCheckIn=true;
          }
        else if(last_check_status=="in" || last_check_status=="IN"){
            showCheckIn=false;
            String logedInTime="00:00:00";
            if(responseJSON['data']['attendanceTime']!=null){
              if(responseJSON['data']['attendanceTime']['totalWorkingTime']!=null){
                logedInTime=responseJSON['data']['attendanceTime']['totalWorkingTime'];
              }else{
                logedInTime="00:00:00";
              }
              print("logedInHours $logedInTime");

            }

            if(logedInTime=="null"){
              logedInHour="00";
              logedInMinute="00";
              logedInSec="00";
            }

            startTimer(logedInTime);

          }
        else if(last_check_status=="out" || last_check_status=="OUT"){
            showCheckIn=true;
            String logedInTime="00:00:00";


            if(responseJSON['data']['attendanceTime']!=null){

              int ho=0;
              int min=0;
              int se=0;
              String hoS="00";
              String minS="00";
              String secS="00";

              if(responseJSON['data']['attendanceTime']['workHours']!=null){
                ho=responseJSON['data']['attendanceTime']['workHours'];
              }
              if(responseJSON['data']['attendanceTime']['workMinutes']!=null){
                min=responseJSON['data']['attendanceTime']['workMinutes'];
              }
              if(responseJSON['data']['attendanceTime']['workSeconds']!=null){
                se=responseJSON['data']['attendanceTime']['workSeconds'];
              }
              if(ho<10){
                hoS="0$ho";
              }else{
                hoS="$ho";
              }

              if(min<10){
                minS="0$min";
              }else{
                minS="$min";
              }

              if(se<10){
                secS="0$se";
              }else{
                secS="$se";
              }
              if(responseJSON['data']['attendanceTime']['totalWorkingTime']!=null){
                logedInTime=responseJSON['data']['attendanceTime']['totalWorkingTime'];
              }else{
                logedInTime="00:00:00";
              }
              //logedInTime="$hoS:$minS:$secS";
              print("logedInHours $logedInTime");

              logedInHour=hoS;
              logedInMinute=minS;
              logedInSec=secS;

            }else{
              logedInHour="00";
              logedInMinute="00";
              logedInSec="00";
            }


            stopTimer();
          }
        if(responseJSON['data']['attendanceTime']!=null){

          var times=responseJSON['data']['attendanceTime'];
          inTime="-";
          outTime="-";
          breakTime="-";
          if(times['firstEntryTime']!=null){
            var deliveryTime=DateTime.parse(times['firstEntryTime']);
            var delLocal=deliveryTime.toLocal();
            inTime=DateFormat('hh:mm a').format(delLocal);
          }
          if(times['lastExitTime']!=null){
            var deliveryTime=DateTime.parse(times['lastExitTime']);
            var delLocal=deliveryTime.toLocal();
            outTime=DateFormat('hh:mm a').format(delLocal);
          }
          if(times['totalBreakTime']!=null){
            breakTime=times['totalBreakTime'];
          }

        }

      }
      else{
        showCheckIn=true;
      }
      if(responseJSON['data']['shift_start_time']!=null){
        shiftStartTime=responseJSON['data']['shift_start_time'].toString();
      }
      else{
        shiftStartTime="09:30 AM";
      }
      print("Shift Started At $shiftStartTime");
      if(responseJSON['data']['shift_end_time']!=null){
        shiftEndTime=responseJSON['data']['shift_end_time'].toString();
      }else{
        shiftEndTime="06:30 PM";
      }
      print("Shift Ended At $shiftEndTime");
      setState(() {
        attStatus=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attStatus=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      shiftStartTime="09:30 AM";
      shiftEndTime="06:30 PM";
      setState(() {
        attStatus=false;
      });

    }
  }
  getAttendanceAnalysis() async {
    setState(() {
      analysisLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-attendance-dashboard', token, clientCode, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {
      if(responseJSON['data']['attendanceCount']!=null){
        presentDaysCount=responseJSON['data']['attendanceCount']['present_count'].toString();
        absentDaysCount=responseJSON['data']['attendanceCount']['absent_count'].toString();
        leaveDaysCount=responseJSON['data']['attendanceCount']['paid_count'].toString();
        correctionDaysCount=responseJSON['data']['attendanceCount']['paid_count'].toString();
      }
      print("Shift Ended At $shiftEndTime");
      setState(() {
        analysisLoading=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        analysisLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        analysisLoading=false;
      });

    }
  }
  getLeaveBalance() async {
    setState(() {
      leaveBalanceStatus=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-leave-balance', token, clientCode, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {
      List<dynamic> tempList=responseJSON['data'];
      double? totalLeave = 0.0;

      for (var item in tempList) {
        final balance = item['leave_balance'];
        if (balance != null) {
          totalLeave = (totalLeave ?? 0) + (balance as num).toDouble();
        }
      }
      totalLeaveBalance=totalLeave.toString();
      setState(() {
        leaveBalanceStatus=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        leaveBalanceStatus=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        leaveBalanceStatus=false;
      });

    }
  }
  startTimer(String time){

    List<String> splitString=time.split(':');
    int hour=int.parse(splitString[0]);
    int mnts=int.parse(splitString[1]);
    int sec=int.parse(splitString[2]);

    myDuration=Duration(hours: hour,minutes: mnts,seconds: sec);
    if(countdownTimer!=null){
      countdownTimer!.cancel();
    }
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }
  setCountDown(){
    const increasedSecBy = 1;
    setState(() {
      final second=myDuration!.inSeconds+increasedSecBy;
      myDuration=Duration(seconds: second);
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final hours = strDigits(myDuration!.inHours.remainder(24));
      final minutes = strDigits(myDuration!.inMinutes.remainder(60));
      final seconds = strDigits(myDuration!.inSeconds.remainder(60));

      logedInHour=hours;
      logedInMinute=minutes;
      logedInSec=seconds;
      var dateNow=DateTime.now();
      timeStr=DateFormat("hh:mm").format(dateNow);
    });
  }
  stopTimer(){
    if(countdownTimer!=null){
      countdownTimer!.cancel();
    }
  }
  getAnnouncements() async {
    setState(() {
      communityLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-announcement', token, clientCode,context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);

    if (responseJSON['success'] == true) {
      List<dynamic> tempList=[];
      if(responseJSON['data']!=null){
        tempList=responseJSON['data'];
      }
      descriptionList.clear();
      birthdayList.clear();
      anniversaryList.clear();
      newJoineeList.clear();
      kudosList.clear();


      int birthdayCount=0;
      int anniversaryCount=0;
      int newJoineeCount=0;
      int kudosCount=0;
      for(int i=0;i<tempList.length;i++){
        String type=tempList[i]['announcement_type'].toString();
        if(type=='birthday') {
          birthdayCount=birthdayCount+1;
          birthdayList.add(tempList[i]);
        }else if(type=='anniversary'){
          anniversaryCount=anniversaryCount+1;
          anniversaryList.add(tempList[i]);
        }else if(type=='welcome_email'){
          newJoineeCount=newJoineeCount+1;
          newJoineeList.add(tempList[i]);
        }else if(type=='kudos'){
          kudosCount=kudosCount+1;
          kudosList.add(tempList[i]);
        }

      }




      if(birthdayCount==0){
        descriptionList.add("Nobody have birthday today");
      }else{
        descriptionList.add("$birthdayCount People have birthday today");
      }

      if(anniversaryCount==0){
        descriptionList.add("Nobody have anniversary today");
      }else{
        descriptionList.add("$anniversaryCount People have anniversary today");
      }

      if(newJoineeCount==0){
        descriptionList.add("Nobody have Joined today");
      }else{
        descriptionList.add("$newJoineeCount People have Joined today");
      }

      if(kudosCount==0){
        descriptionList.add("Nobody received KUDOS today");
      }else{
        descriptionList.add("$kudosCount People received KUDOS for their exceptional performance");
      }

      descriptionList.add("Share your thoughts, give wishes and know about your colleagues");






      setState(() {
        communityLoading=false;
      });
    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        communityLoading=false;
      });

    }
  }


  // Mark Attendance Functionality
  _checkDeveloperOption()async{
    bool isDevelopment=false;
    bool isMockLocation=false;
    if(Platform.isAndroid){
      try{
        //isDevelopment = await FlutterJailbreakDetection.developerMode;
        print("is Development Mode Enabled $isDevelopment");
      }on PlatformException catch(e){
        print("Platform Error ${e.message}");
      }

    }
    if(isDevelopment || isMockLocation){
      _showSettingDialog(isDevelopment, isMockLocation);
    }else{
      _getCurrentPosition();
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
          ],
        ),
      ),
    );
  }
  redirectToSettings(){
    AppSettings.openAppSettings(type: AppSettingsType.device);
  }
  Future<void> _getCurrentPosition() async {

    APIDialog.showAlertDialog(context, "Fetching Location..");
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      Navigator.of(context).pop();
      _showPermissionCustomDialog();
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print("Location  latitude : ${_currentPosition!.latitude} Longitude : ${_currentPosition!.longitude}");
      Navigator.pop(context);
      if(position.isMocked){
        _showMockLocationDialog();
      }else{
        _getAddressFromLatLng(position);
      }


    }).catchError((e) {
      debugPrint(e);
      Toast.show("Error!!! Can't get Location. Please Ensure your location services are enabled",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.pop(context);
    });


  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Toast.show("Location services are disabled. Please enable the services.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Toast.show("Location permissions are denied.",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Toast.show("Location permissions are permanently denied, we cannot request permissions.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return false;
    }
    return true;
  }
  _showPermissionCustomDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please allow below permissions for access the Attendance Functionality.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 10,),
                    Text(
                      "1.) Location Permission",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 5,),
                    Text(
                      "2.) Enable GPS Services",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),

                    SizedBox(height: 20,),
                    GradientButton(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      text: "OK",
                    )
                   /* TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),*/
                  ],
                ),
              ),
            ),
          );
        });
  }
  _showMockLocationDialog(){


    showDialog(context: context,
        barrierDismissible: false,
        builder: (ctx)=> PopScope(canPop: false,
            child: AlertDialog(
              title: const Text("WARNING",textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
              content:Container(
                height: 400,
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      margin: const EdgeInsets.only(top: 30),
                      child: Center(
                        child: Lottie.asset("assets/warning_anim.json"),
                      ),
                    ),
                    SizedBox(height: 10,),

                    Text(
                      "Please Turn Off Mock Location or Mock Location Application.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14,color: AppTheme.orangeColor),),

                    SizedBox(height: 10,),

                    const Text("You are using the Mock Location or Mock Location Application. You need to Turn Off Mock Location for Use This Functionality. For Turn Off Mock Location Please follow These Steps. Settings > Search For Developer Option > Search For Select Mock Location App > Select NOTHING",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: Colors.black),)
                  ],
                ),
              ),
              actions: <Widget>[
                GradientButton(
                  onTap: (){
                    Navigator.of(ctx).pop();
                    redirectToSettings();
                  },
                  text: "Go To Settings",
                ),
               /* TextButton(
                    onPressed: (){
                      Navigator.of(ctx).pop();
                      redirectToSettings();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.themeColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(child: Text("Go To Settings",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                    )
                ),*/


              ],
            )));
  }
  Future<void> _getAddressFromLatLng(Position position) async {
    APIDialog.showAlertDialog(context, "Checking Location....");
    bool isLocationMatched=false;
    double distancePoints=0.0;
    print("Location Length ${locationList.length}");
    if(locationList.isNotEmpty) {
      try{
        for (int i = 0; i < locationList.length; i++) {
          double lat1 = double.parse(locationList[i]['lat'].toString());
          double long1 = double.parse(locationList[i]['lng'].toString());
          distancePoints = Geolocator.distanceBetween(
              lat1, long1, position.latitude, position.longitude);
          print("distance calculated:::$distancePoints Meter");
          if (distancePoints < locationRadius) {
            isLocationMatched = true;
            break;
          }
        }
      }catch(e){
        isLocationMatched = true;
      }

    }else{
      isLocationMatched = true;
    }
    Navigator.pop(context);

    if(isLocationMatched){
      prepairCamera();
    }else{

      String distanceStr="";
      if(distancePoints<1000){
        distanceStr="${distancePoints.toStringAsFixed(2)} Meters";
      }else{
        double ddsss=distancePoints/1000;
        distanceStr="${ddsss.toStringAsFixed(2)} Kms";
      }
      _showLocationErrorCustomDialog(distanceStr);
    }
  }
  _showLocationErrorCustomDialog(String distanceStr){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Location Not Matched !",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),

                    Text(
                      "You are not Allowed to Check-In OR Check-Out on this Location. You are $distanceStr away from required Location.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 20,),
                    GradientButton(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      text: "OK",
                    ),
                    /*TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),*/
                  ],
                ),
              ),
            ),
          );
        });
  }
  Future<void> prepairCamera() async{

    // imageSelector(context);


    if(Platform.isAndroid){
      final imageData=await Navigator.push(context,MaterialPageRoute(builder: (context)=>CaptureImageByCamera()));
      if(imageData!=null)
      {
        capturedImage=imageData;
        capturedFile=File(capturedImage!.path);
        _faceFromCamera();
      }else{
        Toast.show("Unable to capture Image. Please try Again...",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    }else{
      imageSelector(context);
    }


  }
  imageSelector(BuildContext context) async{

    imageFile = await ImagePicker().pickImage(source: ImageSource.camera,
        imageQuality: 60,preferredCameraDevice: CameraDevice.front
    );

    if(imageFile!=null){
      file=File(imageFile!.path);

      final imageFiles = imageFile;
      if (imageFiles != null) {
        print("You selected  image : " + imageFiles.path.toString());
        setState(() {
          debugPrint("SELECTED IMAGE PICK   $imageFiles");
        });
        _faceDetection();
      } else {
        print("You have not taken image");
      }
    }else{
      Toast.show("Unable to capture Image. Please try Again...",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


  }
  _faceDetection() async{
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image=InputImage.fromFile(file!);
    final faces=await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if(faces.isNotEmpty){
      _showImageDialog();
    }else{
      Toast.show("Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }

  }
  _faceFromCamera() async{
    APIDialog.showAlertDialog(context, "Detecting Face....");
    final image=InputImage.fromFile(capturedFile!);
    final faces=await _faceDetector.processImage(image);
    print("faces in image ${faces.length}");
    Navigator.pop(context);
    if(faces.isNotEmpty){
      _showCameraImageDialog();
    }else{
      Toast.show("Face not detected in captured image. Please capture a selfie.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      _showFaceErrorCustomDialog();
    }
  }
  _showFaceErrorCustomDialog(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Please capture Selfie!!!",
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18),),
                    SizedBox(height: 20,),

                    Text(
                      "Face not detected in captured Image. Please capture Selfie.",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.w900,fontSize: 14),),
                    SizedBox(height: 20,),
                    GradientButton(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      text: "OK",
                    )
                   /* TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("OK",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),*/
                  ],
                ),
              ),
            ),
          );
        });
  }
  _showImageDialog(){
    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Mark Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
        content: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: FileImage(file!),
                fit: BoxFit.cover
            ),

          ),
        ),
        actions: <Widget>[
          GradientButton(
            onTap: (){
              Navigator.of(ctx).pop();
              markOnlyAttendance("iOS");
            },
            text: "Mark",
            height: 45,
          ),
          /*TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                markOnlyAttendance("iOS");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Mark",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          ),*/
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.greyColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          )
        ]
    ));
  }
  _showCameraImageDialog(){
    showDialog(context: context, builder: (ctx)=>AlertDialog(
        title: const Text("Mark Attendance",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 18),),
        content: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.rectangle,
            image: DecorationImage(
                image: FileImage(capturedFile!),
                fit: BoxFit.cover
            ),

          ),
        ),
        actions: <Widget>[
          GradientButton(
            onTap: (){
              Navigator.of(ctx).pop();
              markOnlyAttendance("camera");
            },
            text: "Mark",
            height: 45,
          ),
          /*TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
                markOnlyAttendance("camera");
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.themeColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Mark",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          ),*/
          TextButton(
              onPressed: (){
                Navigator.of(ctx).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.greyColor,
                ),
                height: 45,
                padding: const EdgeInsets.all(10),
                child: const Center(child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
              )
          )
        ]
    ));
  }
  markOnlyAttendance(String from) async{
    String attendanceCheck="";
    String addressStr="";
    if(showCheckIn){
      attendanceCheck="IN";
    }else{
      attendanceCheck="OUT";
    }
    APIDialog.showAlertDialog(context, 'Submitting Attendance...');
    print("Base Url $baseUrl");
    print("Check Status $attendanceCheck");
    print("emp_user_id $userIdStr");

    var bytes=null;
    if(from=='camera'){
      bytes= await File(capturedFile!.path).readAsBytesSync();
    }else{
      bytes = await File(file!.path).readAsBytesSync();
    }
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);


    var requestModel = {
      "attendance_type" : "attendance",
      "device_from":"mobile",
      "ip_address":"",
      "latitude":_currentPosition!.latitude.toString(),
      "longitude":_currentPosition!.longitude.toString(),
      "log_type":attendanceCheck,
     // "emp_user_id": userIdStr,
      //"punch_time": formattedDate,
      //"emp_img":base64Image,
      "user_agent":platform

    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "check-in-check-out", requestModel, context, token,clientCode);

    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['data']['id']!=null){
        String id=responseJSON['data']['id'].toString();
        uploadOnlyImage(from, id);
      }else{
        getAttendanceCardDetails();
      }
      //getAttendanceCardDetails();


    }
    else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
          LogoutUserFromApp.logOut(context);
    }
    else{
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  uploadOnlyImage(String from,String id) async{
    setState(() {

    });
    APIDialog.showAlertDialog(context, 'Uploading Image...');
    var bytes=null;
    if(from=='camera'){
      bytes= await File(capturedFile!.path).readAsBytesSync();
    }else{
      bytes = await File(file!.path).readAsBytesSync();
    }
    String base64Image="data:image/jpeg;base64,"+base64Encode(bytes);
    var requestModel = {
      "id": id,
      "capture":base64Image,
    };
    ApiBaseHelper apiBaseHelper=  ApiBaseHelper();
    var response = await apiBaseHelper.postAPIWithHeader(baseUrl, "update-attendance-image", requestModel, context, token,clientCode);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    if (responseJSON['error'] == false) {
      getAttendanceCardDetails();
    }
    else if(responseJSON['code']==401|| responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
          LogoutUserFromApp.logOut(context);
    }
    else{
     /* Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);*/
      getAttendanceCardDetails();
    }
    setState(() {

    });
  }


  // Logout Confirmation

  void showLogoutConfirmation(BuildContext context, VoidCallback onConfirmLogout) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      isScrollControlled: false,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Wrap(
            children: [
              Center(
                child: Icon(Icons.logout, size: 48, color: Color(0xFF00C797)),
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Are you sure you want to logout?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF1B81A4),
                        side: BorderSide(color: Color(0xFF1B81A4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onConfirmLogout(); // call logout logic
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Color(0xFF00C797),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                      ),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }



}