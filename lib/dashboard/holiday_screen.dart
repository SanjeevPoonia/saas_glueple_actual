import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../widget/appbar.dart';

class HolidayScreen extends StatefulWidget {
  _holidayList createState() => _holidayList();
}

class _holidayList extends State<HolidayScreen> {
  bool isLoading = false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  String? clientcode;
  List<dynamic> holidayList = [];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Holidays',
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
        ),
      ),
      backgroundColor: const Color(0xFFF5F7FA), // Light background for contrast
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.themeGreenColor))
          : holidayList.isEmpty
          ? const Center(
        child: Text(
          "No Holiday Available",
          style: TextStyle(
            fontSize: 17.5,
            color: AppTheme.themeBlueColor,
            fontWeight: FontWeight.w900,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: holidayList.length,
        itemBuilder: (context, index) {
          String fromDate = "";
          String toDate = "";
          String noDays = "";
          String holiday = "";
          String holiday_type = "";
          String holidayFor = "";

          if (holidayList[index]['from_date'] != null) {
            try {
              var dateTime = DateFormat("yyyy-MM-dd").parse(holidayList[index]['from_date']);
              fromDate = DateFormat("MMM d, yyyy").format(dateTime);
            } catch (e) {
              fromDate = holidayList[index]['from_date'];
            }
          }

          if (holidayList[index]['to_date'] != null) {
            try {
              var dateTime = DateFormat("yyyy-MM-dd").parse(holidayList[index]['to_date']);
              toDate = DateFormat("MMM d, yyyy").format(dateTime);
            } catch (e) {
              toDate = holidayList[index]['to_date'];
            }
          }

          if (holidayList[index]['from_date'] != null && holidayList[index]['to_date'] != null) {
            try {
              var from = DateFormat("yyyy-MM-dd").parse(holidayList[index]['from_date']);
              var to = DateFormat("yyyy-MM-dd").parse(holidayList[index]['to_date']);
              noDays = (to.difference(from).inDays + 1).toString();
            } catch (e) {
              noDays = "1";
            }
          }

          if (holidayList[index]['name'] != null) {
            holiday = holidayList[index]['name'];
          }

          if (holidayList[index]['restricted'] != null) {
            holiday_type = holidayList[index]['restricted'] == true ? "Restricted" : "Public";
          }

          if (holidayList[index]['gender'] != null && holidayList[index]['gender'].length > 0) {
            List<dynamic> genderList = holidayList[index]['gender'];
            holidayFor = genderList.length < 3 ? genderList.join(", ") : "All";
          }

          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            color: Colors.white,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fromDate == toDate ? fromDate : "$fromDate - $toDate",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.themeBlueColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (holidayFor.isNotEmpty)
                        Text(
                          "Holiday For: $holidayFor",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      if (holidayFor.isNotEmpty) const SizedBox(height: 10),
                      Text(
                        holiday,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.themeGreenColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: holiday_type == "Restricted"
                          ? Colors.orange.shade100
                          : AppTheme.themeGreenColor.withOpacity(0.2),
                    ),
                    child: Text(
                      holiday_type.isNotEmpty ? holiday_type : "Days: $noDays",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: holiday_type == "Restricted"
                            ? Colors.orange
                            : AppTheme.themeGreenColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _getDashboardData();
    });
  }

  _getDashboardData() async {
    setState(() {
      isLoading = true;
    });
    APIDialog.showAlertDialog(context, 'Please Wait...');
    userIdStr = await MyUtils.getSharedPreferences("user_id");
    fullNameStr = await MyUtils.getSharedPreferences("full_name");
    token = await MyUtils.getSharedPreferences("token");
    designationStr = await MyUtils.getSharedPreferences("designation");
    empId = await MyUtils.getSharedPreferences("emp_id");
    baseUrl = await MyUtils.getSharedPreferences("base_url");
    clientcode = await MyUtils.getSharedPreferences("client_code") ?? "";
    Navigator.of(context).pop(); // Remove loading dialog
    getLeaveList();
  }

  getLeaveList() async {
    // Don't show another loading dialog since we already have one
    ApiBaseHelper helper = ApiBaseHelper();
    try {
      var response = await helper.getWithToken(
        baseUrl,
        'get-holidays',
        token,
        clientcode!,
        context,
      );

      var responseJSON = json.decode(response.body);
      print("Response: $responseJSON");

      if (responseJSON['code'] == 200 && responseJSON['data'] != null) {
        holidayList.clear();
        holidayList = responseJSON['data'];
        setState(() {
          isLoading = false;
        });
      } else {
        Toast.show(
          responseJSON['message'] ?? "Something went wrong",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red,
        );
        setState(() {
          isLoading = false;
        });
        _finishScreens();
      }
    } catch (e) {
      print("Error: $e");
      Toast.show(
        "Network error occurred",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  _finishScreens() {
    Navigator.pop(context);
  }
}
