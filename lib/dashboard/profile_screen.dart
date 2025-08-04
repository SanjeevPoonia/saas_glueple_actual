import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../widget/appbar.dart';

class ProfileScreen extends StatefulWidget {
  _qdProfile createState() => _qdProfile();
}

class _qdProfile extends State<ProfileScreen> {
  bool isLoading = false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  var clientCode = "";

  String employeeIdStr = "";
  String NameStr = "";
  String joiningDate = "";
  String mobileNoStr = "";
  String emailStr = "";
  String departmentStr = "";
  String desiStr = "";
  String reportingManager = "";

  int offerLaterStatus = 0;
  int offerRejectedStatus = 0;
  int personalDetailsStatus = 0;
  int familyDetailsStatus = 0;
  int educationDetailsStatus = 0;
  int bankDetailsStatus = 0;
  int socialDetailsStatus = 0;
  int workExperienceDetailsStatus = 0;
  int referenceDetailsStatus = 0;
  int empPolicyDetyailsStatus = 0;
  int documentDetailsStatus = 0;

  String profileImage = "";

  XFile? imageFile;
  File? file;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 22,),
        ),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.themeGreenColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.only(
                      left: 8,
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            AppTheme.themeGreenColor, // Set the border color here
                        width: 1.0, // Set the border width
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              10.0,
                            ), // Adjust the top-left corner radius
                            topRight: Radius.circular(
                              10.0,
                            ), // Adjust the top-right corner radius
                          ),
                          child: Container(
                            height: 40,
                            color: AppTheme.themeGreenColor,
                            child: Center(
                              child: Text(
                                "Employee Information",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 100,
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // _showAlertDialog();
                                          },
                                          child: profileImage == ""
                                              ? CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    "assets/profile.png",
                                                  ),
                                                  radius: 50,
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        100.0,
                                                      ),
                                                  child: Image.network(
                                                    profileImage,
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                        ),
                                       /* Positioned(
                                          right: 5,
                                          bottom: 5,
                                          child: InkWell(
                                            onTap: () {
                                              _showAlertDialog();
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppTheme.themeGreenColor,
                                              ),
                                              width: 30,
                                              height: 30,
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),*/
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          NameStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Employee Id",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          employeeIdStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Joining Date",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          joiningDate,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Mobile Number",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          mobileNoStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Email",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          emailStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Department",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          departmentStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Designation",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          desiStr,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Reporting Manager",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          reportingManager,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900,
                                            color: AppTheme.themeColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),

                              clientCode == 'UB100'
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              // getUserLetter("offer_letter");
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppTheme.orangeColor,
                                              ),
                                              height: 45,
                                              child: const Center(
                                                child: Text(
                                                  "View Offer Letter",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () {
                                              // getUserLetter(
                                              //   "appointment_letter",
                                              // );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: AppTheme.themeColor,
                                              ),
                                              height: 45,
                                              child: const Center(
                                                child: Text(
                                                  "View Appointment Letter",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Rest of your UI cards (Personal Details, Family Details, etc.)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigation logic
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 8,
                              top: 16,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.orangeColor,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: personalDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        personalDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/book.json',
                                    height: 120,
                                    width: 100,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Personal Details',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigation logic
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 16,
                              top: 16,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme.orangeColor,
                                width: 1.0,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: familyDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        familyDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/family.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Family Details',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         EducationDetailsScreen(true),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 8,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: educationDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        educationDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/distance.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Education Details',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => BankDetailsScreen(true),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: bankDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        bankDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/bank.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Bank Details',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         WorkExperienceScreen(true),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 8,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: workExperienceDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        workExperienceDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/workExp.json',
                                    height: 120,
                                    width: 130,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Work Experience',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            // UploadDocumentScreen(true),
                            // ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: documentDetailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        documentDetailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/id.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Documents',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      /* Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=>SocialMediaDetailsScreen(true)));
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8,),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.orangeColor, // Set the border color here
                            width: 1.0, // Set the border width
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),  // Adjust the top-left corner radius
                              topRight: Radius.circular(10.0), // Adjust the top-right corner radius
                            ),
                            child: Container(
                              height: 20,
                              color: Color(0xFF1BA967),
                              child: Center(
                                child: Text(
                                  'Status : 100% Complete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Lottie.asset('assets/social.json',
                              height: 120,
                              width: 130,),
                          ),
                          SizedBox(height: 10.0),
                          Text('Social Media Details',
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black// Set the desired font size
                            ),
                          ),
                          SizedBox(height: 15.0),
                        ],
                      ),
                    ),
                  ),
                ),*/
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => PolicyDetailsScreen(
                            //       true,
                            //       empPolicyDetyailsStatus,
                            //     ),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: empPolicyDetyailsStatus == 1
                                        ? AppTheme.onBoarding_Completed
                                        : Colors.red,
                                    child: Center(
                                      child: Text(
                                        empPolicyDetyailsStatus == 1
                                            ? 'Status : 100% Complete'
                                            : 'Status : 0% Complete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/policy.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'Company Policies',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => QDShowICardScreen(),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 8,
                              right: 16,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppTheme
                                    .orangeColor, // Set the border color here
                                width: 1.0, // Set the border width
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-left corner radius
                                    topRight: Radius.circular(
                                      10.0,
                                    ), // Adjust the top-right corner radius
                                  ),
                                  child: Container(
                                    height: 20,
                                    color: AppTheme.onBoarding_Completed,
                                    child: Center(
                                      child: Text(
                                        'Show ID Card',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Lottie.asset(
                                    'assets/id.json',
                                    height: 120,
                                    width: 180,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  'View ID Card',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors
                                        .black, // Set the desired font size
                                  ),
                                ),
                                SizedBox(height: 15.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    clientCode = await MyUtils.getSharedPreferences("client_code") ?? "";
    Navigator.of(context).pop();
    getUserProfile();
  }

  getUserProfile() async {
    // Don't show another loading dialog since we already have one
    ApiBaseHelper helper = ApiBaseHelper();
    try {
      var response = await helper.getWithToken(
        baseUrl,
        'get-profile',
        token,
        clientCode,
        context,
      );

      var responseJSON = json.decode(response.body);
      print("Profile Response: $responseJSON");

      // Updated condition to match the actual API response
      if (responseJSON['code'] == 200 && responseJSON['data'] != null) {
        List<dynamic> tempList = responseJSON['data'];
        if (tempList.isNotEmpty) {
          var profileData = tempList[0];

          // Map the API response fields to your variables
          employeeIdStr = profileData['emp_id']?.toString() ?? "";

          // Handle name from the API response
          if (profileData['name'] != null) {
            NameStr = profileData['name'].toString();
          } else if (profileData['first_name'] != null) {
            NameStr = profileData['first_name'].toString();
            if (profileData['last_name'] != null) {
              NameStr = "$NameStr ${profileData['last_name']}";
            }
          }

          // Format joining date
          if (profileData['joining_date'] != null) {
            try {
              var dateTime = DateTime.parse(profileData['joining_date']);
              joiningDate = DateFormat("MMM d, yyyy").format(dateTime);
            } catch (e) {
              joiningDate = profileData['joining_date'].toString();
            }
          }

          mobileNoStr =
              profileData['personal_mobile']?.toString() ??
              profileData['mobile']?.toString() ??
              "";
          emailStr =
              profileData['personal_email']?.toString() ??
              profileData['email']?.toString() ??
              "";
          departmentStr = profileData['department_name']?.toString() ?? "";
          desiStr = profileData['designation_name']?.toString() ?? "";
          reportingManager = profileData['reported_to_name']?.toString() ?? "";

          // Handle profile image if available
          if (profileData['profile_image'] != null) {
            profileImage = profileData['profile_image'].toString();
          }
        }

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

  _showAlertDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Profile Image",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
            fontSize: 18,
          ),
        ),
        content: const Text(
          "Select the Image From",
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Add gallery selection logic here
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.themeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  "Gallery",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Add camera selection logic here
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.orangeColor,
              ),
              height: 45,
              padding: const EdgeInsets.all(10),
              child: const Center(
                child: Text(
                  "Camera",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
