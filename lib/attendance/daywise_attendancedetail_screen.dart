import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:saas_glueple/leave_management/apply_correction_screen.dart';
import 'package:saas_glueple/leave_management/leave_management_screen.dart';
import 'package:saas_glueple/utils/app_theme.dart';
import 'package:toast/toast.dart';
import '../network/loader.dart';
import '../widget/appbar.dart';
import 'package:intl/intl.dart';

class DayWiseAttendanceDetailsScreen extends StatefulWidget{

  var record;
  String fullWorkHour;
  DayWiseAttendanceDetailsScreen(this.fullWorkHour,this.record);
  _dayWiseState createState()=>_dayWiseState();
}
class _dayWiseState extends State<DayWiseAttendanceDetailsScreen>{

  bool attDashboardLoading=false;
  String dateStr="";
  String selectedDay="Week Day";
  String selectedDateStr="08 Aug 2025";
  String totalWorkingHour="00:00:00";

  String fullDayWorkingHour="09:00";
  String checkInTime="";
  String checkOutTime="";
  String inTime="-";
  String outTime="-";
  String loginDevice="";
  String first_half_status="PR";
  String second_half_status="AB";
  var firstHalfColor=AppTheme.PColor;
  var secondHalfColor=AppTheme.PColor;
  String totalBreakHour="00:00";
  String attendanceStatus="";

  @override
  void initState() {
    super.initState();
    fetchValue();
  }

  void fetchValue(){

    var record=widget.record;
    if(record['attendance_status']!=null){
      attendanceStatus=record['attendance_status'].toString();
    }
    if(record['first_check_in_time']!=null && record['first_check_in_time'].toString().isNotEmpty ){
      checkInTime=record['first_check_in_time'].toString();
      print("FirstCheckInTime ${record['first_check_in_time']}");
      DateTime fy=DateTime.parse(record['first_check_in_time'].toString());
      inTime=DateFormat("hh:mm a").format(fy);
    }
    if(record['last_check_out_time']!=null && record['last_check_out_time'].toString().isNotEmpty){
      checkOutTime=record['last_check_out_time'].toString();
      DateTime fy=DateTime.parse(record['last_check_out_time'].toString());
      outTime=DateFormat("hh:mm a").format(fy);
    }
    if(record['day_of_week']!=null){
      selectedDay=record['day_of_week'].toString();
    }
    if(record['attendance_date']!=null && record['attendance_date'].toString().isNotEmpty){
      dateStr=record['attendance_date'].toString();
      DateTime fy=DateTime.parse(record['attendance_date'].toString());
      selectedDateStr=DateFormat("dd MMM yyyy").format(fy);
    }

    if(record['total_working_hours']!=null){
      totalWorkingHour=record['total_working_hours'].toString();
    }

    if(record['total_break_time']!=null){
      totalBreakHour=record['total_break_time'].toString();
    }

    if(record['first_half_status']!=null){
      first_half_status=record['first_half_status'].toString();
    }

    if(record['second_half_status']!=null){
      second_half_status=record['second_half_status'].toString();
    }


    if(first_half_status=="PR"){
      firstHalfColor=AppTheme.PColor;
    }else if(first_half_status=="AB"){
      firstHalfColor=AppTheme.ABColor;
    }else{
      firstHalfColor=AppTheme.themeBlueColor;
    }
    if(second_half_status=="PR"){
      secondHalfColor=AppTheme.PColor;
    }else if(second_half_status=="AB"){
      secondHalfColor=AppTheme.ABColor;
    }else{
      secondHalfColor=AppTheme.themeBlueColor;
    }

    setState(() {

    });
  }


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
                                    top: 20,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 18,
                                                right: 18,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    selectedDay,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 26,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),

                                                  // SizedBox(height: 2),
                                                  Text(
                                                    selectedDateStr,
                                                    style: TextStyle(
                                                      color:
                                                      Colors.black54,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 24,),
                                            Container(
                                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.white.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 10,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child:  Row(
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
                                            Padding(padding: EdgeInsets.symmetric(horizontal: 18),
                                            child:  Row(

                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap:  (){
                                                      Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => const LeaveManagementScreen(),
                                                                ),
                                                             );
                                                    },
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:AppTheme.themeGreenColor,
                                                        borderRadius: BorderRadius.circular(7,),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "Leave Management",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color: Colors.white// Darker grey for unselected
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>  ApplyCorrectionScreen(
                                                              dateStr,
                                                              checkInTime,
                                                              checkOutTime,
                                                              attendanceStatus
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color:AppTheme.themeBlueColor,
                                                        borderRadius: BorderRadius.circular(7,),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          "Apply Correction",
                                                          style: TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            color:Colors.white
                                                            // Darker grey for unselected
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),

                                          ],
                                        ),
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
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    return "${twoDigits(hours)}:${twoDigits(minutes)}";
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
  Widget _buildTrackedTimeSection() {

    double progress = calculateCompletedPercentage(totalWorkingHour, widget.fullWorkHour);
    Duration duration1 = parseDuration(totalWorkingHour);
    Duration duration2 = parseDuration(widget.fullWorkHour);
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
              totalWorkingHour,
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
        _buildKeyValueRow("Total Break", totalBreakHour),
        _divider(),
        /*_buildKeyValueRow("Login Device", loginDevice, isLink: true),
        _divider(),*/
        // _buildKeyValueRow("Device IP Address", "122486896326", isLink: true),
        // _divider(),
        const SizedBox(height: 8),
        // View Activity button
        Center(
          child: GestureDetector(
            onTap: () {
              String todayDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AttendanceDetailScreen(todayDate),
                ),
              );*/
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
  Widget _divider() => const Divider(height: 1, color: Color(0xFFE0E0E0));
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
  Duration parseDuration(String input) {
    List<String> parts = input.split(":");

    int hours = int.parse(parts[0]);
    int minutes = parts.length > 1 ? int.parse(parts[1]) : 0;
    int seconds = parts.length > 2 ? int.parse(parts[2]) : 0;

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}