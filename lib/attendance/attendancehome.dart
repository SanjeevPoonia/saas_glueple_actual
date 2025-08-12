import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saas_glueple/attendance/daywise_attendancedetail_screen.dart';
import 'package:saas_glueple/attendance/monthwise_details_attendance_screen.dart';
import 'package:saas_glueple/network/api_dialog.dart';
import 'package:saas_glueple/network/loader.dart';
import 'package:saas_glueple/utils/app_theme.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import '../authentication/logout_functionality.dart';
import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../utils/gradient_button.dart';
import '../widget/appbar.dart';
import 'attendancedetail.dart';
import 'dart:io';
import 'package:intl/intl.dart';

import 'capture_image_from_camera.dart';

class AttendanceHomeScreen extends StatefulWidget {
  const AttendanceHomeScreen({super.key});

  @override
  State<AttendanceHomeScreen> createState() => _AttendanceHomeScreenState();
}

class _AttendanceHomeScreenState extends State<AttendanceHomeScreen> {
  int selectedCenter = 0;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();

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


  String presendDayCount="0";
  String absentDayCount="0";
  String leaveDayCount="0";

  bool attDashboardLoading=false;
  String todayDateStr="";
  bool attLoading=false;

  bool showCheckIn=true;

  String logedInHour="00";
  String logedInMinute="00";
  String logedInSec="00";
  Timer? countdownTimer;
  Duration? myDuration;
  String timeStr="";

  String inTime="-";
  String outTime="-";
  String breakTime="-";
  String fullDayWorkingHour="09:00";
  String loginDevice="";

  String last5StartDate="";
  String last5EndDate="";
  bool pastRecordLoader=false;
  List<dynamic> past5DayRecordList=[];

  String monthStartDate="";
  String monthEndDate="";
  bool calendarLoading=false;
  List<dynamic> fullMonthList=[];

  String todayYear="";
  String todayMonth="";
  String todayDay="";

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


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Attendance',
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,),
          onPressed: (){
            Navigator.of(context).pop();
          },
      ),
        actions: [

          /*
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const IconButton(
            icon: Icon(Icons.category, size: 30, color: Colors.white),
            onPressed: null,
          ),*/

        ],
      ),
      body: Stack(
        children: [
          // Fixed background with two colored/shadowed circles
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  top: -40,
                  left: -60,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C797).withOpacity(0.7),
                          blurRadius: 100,
                          spreadRadius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: -40,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B81A4).withOpacity(0.6),
                          blurRadius: 80,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Scrollable content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1350,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        top: -40,
                                        left: -60,
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            //   gradient: const LinearGradient(
                                            //     colors: [Color(0xFF00C797)],
                                            //     begin: Alignment.topLeft,
                                            //     end: Alignment.bottomRight,
                                            //   ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF00C797,
                                                ).withOpacity(0.7),
                                                blurRadius: 100,
                                                spreadRadius: 50,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 40,
                                        right: -40,
                                        child: Container(
                                          width: 150,
                                          height: 150,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // gradient: const LinearGradient(
                                            //   colors: [Color(0xFF1B81A4)],
                                            //   begin: Alignment.topRight,
                                            //   end: Alignment.bottomLeft,
                                            // ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(
                                                  0xFF1B81A4,
                                                ).withOpacity(0.6),
                                                blurRadius: 80,
                                                spreadRadius: 40,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 20,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 10),
                                          // Center Selection Tabs
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Background color for the unselected part
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap:  (){
                                                      selectedCenter=0;
                                                      print("Selected Center : $selectedCenter");

                                                      setState(() {

                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            selectedCenter == 0
                                                            ? Color(0xFF1B81A4)
                                                            : Colors
                                                                  .transparent, // Changed to transparent for unselected
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                        // boxShadow: selectedCenter == 0
                                                        //     ? [
                                                        //         BoxShadow(
                                                        //           color: Colors.grey.withOpacity(0.3),
                                                        //           spreadRadius: 2,
                                                        //           blurRadius: 5,
                                                        //           offset: const Offset(0, 3),
                                                        //         )
                                                        //   ]
                                                        // : [],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Dashboard",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                selectedCenter ==
                                                                    0
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF1B81A4,
                                                                  ), // Darker grey for unselected
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // No SizedBox here, as the background container handles spacing
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      selectedCenter = 1;
                                                      print("Selected Center: $selectedCenter");
                                                      setState(() {

                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 12,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            selectedCenter == 1
                                                            ? Color(0xFF1B81A4)
                                                            : Colors
                                                                  .transparent, // Changed to transparent for unselected
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              24,
                                                            ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Calendar",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                selectedCenter ==
                                                                    1
                                                                ? Colors.white
                                                                : Color(
                                                                    0xFF1B81A4,
                                                                  ), // Darker grey for unselected
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (selectedCenter == 0)
                                    Positioned(
                                      top: 100,
                                      left: 0,
                                      right: 0,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20.0,
                                            ),
                                            child: attDashboardLoading?Center(child: Loader(),):Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                _buildStatCard(
                                                  presendDayCount,
                                                  "Days\nPresent",
                                                ),
                                                _buildStatCard(
                                                  absentDayCount,
                                                  "Days\nAbsent",
                                                ),
                                                _buildStatCard(
                                                  leaveDayCount,
                                                  "Leaves\nTaken",
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 18,
                                                  right: 18,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Today',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 26,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),

                                                        // SizedBox(height: 2),
                                                        Text(
                                                          todayDateStr,
                                                          style: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 16),
                                                    attLoading?Loader():
                                                        isAttendanceAccess=="1"?
                                                        Container(
                                                          width: 150,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                            boxShadow: const [
                                                              BoxShadow(
                                                                color:
                                                                Colors.black26,
                                                                blurRadius: 10,
                                                              ),
                                                            ],
                                                            gradient:
                                                            const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                  0xFF00C797,
                                                                ),
                                                                Color(
                                                                  0xFF1B81A4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              _checkDeveloperOption();
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 20,
                                                                vertical: 12,
                                                              ),
                                                              backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                              ),
                                                            ),
                                                            child:  Row(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                              children: [
                                                                const Icon(
                                                                  Icons.play_arrow,
                                                                  size: 24,
                                                                  color:
                                                                  Colors.white,
                                                                ),
                                                                const SizedBox(width: 4),
                                                                Text(
                                                                  showCheckIn==true?"Punch In":"Punch Out",
                                                                  style: const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: 16,
                                                                    // fontWeight:
                                                                    //     FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                        :Container(),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 24),
                                              Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  16,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10,
                                                    ),
                                                  ],
                                                ),
                                                child:
                                                    _buildTrackedTimeSection(),
                                              ),
                                              const SizedBox(height: 16),
                                              pastRecordLoader?Loader():buildPastRecordSection(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (selectedCenter == 1)
                                    Positioned(
                                      top: 100,
                                      left: 0,
                                      right: 0,

                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: calendarLoading?Loader():TableCalendar(
                                              firstDay: DateTime.utc(
                                                2020,
                                                1,
                                                1,
                                              ),
                                              lastDay: DateTime.utc(
                                                int.parse(todayYear) ,
                                                int.parse(todayMonth) ,
                                                 int.parse(todayDay),
                                              ),
                                              focusedDay: _focusedDay,
                                              calendarFormat:
                                              CalendarFormat.month,
                                              calendarStyle: CalendarStyle(
                                                todayDecoration: BoxDecoration(
                                                  color: Color(0xFF304C9F),
                                                  shape: BoxShape.circle,
                                                ),
                                                selectedDecoration:
                                                BoxDecoration(
                                                  color: Color(0xFF00C797),
                                                  shape: BoxShape.circle,
                                                ),
                                                markerDecoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  shape: BoxShape.circle,
                                                ),
                                                weekendTextStyle: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                              headerStyle: HeaderStyle(
                                                titleTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                formatButtonVisible: false,
                                                titleCentered: true,
                                                leftChevronIcon: Icon(
                                                  Icons.arrow_back_ios,
                                                ),
                                                rightChevronIcon: Icon(
                                                  Icons.arrow_forward_ios,
                                                ),
                                              ),
                                              eventLoader: (day) =>
                                                  _getEventsForDay(day),
                                              selectedDayPredicate: (day) {
                                                return isSameDay(
                                                  day,
                                                  _selectedDay,
                                                );
                                              },
                                              onDaySelected:
                                                  (selectedDay, focusedDay) {
                                                setState(() {
                                                  _selectedDay =
                                                      selectedDay;
                                                  _focusedDay = focusedDay;
                                                });
                                              },
                                              onPageChanged: (focusMonth){
                                                setState(() {
                                                  _focusedDay=focusMonth;
                                                });
                                                DateTime startOfMonth = DateTime(focusMonth.year, focusMonth.month, 1);
                                                DateTime today = DateTime.now();
                                                DateTime endOfMonth;

                                                if (focusMonth.year == today.year && focusMonth.month == today.month) {
                                                  endOfMonth = today;
                                                } else {
                                                  endOfMonth = DateTime(focusMonth.year, focusMonth.month + 1, 0);
                                                }
                                                final formatter = DateFormat('yyyy-MM-dd');
                                                monthStartDate=formatter.format(startOfMonth);
                                                monthEndDate=formatter.format(endOfMonth);
                                                getFullMonthAttendance();
                                              },
                                              calendarBuilders: CalendarBuilders(
                                                selectedBuilder:
                                                    (context, day, focusedDay) {
                                                  final events = _getEventsForDay(day);
                                                  if (events.isNotEmpty) {
                                                    // Map event to color and abbreviation
                                                    String event =
                                                        events.first;
                                                    Color color;
                                                    String abbr;
                                                    if (event ==
                                                        "Present") {
                                                      color = Colors.green;
                                                      abbr = "PR";
                                                    } else if (event ==
                                                        "Absent") {
                                                      color = Colors.red;
                                                      abbr = "AB";
                                                    } else if (event ==
                                                        "Week Off") {
                                                      color = Colors.indigo;
                                                      abbr = "WO";
                                                    } else if (event ==
                                                        "Public Holiday") {
                                                      color = Color(
                                                        0xFF2B7B8A,
                                                      );
                                                      abbr = "PH";
                                                    } else if (event ==
                                                        "Paid Leave") {
                                                      color = Colors.indigo;
                                                      abbr = "PL";
                                                    } else if (event ==
                                                        "Leave w/o Pay") {
                                                      color = Colors.orange;
                                                      abbr = "LW";
                                                    } else if (event ==
                                                        "Half Day Absent") {
                                                      color = Color(
                                                        0xFFFF0000,
                                                      );
                                                      abbr = "HD";
                                                    } else {
                                                      color = Color(
                                                        0xFF1B81A4,
                                                      );
                                                      abbr = event
                                                          .substring(0, 2)
                                                          .toUpperCase();
                                                    }
                                                    return CircleAvatar(
                                                      backgroundColor:
                                                      color,
                                                      radius: 18,
                                                      child: Text(
                                                        abbr,
                                                        style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  else {
                                                    // No event: filled blue circle with date number
                                                    return CircleAvatar(
                                                      backgroundColor:
                                                      Color(0xFF1B81A4),
                                                      radius: 18,
                                                      child: Text(
                                                        '${day.day}',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                todayBuilder:
                                                    (context, day, focusedDay) {
                                                  // If today is not selected
                                                  if (!isSameDay(
                                                    day,
                                                    _selectedDay,
                                                  )) {
                                                    return CircleAvatar(
                                                      backgroundColor:
                                                      Color(0xFF304C9F),
                                                      radius: 18,
                                                      child: Text(
                                                        '${day.day}',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.white,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    // Let selectedBuilder handle it
                                                    return null;
                                                  }
                                                },
                                                defaultBuilder:
                                                    (context, day, focusedDay) {
                                                  final events =
                                                  _getEventsForDay(day);
                                                  if (events.isNotEmpty) {
                                                    // Map event to color
                                                    String event =
                                                        events.first;
                                                    Color color;
                                                    if (event == "Present")
                                                      color = Colors.green;
                                                    else if (event ==
                                                        "Absent")
                                                      color = Colors.red;
                                                    else if (event ==
                                                        "Week Off")
                                                      color = Colors.indigo;
                                                    else if (event ==
                                                        "Public Holiday")
                                                      color = Color(
                                                        0xFF2B7B8A,
                                                      );
                                                    else if (event ==
                                                        "Paid Leave")
                                                      color = Colors.indigo;
                                                    else if (event ==
                                                        "Leave w/o Pay")
                                                      color = Colors.orange;
                                                    else if (event ==
                                                        "Half Day Absent")
                                                      color = Color(
                                                        0xFFFF0000,
                                                      );
                                                    else
                                                      color = Color(
                                                        0xFF1B81A4,
                                                      );
                                                    return Center(
                                                      child: Text(
                                                        '${day.day}',
                                                        style: TextStyle(
                                                          color: color,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  // Default day
                                                  return Center(
                                                    child: Text(
                                                      '${day.day}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                dowBuilder: (context, day) {
                                                  final text = [
                                                    'S',
                                                    'M',
                                                    'T',
                                                    'W',
                                                    'T',
                                                    'F',
                                                    'S',
                                                  ][day.weekday % 7];
                                                  return Center(
                                                    child: Text(
                                                      text,
                                                      style: TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),

                                          // Legends
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,

                                                  children: [
                                                    _legend(
                                                      "Today",
                                                      Color(0xFF304C9F),
                                                      "T",
                                                    ),
                                                    _legend(
                                                      "Present",
                                                      Color(0xFF1D963A),
                                                      "PR",
                                                    ),
                                                    _legend(
                                                      "Public Holiday",
                                                      Color(0xFF2B7B8A),
                                                      "PH",
                                                    ),
                                                    _legend(
                                                      "Week Off",
                                                      Color(0xFF5C5959),
                                                      "WO",
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    _legend(
                                                      "Paid Leave",
                                                      Colors.indigo,
                                                      "PL",
                                                    ),
                                                    _legend(
                                                      "Leave w/o Pay",
                                                      Colors.orange,
                                                      "LW",
                                                    ),
                                                    _legend(
                                                      "Half Day Absent",
                                                      Color(0xFFFF0000),
                                                      "HD",
                                                    ),
                                                    _legend(
                                                      "Absent",
                                                      Colors.red,
                                                      "AB",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 16),

                                          // Filter Buttons
                                         /* Padding(
                                            padding: const EdgeInsets.all(0),
                                            child: Wrap(
                                              spacing: 7,
                                              children: [
                                                _filterButton("Today"),
                                                _filterButton("Yesterday"),
                                                _filterButton("This Month"),
                                                _filterButton("Last Month"),
                                                _filterButton("Last 3 Month"),
                                                _filterButton("Last 6 Month"),
                                                _filterButton("Last Year"),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(height: 16),*/

                                          // View Details Button
                                          Center(
                                            child: Container(
                                              width: 350,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    blurRadius: 10,
                                                  ),
                                                ],
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFF00C797),
                                                    Color(0xFF1B81A4),
                                                  ],
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => MonthWiseAttendanceDetails(fullDayWorkingHour),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 40,
                                                        vertical: 12,
                                                      ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "View Details",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                        ],
                                      ),
                                    ),
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
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B81A4),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
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
  Duration parseDuration(String input) {
    List<String> parts = input.split(":");

    int hours = int.parse(parts[0]);
    int minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
    int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "${twoDigits(hours)}:${twoDigits(minutes)}";
  }
  Widget _buildTrackedTimeSection() {

    double progress = calculateCompletedPercentage("$logedInHour:$logedInMinute:$logedInSec", fullDayWorkingHour);
    Duration duration1 = parseDuration("$logedInHour:$logedInMinute:$logedInSec");
    Duration duration2 = parseDuration(fullDayWorkingHour);
    Duration difference = duration2 - duration1;
    String leftDuration="00:00:00";
    if(duration2>duration1){
      leftDuration=formatDuration(difference);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Icon, "Tracked Time", value
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE6FAF6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/timer.png', width: 28, height: 28),
            ),
            const SizedBox(width: 8),
            const Text(
              "Tracked Time",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Spacer(),
             Text(
              "$logedInHour:$logedInMinute:$logedInSec",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(
          borderRadius: BorderRadius.circular(4),
          value: progress,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFF1B81A4),
          minHeight: 6,
        ),

        // Progress bar
        const SizedBox(height: 16),
        // Key-value rows with dividers
        _divider(),
        _buildKeyValueRow("Full Time", fullDayWorkingHour),
        _divider(),
        _buildKeyValueRow("Left", leftDuration),
        _divider(),
        _buildKeyValueRow("First In", inTime),
        _divider(),
        _buildKeyValueRow("Last Out", outTime),
        _divider(),
        _buildKeyValueRow("Total Break", breakTime),
        _divider(),
        _buildKeyValueRow("Login Device", loginDevice, isLink: true),
        _divider(),
        // _buildKeyValueRow("Device IP Address", "122486896326", isLink: true),
        // _divider(),
        const SizedBox(height: 8),
        // View Activity button
        Center(
          child: GestureDetector(
            onTap: () {
              String todayDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailScreen(todayDate),
                ),
              );
            }, // Add your action here
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "View Activity",
                style: TextStyle(
                  color: Color(0xFF1B81A4),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildPastRecordSection() {


    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FAF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset('assets/timer.png', width: 28, height: 28),
              ),
              SizedBox(width: 10),
              Text(
                'Past Record',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          _divider(),
          SizedBox(height: 6),

          past5DayRecordList.isEmpty?
          Center(
            child: Column(
              children: [
                SizedBox(height: 50),
                Icon(Icons.event_available, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text(
                  "No Record found for past 3 days",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ):ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: past5DayRecordList.map((record) {


              String attDate="";
              if(record['attendance_date']!=null){
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
              double progress = calculateCompletedPercentage(totalWorkingHour, fullDayWorkingHour);

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


              return InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DayWiseAttendanceDetailsScreen(fullDayWorkingHour,record),
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
              );
            }).toList(),
          ),



          SizedBox(height: 8),

          _divider(),
          SizedBox(height: 8),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  InkWell(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MonthWiseAttendanceDetails(fullDayWorkingHour),
                          ),
                        );
                      },
                      child: Text(
      "See More",
      style: TextStyle(
        fontSize: 16,
        color: Color(0xFF1B81A4),
        fontWeight: FontWeight.bold,
      ),
    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
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
  Widget _buildKeyValueRow(String key, String value, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isLink ? const Color(0xFF1B81A4) : Colors.black,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildRecordContainer(
    String key,
    String value, {
    bool isLink = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(fontSize: 15, color: Colors.black87),
          ),
          GestureDetector(
            onTap: isLink ? () {} : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isLink ? const Color(0xFF1B81A4) : Colors.black,
                decoration: isLink ? TextDecoration.underline : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, color: Color(0xFFE0E0E0));

  Widget _buildKeyValue(String key, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(key, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {

    final formattedDay = DateFormat('yyyy-MM-dd').format(day);

    final record = fullMonthList.firstWhere(
          (item) => item['attendance_date'] == formattedDay,
      orElse: () => null,
    );

    if (record == null) return [];

    String status = record['attendance_status'] ?? "";

    switch (status) {
      case "PR":
        return ["Present"];
        case "WO_P":
        return ["Present"];
      case "AB":
        return ["Absent"];
      case "SHP":
        return ["Half Day Present"];
      case "FHP":
        return ["Half Day Present"];
      case "WO":
        return ["Week Off"];
      case "PH":
        return ["Public Holiday"];
      case "PL":
        return ["Paid Leave"];
      case "LW":
        return ["Leave w/o pay"];
      case "LWP":
        return ["Leave w/o pay"];
      default:
        return ["Unknown"];
    }
  }

  Widget _legend(String label, Color color, String abbreviation) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color,
            child: Text(
              abbreviation,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String label) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.blue.shade50,
        side: BorderSide(color: Colors.blue.shade800, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.blue.shade800,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
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


    var dateNow=DateTime.now();
    todayDateStr=DateFormat("dd MMM, yyyy").format(dateNow);

    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(const Duration(days: 1));
    DateTime fifthDayBack = now.subtract(const Duration(days: 3));

    final formatter = DateFormat('yyyy-MM-dd');
    last5StartDate=formatter.format(fifthDayBack);
    last5EndDate=formatter.format(yesterday);

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startOfMonth = DateTime(now.year, now.month, 1);

    monthStartDate=formatter.format(startOfMonth);
    monthEndDate=formatter.format(today);

    todayYear=now.year.toString();
    todayMonth=now.month.toString().padLeft(2, '0');
    todayDay=now.day.toString().padLeft(2, '0');

    print("today date differ : $todayYear-$todayMonth-$todayDay");



    print("Attendace Date $todayDateStr");
    getAttendanceDashData();
    getCheckInStatus();
    getLast5DaysAttendance();
    getFullMonthAttendance();

    /*
    dayStr=DateFormat("dd").format(dateNow);
    mnthStr=DateFormat("MMM").format(dateNow);

    dateStr=DateFormat("MMM dd,yyyy").format(dateNow);
    timeStr=DateFormat("hh:mm a").format(dateNow);
    monthStr=DateFormat("MMMM yyyy").format(dateNow);

    userShowProfile=userProfile;

    setState(() {

    });*/







  }
  getAttendanceDashData() async{

    setState(() {
      attDashboardLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-attendance-dashboard', token, clientCode, context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {
      if(responseJSON['data']['attendanceCount']!=null){
        presendDayCount=responseJSON['data']['attendanceCount']['present_count'].toString();
        absentDayCount=responseJSON['data']['attendanceCount']['absent_count'].toString();
        leaveDayCount=responseJSON['data']['attendanceCount']['paid_count'].toString();
      }

      setState(() {
        attDashboardLoading=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attDashboardLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attDashboardLoading=false;
      });

    }

  }
  getCheckInStatus() async {
    setState(() {
      attLoading=true;
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

        if(responseJSON['data']['attendanceLog']['device_from']!=null){
          loginDevice=responseJSON['data']['attendanceLog']['device_from'].toString();
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

          if(times['shift_full_day_working_hours']!=null){
            fullDayWorkingHour=times['shift_full_day_working_hours'].toString();
          }else{
            fullDayWorkingHour="09:00";
          }


        }

      }
      else{
        showCheckIn=true;
      }

      setState(() {
        attLoading=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attLoading=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        attLoading=false;
      });

    }
  }
  getLast5DaysAttendance() async{

    setState(() {
      pastRecordLoader=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl,
        'self-attendance?start_date=$last5StartDate&end_date=$last5EndDate&page=1&limit=10',
        token,
        clientCode,
        context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {

      if(responseJSON['data']['data']!=null){
       past5DayRecordList=responseJSON['data']['data'];
      }

      setState(() {
        pastRecordLoader=false;
      });

    }
    else if(responseJSON['code']==401 || responseJSON['message']=='Invalid token.'){
      Toast.show("Your Login session is Expired!! Please login again.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        pastRecordLoader=false;
      });
      LogoutUserFromApp.logOut(context);
    }
    else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      setState(() {
        pastRecordLoader=false;
      });

    }

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



  // Mark Attendance

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
        getCheckInStatus();
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
      getCheckInStatus();
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
      getCheckInStatus();
    }
    setState(() {

    });
  }
}
