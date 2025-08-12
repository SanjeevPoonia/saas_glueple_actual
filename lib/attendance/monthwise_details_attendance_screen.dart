import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saas_glueple/utils/app_theme.dart';
import 'package:toast/toast.dart';
import '../authentication/logout_functionality.dart';
import '../network/Utils.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import '../network/api_helper.dart';
import '../widget/appbar.dart';
import 'attendancedetail.dart';
import 'daywise_attendancedetail_screen.dart';

class MonthWiseAttendanceDetails extends StatefulWidget{
  String fullWorkingHour="09:00";

  MonthWiseAttendanceDetails(this.fullWorkingHour, {super.key});

  _monthWiseAttendanceDetails createState()=>_monthWiseAttendanceDetails();
}
class _monthWiseAttendanceDetails extends State<MonthWiseAttendanceDetails>{

  String monthStartDate="";
  String monthEndDate="";
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
  bool calendarLoading=false;
  List<dynamic>fullMonthList=[];
  String showingmonth="";
  String currentmonth="";
  String currentMonthName="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: AppTheme.dashboard_back_pink,
        appBar: CustomAppBar(
          title: 'Attendance Details ',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [

          ],
        ),
        body: calendarLoading?const Center(child: CircularProgressIndicator()):
        SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    color: AppTheme.cardGreenColor,
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){_getPreviousMonthAttendance();},
                            child:Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,size: 24,),
                          ),
                          Expanded(child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/at_calendar.svg',height: 21,width: 18,),
                              SizedBox(width: 5,),
                              Text(currentMonthName,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w900,color: Colors.black),),
                            ],
                          )),

                          currentmonth!=showingmonth?
                          InkWell(
                            onTap: (){_getNextMonthAttendance();},
                            child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,size: 24,),
                          )
                              :
                          SizedBox(width: 5,),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  buildPastRecordSection(),
                ],
              ),
        )),
    );
  }

  @override
  void initState() {
    super.initState();
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
      platform="Android";
    }else if(Platform.isIOS){
      platform="iOS";
    }else{
      platform="Other";
    }


    print("userId:-"+userIdStr.toString());
    print("token:-"+token.toString());
    print("employee_id:-"+empId.toString());
    print("Base Url:-"+baseUrl.toString());
    print("Platform:-"+platform);
    print("Client Code:-"+clientCode);

    currentMonthName=DateFormat("MMMM").format(DateTime.now());
    currentmonth=DateFormat.yMMM().format(DateTime.now());



    DateTime now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    monthStartDate=formatter.format(startOfMonth);
    monthEndDate=formatter.format(today);
    _getCurrentMonthAttendance();
   // getFullMonthAttendance();
  }
  getFullMonthAttendance() async{

    setState(() {
      calendarLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl,
        'self-attendance?start_date=$monthStartDate&end_date=$monthEndDate&page=1&limit=31',
        token,
        clientCode,
        context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {

      fullMonthList.clear();
      if(responseJSON['data']!=null){
        if(responseJSON['data']['data']!=null){
          fullMonthList=responseJSON['data']['data'];
        }
      }
      setState(() {
        calendarLoading=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        calendarLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        calendarLoading=false;
      });

    }

  }
  _getCurrentMonthAttendance(){
    final now = DateTime.now();
    var date = DateTime(now.year, now.month, 1).toString();
    var dateParse = DateTime.parse(date);
    monthStartDate==DateFormat("yyyy-MM-dd").format(dateParse);
    monthEndDate=DateFormat("yyyy-MM-dd").format(now);
    showingmonth=DateFormat.yMMM().format(now);
    print("Showing Month: "+showingmonth);
    print("Current Month: "+currentmonth);
    getFullMonthAttendance();


  }
  _getPreviousMonthAttendance(){
    final showing=DateFormat.yMMM().parse(showingmonth);
    var date = DateTime(showing.year,showing.month-1,1).toString();
    var dateParse = DateTime.parse(date);
    monthStartDate=DateFormat("yyyy-MM-dd").format(dateParse);
    var lastDayCurrentMonth = DateTime(showing.year,showing.month,1).subtract(Duration(days: 1));
    monthEndDate=DateFormat("yyyy-MM-dd").format(lastDayCurrentMonth);
    showingmonth=DateFormat.yMMM().format(lastDayCurrentMonth);
    currentMonthName=DateFormat("MMMM").format(dateParse);
    getFullMonthAttendance();
  }
  _getNextMonthAttendance(){
    final showing=DateFormat.yMMM().parse(showingmonth);
    var date = DateTime(showing.year,showing.month+1,1).toString();
    var dateParse = DateTime.parse(date);
    monthStartDate=DateFormat("yyyy-MM-dd").format(dateParse);
    var lastDayCurrentMonth = DateTime(showing.year,showing.month+2,1).subtract(Duration(days: 1));
    monthEndDate=DateFormat("yyyy-MM-dd").format(lastDayCurrentMonth);
    showingmonth=DateFormat.yMMM().format(lastDayCurrentMonth);
    currentMonthName=DateFormat("MMMM").format(dateParse);
    getFullMonthAttendance();
  }
  Widget buildPastRecordSection() {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(height: 16),
        fullMonthList.isEmpty?
        Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(Icons.event_available, size: 80, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                "No Record found for this month",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ):
        ListView(
          padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: fullMonthList.map((record) {
            String attDate="";
            String dateForRedirect="";
            if(record['attendance_date']!=null){
              dateForRedirect=record['attendance_date'].toString();
              print(dateForRedirect);
              DateTime fy=DateTime.parse(record['attendance_date'].toString());
              attDate=DateFormat("dd MMM yyyy").format(fy);
            }

            String totalWorkingHour="00:00:00";
            if(record['total_working_hours']!=null){
              totalWorkingHour=record['total_working_hours'].toString();
            }
            String totalBreakHour="00:00:00";
            if(record['total_break_time']!=null){
              totalBreakHour=record['total_break_time'].toString();
            }
            double progress = calculateCompletedPercentage(totalWorkingHour, widget.fullWorkingHour);

            String first_half_status="";
            if(record['first_half_status']!=null){
              first_half_status=record['first_half_status'].toString();
            }
            String second_half_status="";
            if(record['second_half_status']!=null){
              second_half_status=record['second_half_status'].toString();
            }

            var firstHalfColor=AppTheme.idCardBlue;
            var secondHalfColor=AppTheme.idCardBlue;
            if(first_half_status=="PR"){
              firstHalfColor=AppTheme.PColor;
            }else if(first_half_status=="AB"){
              firstHalfColor=AppTheme.ABColor;
            }
            if(second_half_status=="PR"){
              secondHalfColor=AppTheme.PColor;
            }else if(second_half_status=="AB"){
              secondHalfColor=AppTheme.ABColor;
            }


            return
            InkWell(
              onTap: (){
               /* Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => AttendanceDetailScreen(dateForRedirect),
                ),);*/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DayWiseAttendanceDetailsScreen("09:00",record),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFE6F7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          attDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          totalWorkingHour,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(4),
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.blue.shade100,
                      color: Color(0xFF1B81A4),
                    ),
                    SizedBox(height: 12),

                    _divider(),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statusColumn(
                          "First Half",
                          first_half_status,
                          firstHalfColor,
                        ),
                        _statusColumn(
                          "Second Half",
                          second_half_status,
                          secondHalfColor,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Total Break",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            Text(
                              totalBreakHour,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
              ;
          }).toList(),
        ),
        SizedBox(height: 8),
      ],
    );
  }
  Widget _divider() => const Divider(height: 1, color: Color(0xFFE0E0E0));
  Widget _statusColumn(String label, String status, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600])),
        Text(
          status,
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }
  double calculateCompletedPercentage(String completedTimeStr, String totalTimeStr) {
    // Parse completed time: "HH:mm:ss"
    final completedParts = completedTimeStr.split(':');
    final completed = Duration(
      hours: int.parse(completedParts[0]),
      minutes: int.parse(completedParts[1]),
      seconds: int.parse(completedParts[2]),
    );

    // Parse total time: "HH:mm" or "HH:mm:ss"
    final totalParts = totalTimeStr.split(':');
    final total = Duration(
      hours: int.parse(totalParts[0]),
      minutes: int.parse(totalParts[1]),
      seconds: totalParts.length == 3 ? int.parse(totalParts[2]) : 0,
    );

    // Avoid division by zero
    if (total.inSeconds == 0) return 0.0;

    double progress = completed.inSeconds / total.inSeconds;

    // Clamp between 0 and 1
    return progress.clamp(0.0, 1.0);
  }
}