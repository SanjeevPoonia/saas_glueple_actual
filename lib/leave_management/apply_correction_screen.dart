import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:saas_glueple/utils/gradient_button.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../widget/appbar.dart';

class ApplyCorrectionScreen extends StatefulWidget{
  final String alDate;
  final String alCheckIn;
  final String alcheckOut;
  final String attStatus;

  ApplyCorrectionScreen(
      this.alDate, this.alCheckIn, this.alcheckOut, this.attStatus);

  _applyCorrectionScreen createState()=> _applyCorrectionScreen();
}
class _applyCorrectionScreen extends State<ApplyCorrectionScreen>{
  String dateRageStr="Please Select Date";
  String applyDate="";
  String selectedInTime="";
  String selectedOutTime="";
  String checkInTime="";
  String checkOutTime="";
  bool isLoading=false;
  late var userIdStr;
  late var fullNameStr;
  late var designationStr;
  late var token;
  late var empId;
  late var baseUrl;
  late var platform;
  late var clientCode;
  var reasonController = TextEditingController();
  var reasonOutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int lastMonthLength=0;
  String HODName="";
  String managerName="";
  int ShowCorrectionCount=0;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Apply Correction',
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
      body:isLoading?const Center(): SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text("Date",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                            const SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                //_showDatePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                    color: AppTheme.themeGreenColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),


                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(dateRageStr,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Attendance Status",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                            const SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                // _showDatePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                  color: AppTheme.themeGreenColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(widget.attStatus,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                        children: [
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("Actual Check In",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                              const SizedBox( height: 5,),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                  color: AppTheme.themeGreenColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(widget.alCheckIn,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),),
                            ],),),
                          const SizedBox(width: 5,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Actual Check Out",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                              const SizedBox( height: 5,),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                  color: AppTheme.themeGreenColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(widget.alcheckOut,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),),),
                            ],
                          )),]
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Choose In Time",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                            const SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                _showInTimePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                  borderRadius: BorderRadius.circular(8),

                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(selectedInTime,style: TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                   /* SizedBox(width: 5,),
                                    SvgPicture.asset('assets/ic_clock_icon.svg',height: 21,width: 18,),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                        const SizedBox(width: 5,),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Choose Out Time",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                            const SizedBox( height: 5,),
                            InkWell(
                              onTap: (){
                                _showOutTimePicker();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: AppTheme.greyColor,width: 1.0),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(child: Text(selectedOutTime,style: const TextStyle(color: Colors.black,fontSize: 14.5,fontWeight: FontWeight.w500),)),
                                  /*  SizedBox(width: 5,),
                                    SvgPicture.asset('assets/ic_clock_icon.svg',height: 21,width: 18,),*/
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    const Text("Reason Check In",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                    const SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: reasonController,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        scrollPadding: EdgeInsets.only(bottom: 250),
                        maxLength: 500,
                        decoration: const InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    ),
                    const SizedBox(height: 10,),
                    const Text("Reason Check Out",style: TextStyle(fontSize: 14.5,color: AppTheme.themeBlueColor,fontWeight: FontWeight.w500),),
                    const SizedBox( height: 5,),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: AppTheme.greyColor,width: 1.0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: reasonOutController,
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        scrollPadding: const EdgeInsets.only(bottom: 150),
                        decoration: const InputDecoration(
                            border: InputBorder.none
                        ),
                      ),

                    ),
                    const SizedBox(height: 20,),
                    GradientButton(
                        height: 45,
                        text: "Submit For Approval",
                        onTap: (){
                          _checkTheValidation();
                    }),
                   /* TextButton(
                        onPressed: (){
                          // Navigator.of(context).pop();
                          _checkTheValidation();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.orangeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("Submit For Approval",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 16,color: Colors.white),),),
                        )
                    ),*/
                  ],
                ),
              ),),
          ],
        ),
      ),
    );

  }
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), () {
      _buildListItems();
    });


  }
  _showInTimePicker()async{
    Toast.show("Please Select In Time!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);
    var pickedTime= await showTimePicker(context: context, initialTime: TimeOfDay(hour: 09, minute: 00));
    if(pickedTime !=null){
      var datetime=DateFormat("hh:mm").parse("${pickedTime.hour}:${pickedTime.minute}");
      var selectedtime=DateFormat("hh:mm a").format(datetime);
      checkInTime=DateFormat("HH:mm:ss").format(datetime);
      print("Check In Time"+checkInTime);
      setState(() {
        selectedInTime=selectedtime;
      });


      // _showOutTimePicker();

    }
  }
  _showOutTimePicker()async{
    Toast.show("Please Select Out Time!!!",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red);
    var pickedTime= await showTimePicker(context: context, initialTime: TimeOfDay(hour: 18, minute: 00));
    if(pickedTime !=null){
      var datetime=DateFormat("hh:mm").parse("${pickedTime.hour}:${pickedTime.minute}");
      var selectedtime=DateFormat("hh:mm a").format(datetime);
      checkOutTime=DateFormat("HH:mm:ss").format(datetime);
      print("Check Out time"+checkOutTime);


      setState(() {
        selectedOutTime=selectedtime;
      });

    }
  }
  _checkTheValidation(){
    FocusScope.of(context).unfocus();
    var chekIn=reasonController.text.toString();
    var chOut=reasonOutController.text.toString();


    if(applyDate.isEmpty){
      Toast.show("Please Select Date",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(checkInTime.isEmpty){
      Toast.show("Please Select Check In Time",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(checkOutTime.isEmpty){
      Toast.show("Please Select Check Out Time",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(!hasFiveWords(chekIn)){
      Toast.show("Please enter Minimum 5 Words Reason for Check In Correction.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }else if(!hasFiveWords(chOut)){
      Toast.show("Please enter Minimum 5 Words Reason for Check Out Correction.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }/*else if(ShowCorrectionCount>4){
      _showCorrectionConfirmation();
    }*/else{
      _applyCorrectionOnServer();
    }
  }
  _applyCorrectionOnServer()async{


    APIDialog.showAlertDialog(context, 'Please Wait...');
    var requestModel = {
      "actual_check_in_time":widget.alCheckIn,
      "actual_check_out_time":widget.alcheckOut,
      "corrected_break":"",
      "attendance_logs":[],
      "emp_id": userIdStr,
      "date":applyDate,
      "correction_check_in_time":checkInTime,
      "correction_check_out_time":checkOutTime,
      "check_in_reason":reasonController.text.toString(),
      "check_out_reason":reasonOutController.text.toString(),
      "type":"Full Day"
    };
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader(baseUrl, 'apply-attendance-correction',requestModel,context, token,clientCode);
    Navigator.pop(context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);
    if (responseJSON['error'] == false) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      if(responseJSON['code']==200){
        _showCustomDialog(responseJSON['message']);
      }
    }else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

  }
  _buildListItems() async{


    print("already Date"+widget.alDate);
    print("already Check In"+widget.alCheckIn);
    print("already Check Out"+widget.alcheckOut);

    APIDialog.showAlertDialog(context, "Please Wait...");
    setState(() {
      isLoading=true;
    });
    var nDate=DateFormat("yyyy-MM-dd").parse(widget.alDate);
    applyDate= widget.alDate;
    var tDate= DateFormat("dd MMM yyyy").format(nDate);
    dateRageStr=tDate;
    if(widget.alCheckIn.isNotEmpty&&widget.alCheckIn!="00:00:00" && widget.alCheckIn!="0" && widget.alCheckIn!="Invalid date"){
      var chInTime=DateTime.parse(widget.alCheckIn);
      var selectedtime=DateFormat("hh:mm a").format(chInTime);
      checkInTime=widget.alCheckIn;
      selectedInTime=selectedtime;
      print("Check In Time"+checkInTime);
    }

    if(widget.alcheckOut.isNotEmpty&&widget.alcheckOut!="00:00:00" && widget.alcheckOut!="0" && widget.alcheckOut!="Invalid date"){
      var chOutTime=DateTime.parse(widget.alcheckOut);
      var selectedtime=DateFormat("hh:mm a").format(chOutTime);
      checkOutTime=widget.alcheckOut;
      selectedOutTime=selectedtime;
      print("Check out Time"+checkOutTime);
    }









    userIdStr = await MyUtils.getSharedPreferences("user_id");
    fullNameStr = await MyUtils.getSharedPreferences("full_name");
    token = await MyUtils.getSharedPreferences("token") ?? "";
    designationStr = await MyUtils.getSharedPreferences("designation");
    empId = await MyUtils.getSharedPreferences("user_id");
    baseUrl = await MyUtils.getSharedPreferences("base_url");
    clientCode = await MyUtils.getSharedPreferences("client_code") ?? "";

    if (Platform.isAndroid) {
      platform = "Android";
    } else if (Platform.isIOS) {
      platform = "iOS";
    } else {
      platform = "Other";
    }
    Navigator.pop(context);
    setState(() {
      isLoading = false;
    });

    //getCorrectionCount();

  }
  _showCustomDialog(String msg){
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
                          _finishTheScreen();
                        },
                        child: Icon(Icons.close_rounded,color: Colors.red,size: 20,),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: Lottie.asset("assets/tick.json"),
                    ),
                    SizedBox(height: 10,),
                    Align(
                      alignment: Alignment.center,
                      child: Text(msg,style: TextStyle(color: AppTheme.orangeColor,fontWeight: FontWeight.w900,fontSize: 18),),
                    ),
                    SizedBox(height: 20,),
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                          _finishTheScreen();
                          //call attendance punch in or out
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.themeColor,
                          ),
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          child: const Center(child: Text("Done",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.white),),),
                        )
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
  _finishTheScreen(){
    Navigator.of(context).pop();
  }
  bool hasFiveWords(String input) {

    final str=input.split(" ");
    List<String> mapList=[];
    for(int i=0;i<str.length;i++){
      var actualStr=str[i].trim();
      if(actualStr.isNotEmpty){
        mapList.add(actualStr);
      }

    }
    var vali=false;
    if(mapList.length>4){
      vali=true;
    }


    return vali;
  }

}