import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:saas_glueple/network/api_dialog.dart';
import 'package:saas_glueple/network/loader.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';
import '../authentication/logout_functionality.dart';
import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../widget/appbar.dart';
import 'attendancedetail.dart';
import 'dart:io';
import 'package:intl/intl.dart';

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



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Attendance',
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        actions: [
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
          ),
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
                                                    onTap: () => (){

                                                      setState(
                                                            () => selectedCenter = 0,
                                                      );
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
                                                    onTap: () =>(){

                                                      setState(
                                                            () => selectedCenter = 1,
                                                      );

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
                                                        // boxShadow: selectedCenter == 1
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
                                                        onPressed: () {},
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
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.play_arrow,
                                                              size: 24,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(width: 4),
                                                            const Text(
                                                              "Check Out",
                                                              style: TextStyle(
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
                                                    ),
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
                                              buildPastRecordSection(),
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
                                            child: TableCalendar(
                                              firstDay: DateTime.utc(
                                                2020,
                                                1,
                                                1,
                                              ),
                                              lastDay: DateTime.utc(
                                                2030,
                                                12,
                                                31,
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
                                                  color: Colors.red,
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
                                              calendarBuilders: CalendarBuilders(
                                                selectedBuilder:
                                                    (context, day, focusedDay) {
                                                      final events =
                                                          _getEventsForDay(day);
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
                                                      } else {
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
                                          Padding(
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

                                          const SizedBox(height: 16),

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
                                                onPressed: () {},
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

  Widget _buildTrackedTimeSection() {
    double tracked = 3.2;
    double total = 9.0;
    double progress = (total > 0) ? (tracked / total).clamp(0.0, 1.0) : 0.0;

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
            const Text(
              "03:20:00",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        _buildKeyValueRow("Full Time", "09:00:00"),
        _divider(),
        _buildKeyValueRow("Left", "05:40:00"),
        _divider(),
        _buildKeyValueRow("First In", "09:36:00"),
        _divider(),
        _buildKeyValueRow("Last Out", "15:20:00"),
        _divider(),
        _buildKeyValueRow("Total Break", "00:42:00"),
        _divider(),
        _buildKeyValueRow("Login Device", "Mobile", isLink: true),
        _divider(),
        _buildKeyValueRow("Device IP Address", "122486896326", isLink: true),
        _divider(),
        const SizedBox(height: 8),
        // View Activity button
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailScreen(),
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
    final records = [
      {
        "date": "18 Sept 2023",
        "time": "09:05:00",
        "firstHalf": "PR",
        "secondHalf": "PR",
        "break": "00:59",
        "color1": Colors.green,
        "color2": Colors.green,
      },
      {
        "date": "17 Sept 2023",
        "time": "09:02:00",
        "firstHalf": "PR",
        "secondHalf": "AB",
        "break": "01:15",
        "color1": Colors.green,
        "color2": Colors.red,
      },
      {
        "date": "16 Sept 2023",
        "time": "-",
        "firstHalf": "WO",
        "secondHalf": "WO",
        "break": "-",
        "color1": Colors.indigo,
        "color2": Colors.indigo,
      },
    ];

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
          ...records.map((record) {
            return Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                //#
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
                        record['date']?.toString() ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        record['time']?.toString() ?? '',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(4),
                    value: record['time'] == "-" ? 0.1 : 1,
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
                        record['firstHalf']?.toString() ?? '',
                        record['color1'] as Color,
                      ),
                      _statusColumn(
                        "Second Half",
                        record['secondHalf']?.toString() ?? '',
                        record['color2'] as Color,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Total Break",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          Text(
                            record['break']?.toString() ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
          SizedBox(height: 8),

          _divider(),
          SizedBox(height: 8),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
    if (day.day == 3 || day.day == 4 || day.day == 5) {
      return ["Present"];
    } else if (day.day == 10) {
      return ["Public Holiday"];
    } else if (day.day == 14) {
      return ["Half Day Absent"];
    } else if (day.day == 17) {
      return ["Absent"];
    }
    return [];
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
    print("Attendace Date $todayDateStr");
    getAttendanceDashData();


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
 /* getCheckInStatus() async {
    setState(() {
      attLoading=true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getWithToken(baseUrl, 'get-check-in-check-out', token, clientCode, context);
    //Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['success'] == true) {

      if(responseJSON['data']['attendanceLog']!=null){
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
  }*/
}
