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
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 22,),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.themeGreenColor))
          : holidayList.length == 0
          ? const Align(
              alignment: Alignment.center,
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
              shrinkWrap: true,
              itemCount: holidayList.length,
              itemBuilder: (BuildContext cntx, int index) {
                String fromDate = "";
                String toDate = "";
                String noDays = "";
                String dayStr = "";
                String holiday = "";
                String holiday_type = "";
                String holidayFor = "";

                var backColor = AppTheme.task_progress_back;
                var textColor = AppTheme.themeColor;

                // Updated field mappings based on API response
                if (holidayList[index]['from_date'] != null) {
                  try {
                    var dateTime = DateFormat(
                      "yyyy-MM-dd",
                    ).parse(holidayList[index]['from_date']);
                    fromDate = DateFormat("MMM d,yyyy").format(dateTime);
                  } catch (e) {
                    fromDate = holidayList[index]['from_date'];
                  }
                }

                if (holidayList[index]['to_date'] != null) {
                  try {
                    var dateTime = DateFormat(
                      "yyyy-MM-dd",
                    ).parse(holidayList[index]['to_date']);
                    toDate = DateFormat("MMM d,yyyy").format(dateTime);
                  } catch (e) {
                    toDate = holidayList[index]['to_date'];
                  }
                }

                // Calculate days between dates
                if (holidayList[index]['from_date'] != null &&
                    holidayList[index]['to_date'] != null) {
                  try {
                    var fromDateTime = DateFormat(
                      "yyyy-MM-dd",
                    ).parse(holidayList[index]['from_date']);
                    var toDateTime = DateFormat(
                      "yyyy-MM-dd",
                    ).parse(holidayList[index]['to_date']);
                    noDays = (toDateTime.difference(fromDateTime).inDays + 1)
                        .toString();
                  } catch (e) {
                    noDays = "1";
                  }
                }

                if (holidayList[index]['name'] != null) {
                  holiday = holidayList[index]['name'];
                }

                // Check if restricted holiday
                if (holidayList[index]['restricted'] != null) {
                  holiday_type = holidayList[index]['restricted'] == true
                      ? "Restricted"
                      : "Public";
                }

                // Get gender restrictions if any
                if (holidayList[index]['gender'] != null &&
                    holidayList[index]['gender'].length > 0) {
                  List<dynamic> genderList = holidayList[index]['gender'];
                  if (genderList.length < 3) {
                    // Not for all genders
                    holidayFor = genderList.join(", ");
                  }else{
                    holidayFor="All";
                  }
                }

                print("Holiday Type: $holiday_type");
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.white,
                              border: Border.all(
                                color: AppTheme.orangeColor,
                                width: 1.0,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: 7, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Text(
                                    fromDate == toDate
                                        ? fromDate
                                        : "$fromDate - $toDate",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.themeColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  holidayFor.isNotEmpty
                                      ? Text(
                                          "Holiday For: $holidayFor",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Container(),
                                  SizedBox(height: 10),
                                  Text(
                                    holiday,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: AppTheme.orangeColor,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 15,
                      top: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: backColor,
                        ),
                        width: 80,
                        height: 30,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            holiday_type.isNotEmpty
                                ? holiday_type
                                : "Days: $noDays",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
