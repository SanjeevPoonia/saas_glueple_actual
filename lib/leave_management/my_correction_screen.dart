import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../widget/appbar.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class MyCorrectionScreen extends StatefulWidget{
  _correctionState createState()=> _correctionState();
}
class _correctionState extends State<MyCorrectionScreen>{
  int selectedCenter = 0;
  bool isLoading = false;

  late var token;
  late var baseUrl;
  String? clientCode;
  late var employeeId;

  List<dynamic> pendingLeaves = [];
  List<dynamic> cancelledLeaves = [];

  List<dynamic> approvedLeaves = [];
  List<dynamic> rejectedLeaves = [];
  @override
  void initState() {
    super.initState();
    _initializeData();
  }
  _initializeData() async {
    setState(() {
      isLoading = true;
    });

    token = await MyUtils.getSharedPreferences("token");
    baseUrl = await MyUtils.getSharedPreferences("base_url");
    clientCode = await MyUtils.getSharedPreferences("client_code") ?? "";

    await _fetchLeaveData();

    setState(() {
      isLoading = false;
    });
  }
  _fetchLeaveData() async {
    // For pending and cancelled leaves (these are handled together in one API call)
    await _getLeaveList("pending");
    await _getLeaveList("cancelled");
    // For approved and rejected leaves (these are handled together in one API call)
    await _getLeaveList("approve");
    await _getLeaveList("reject");
  }
  _getLeaveList(String status) async {
    try {
      ApiBaseHelper helper = ApiBaseHelper();
      String apiStatus = status;
      if (status == 'pending') {
        apiStatus = 'pending';
      } else if (status == 'cancelled') {
        apiStatus = 'cancelled';
      } else if (status == 'approve') {
        apiStatus = 'approve';
      } else if (status == 'reject') {
        apiStatus = 'reject';
      }

      var response = await helper.getWithToken(
        baseUrl,
        'get-attendance-correction-request?page=1&limit=100&request_for=applied&parameter=attendance_correction&status=$apiStatus',
        token,
        clientCode!,
        context,
      );

      var responseJSON = json.decode(response.body);
      print("$status Correction response: $responseJSON");
      if (responseJSON['code'] == 200 && responseJSON['data'] != null) {
        // Check if data is in the nested 'data' array within the response
        List<dynamic> leaveData = [];
        if (responseJSON['data'] is Map &&
            responseJSON['data']['data'] != null) {
          leaveData = responseJSON['data']['data'] ?? [];
        } else if (responseJSON['data'] is List) {
          leaveData = responseJSON['data'] ?? [];
        }

        // Filter leaves based on status and is_cancel flag
        List<dynamic> filteredLeaves = [];
        if (status == 'pending') {
          filteredLeaves = leaveData
              .where(
                (leave) =>
            leave['approvers_status'] == 'pending'
          )
              .toList();
        }  else if (status == 'approve') {
          filteredLeaves = leaveData
              .where((leave) => leave['approvers_status'] == 'approve')
              .toList();
        } else if (status == 'reject') {
          filteredLeaves = leaveData
              .where((leave) => leave['approvers_status'] == 'reject')
              .toList();
        }

        // Update the appropriate list based on the status
        setState(() {
          switch (status) {
            case "pending":
              pendingLeaves = filteredLeaves;
              break;
            case "cancelled":
              cancelledLeaves = filteredLeaves;
              break;
            case "approve":
              approvedLeaves = filteredLeaves;
              // Also update rejected leaves from the same API response
              var rejected = leaveData
                  .where((leave) => leave['approvers_status'] == 'reject')
                  .toList();
              rejectedLeaves = rejected;
              break;
            case "reject":
            // This case is handled in the 'approve' case
              break;
          }
        });
      }
    } catch (e) {
      print("Error fetching $status leaves: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Applied Corrections',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          /*  IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              // Add notification logic
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
          // Fixed glowing background
          IgnorePointer(
            child: Stack(
              children: [
                Positioned(
                  top: 75,
                  left: -5,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C797).withOpacity(0.8),
                          blurRadius: 100,
                          spreadRadius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  right: -10,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1B81A4).withOpacity(0.8),
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

          SafeArea(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(color: Color(0xFF1B81A4)),
            )
                : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedCenter = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedCenter == 0
                                      ? Color(0xFF1B81A4)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: Text(
                                    "Pending",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedCenter == 0
                                          ? Colors.white
                                          : Color(0xFF1B81A4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => selectedCenter = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedCenter == 1
                                      ? Color(0xFF1B81A4)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Center(
                                  child: Text(
                                    "Approved/Rejected",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedCenter == 1
                                          ? Colors.white
                                          : Color(0xFF1B81A4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: selectedCenter == 0
                        ? _buildPendingCancelledLeaves()
                        : _buildApprovedRejectedLeaves(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPendingCancelledLeaves() {
    List<dynamic> combinedLeaves = [...pendingLeaves, ...cancelledLeaves];

    if (combinedLeaves.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              "No Pending Corrections",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: combinedLeaves.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, pos) {
        var leave = combinedLeaves[pos];
        String checkINreason=combinedLeaves[pos]['check_in_reason']!=null?combinedLeaves[pos]['check_in_reason'].toString():"";
        String checkoutreason=combinedLeaves[pos]['check_out_reason']!=null?combinedLeaves[pos]['check_out_reason'].toString():"";
        String reason=combinedLeaves[pos]['reason']!=null?combinedLeaves[pos]['reason'].toString():"";
        String status=combinedLeaves[pos]['approvers_status']!=null?combinedLeaves[pos]['approvers_status'].toString():"";
        String correction_date=combinedLeaves[pos]['date']!=null?combinedLeaves[pos]['date'].toString():"";
        String correction_check_in_time=combinedLeaves[pos]['correction_check_in_time']!=null?combinedLeaves[pos]['correction_check_in_time'].toString():"";
        String correction_check_out_time=combinedLeaves[pos]['correction_check_out_time']!=null?combinedLeaves[pos]['correction_check_out_time'].toString():"";
        String type=combinedLeaves[pos]['type']!=null?combinedLeaves[pos]['type'].toString():"";
        String formattedDate = '';
        if (correction_date.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_date);
            formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);
          } catch (e) {
            formattedDate = correction_date;
          }
        }
        String checkInTime = '';
        if (correction_check_in_time.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_check_in_time);
            checkInTime = DateFormat("hh:mm a").format(dateTime);
          } catch (e) {
            checkInTime = correction_check_in_time;
          }
        }
        String checkOutTime = '';
        if (correction_check_out_time.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_check_out_time);
            checkOutTime = DateFormat("hh:mm a").format(dateTime);
          } catch (e) {
            checkOutTime = correction_date;
          }
        }


        Color statusColor;
        String statusText;
        switch (status.toLowerCase()) {
          case 'pending':
            statusColor = Color(0xFFF5DD09);
            statusText = 'Pending';
            break;
          case 'cancelled':
            statusColor = Color(0xFFFF0000);
            statusText = 'Cancelled';
            break;
          case 'approve':
            statusColor = Color(0xFF1D963A);
            statusText = 'Approved';
            break;
          case 'reject':
            statusColor = Color(0xFFFF0000);
            statusText = 'Rejected';
            break;
          default:
            statusColor = Colors.grey;
            statusText = 'Unknown';
        }

        return Column(
          children: [
            _buildCorrectionItem(formattedDate, statusText, statusColor, checkINreason, checkoutreason, reason, checkInTime, checkOutTime, type),
            SizedBox(height: 10,)
          ],
        );
      },
    );
  }
  Widget _buildApprovedRejectedLeaves() {
    List<dynamic> combinedLeaves = [...approvedLeaves, ...rejectedLeaves];

    if (combinedLeaves.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 50),
            Icon(Icons.event_busy, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              "No Accepted/Rejected Corrections",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: combinedLeaves.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, pos) {
        var leave = combinedLeaves[pos];
        String checkINreason=combinedLeaves[pos]['check_in_reason']!=null?combinedLeaves[pos]['check_in_reason'].toString():"";
        String checkoutreason=combinedLeaves[pos]['check_out_reason']!=null?combinedLeaves[pos]['check_out_reason'].toString():"";
        String reason=combinedLeaves[pos]['reason']!=null?combinedLeaves[pos]['reason'].toString():"";
        String status=combinedLeaves[pos]['approvers_status']!=null?combinedLeaves[pos]['approvers_status'].toString():"";
        String correction_date=combinedLeaves[pos]['date']!=null?combinedLeaves[pos]['date'].toString():"";
        String correction_check_in_time=combinedLeaves[pos]['correction_check_in_time']!=null?combinedLeaves[pos]['correction_check_in_time'].toString():"";
        String correction_check_out_time=combinedLeaves[pos]['correction_check_out_time']!=null?combinedLeaves[pos]['correction_check_out_time'].toString():"";
        String type=combinedLeaves[pos]['type']!=null?combinedLeaves[pos]['type'].toString():"";
        String formattedDate = '';
        if (correction_date.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_date);
            formattedDate = DateFormat("dd-MM-yyyy").format(dateTime);
          } catch (e) {
            formattedDate = correction_date;
          }
        }
        String checkInTime = '';
        if (correction_check_in_time.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_check_in_time);
            checkInTime = DateFormat("hh:mm a").format(dateTime);
          } catch (e) {
            checkInTime = correction_check_in_time;
          }
        }
        String checkOutTime = '';
        if (correction_check_out_time.isNotEmpty) {
          try {
            DateTime dateTime = DateTime.parse(correction_check_out_time);
            checkOutTime = DateFormat("hh:mm a").format(dateTime);
          } catch (e) {
            checkOutTime = correction_date;
          }
        }


        Color statusColor;
        String statusText;
        switch (status.toLowerCase()) {
          case 'pending':
            statusColor = Color(0xFFF5DD09);
            statusText = 'Pending';
            break;
          case 'cancelled':
            statusColor = Color(0xFFFF0000);
            statusText = 'Cancelled';
            break;
          case 'approve':
            statusColor = Color(0xFF1D963A);
            statusText = 'Approved';
            break;
          case 'reject':
            statusColor = Color(0xFFFF0000);
            statusText = 'Rejected';
            break;
          default:
            statusColor = Colors.grey;
            statusText = 'Unknown';
        }

        return Column(
          children: [
            _buildCorrectionItem(formattedDate, statusText, statusColor, checkINreason, checkoutreason, reason, checkInTime, checkOutTime, type),
            SizedBox(height: 10,)
          ],
        );
      },
    );
  }
  Widget _divider() => const Divider(height: 1, color: Color(0xFFE0E0E0));
  Widget _buildCorrectionItem(String date, String status, Color statusColor,String checkinReason,String checkoutReason,String reason,String checkInTime,String checkOutTime,String correctionType) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5FBFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: TextStyle(fontWeight: FontWeight.w800)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _divider(),
          SizedBox(height: 8),
          if (checkinReason != 'No reason provided' && checkinReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Check In Reason:- $checkinReason",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(height: 8),
          if (checkoutReason != 'No reason provided' && checkoutReason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Check Out Reason:- $checkoutReason",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(height: 8),
          if (reason != 'No reason provided' && reason.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                "Reason:- $reason",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Punch In',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    checkInTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.themeBlueColor,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final boxWidth = constraints.constrainWidth();
                      final dashWidth = 4.0;
                      final dashSpace = 4.0;
                      final dashCount = (boxWidth / (dashWidth + dashSpace))
                          .floor();
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(dashCount, (_) {
                          return Container(
                            width: dashWidth,
                            height: 1,
                            color: Colors.black,
                          );
                        }),
                      );
                    },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Punch Out',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    checkOutTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.themeBlueColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Center(
            child: Text(
              correctionType,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }


}