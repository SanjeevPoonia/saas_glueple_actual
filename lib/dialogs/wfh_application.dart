
import 'package:flutter/material.dart';
import 'package:saas_glueple/dialogs/successful_dialog.dart';


class WFHApplicationBottomSheet extends StatefulWidget {
  @override
  State<WFHApplicationBottomSheet> createState() =>
      _WFHApplicationBottomSheet();
}

class _WFHApplicationBottomSheet extends State<WFHApplicationBottomSheet> {
  int selectedType = 0;
  TextEditingController subjectCtl = TextEditingController(
    text: "Leg Fracture",
  );
  TextEditingController reasonCtl = TextEditingController(
    text: "Lorem Ipsum is a dummy text",
  );
  String startDate = "22-04-2023";
  String endDate = "23-04-2023";
  int startDayType = 0; // 0: First Half, 1: Second Half, 2: Full Day
  int endDayType = 2;
  String? attachedFileName;

  final List<String> dayTypes = ["First Half", "Second Half", "Full Day"];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(14),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Spacer(),
                    Container(
                      width: 100,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Spacer(),
                  ],
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "WFH Application",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 8),
                // Subject Container (title inside)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F7FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Subject",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            "${subjectCtl.text.length}/50",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      TextField(
                        controller: subjectCtl,
                        maxLength: 50,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: "Enter subject",
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),

                // Start Date Container
                _dateContainer(
                  label: "Start Date",
                  date: startDate,
                  dayTypeIndex: startDayType,
                  onLeft: () =>
                      setState(() => startDayType = (startDayType - 1 + 3) % 3),
                  onRight: () =>
                      setState(() => startDayType = (startDayType + 1) % 3),
                ),
                SizedBox(height: 10),

                // End Date Container
                _dateContainer(
                  label: "End Date",
                  date: endDate,
                  dayTypeIndex: endDayType,
                  onLeft: () =>
                      setState(() => endDayType = (endDayType - 1 + 3) % 3),
                  onRight: () =>
                      setState(() => endDayType = (endDayType + 1) % 3),
                ),
                SizedBox(height: 10),

                // Reason Container (title inside)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F7FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Reason",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Spacer(),
                          Text(
                            "${reasonCtl.text.length}/500",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      TextField(
                        controller: reasonCtl,
                        maxLength: 500,
                        maxLines: 2,
                        decoration: InputDecoration(
                          counterText: "",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: "Enter reason",
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Attachment Container (empty by default)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F7FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.attach_file, color: Colors.blue),
                      SizedBox(width: 8),
                      attachedFileName == null
                          ? Text(
                              "Attachment",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Expanded(
                              child: Text(
                                attachedFileName!,
                                style: TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.blue),
                        onPressed: () async {
                          /*FilePickerResult? result = await FilePicker.platform
                              .pickFiles();
                          if (result != null && result.files.isNotEmpty) {
                            setState(() {
                              attachedFileName = result.files.single.name;
                            });
                          }*/
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24),

                // Apply Button
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                    gradient: LinearGradient(
                      colors: [Color(0xFF00C797), Color(0xFF1B81A4)],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SuccessfulBottomSheet(
                          title: "WFH Application Applied Successfully",
                          type: "WFH Application",
                          status: "Pending",
                          startDate: "July 22, 2023",
                          endDate: "July 24, 2023",
                          subject: "Leg Fracture",
                          appliedOn: "21 / 07 / 2023",
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Apply WFH",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateContainer({
    required String label,
    required String date,
    required int dayTypeIndex,
    required VoidCallback onLeft,
    required VoidCallback onRight,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFE6F7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
              Text(date, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Spacer(),
          SizedBox(
            width: 40,
            height: 40,
            child: Material(
              color: Color.fromARGB(102, 27, 130, 164),
              borderRadius: BorderRadius.circular(1),
              child: InkWell(
                borderRadius: BorderRadius.circular(1),
                onTap: onLeft,
                child: Center(
                  child: Icon(
                    Icons.chevron_left,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 90, // Fixed width for dayType text
            child: Center(
              child: Text(
                dayTypes[dayTypeIndex],
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: Material(
              color: Color.fromARGB(102, 27, 130, 164),
              borderRadius: BorderRadius.circular(1),
              child: InkWell(
                borderRadius: BorderRadius.circular(1),
                onTap: onRight,
                child: Center(
                  child: Icon(
                    Icons.chevron_right,
                    size: 40,
                    color: Colors.black,
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
