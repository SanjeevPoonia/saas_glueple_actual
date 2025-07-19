
import 'package:flutter/material.dart';
import 'package:saas_glueple/dialogs/successful_dialog.dart';
class CorrectionActivityBottomSheet extends StatefulWidget {
  @override
  State<CorrectionActivityBottomSheet> createState() =>
      _CorrectionActivityBottomSheet();
}

class _CorrectionActivityBottomSheet
    extends State<CorrectionActivityBottomSheet> {
  int selectedType = 0;
  TextEditingController subjectCtl = TextEditingController(
    text: "Office Party",
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
                      "Activity Correction",
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

                // TODO: checkout start date and end date containers

                // Start Date Container
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE6F7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Start Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              startDate,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE6F7FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "End Date",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              endDate,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),

                // Custom Time (From)
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Custom Time (From)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: _TimeSelector(),
                        ),
                      ),
                    ],
                  ),
                ),
                // Custom Time (To)
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFE6F7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Custom Time (To)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: _TimeSelector(),
                        ),
                      ),
                    ],
                  ),
                ),

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

                // Select Team Members Section
                SizedBox(height: 18),
                Text(
                  "Select Team Members",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 8),
                _TeamMembersList(),
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
                          title: "Activity Correction Applied Successfully",
                          type: "Activity Correction",
                          status: "Pending",
                          startDate: "July 22, 2023",
                          endDate: "July 24, 2023",
                          subject: "Lorem Ipsum",
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
                      "Apply Activity Correction",
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

class _TimeSelector extends StatefulWidget {
  @override
  State<_TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<_TimeSelector> {
  int hour = 9;
  int minute = 0;
  bool isAM = true;

  void _incHour() => setState(() => hour = hour == 12 ? 1 : hour + 1);
  void _decHour() => setState(() => hour = hour == 1 ? 12 : hour - 1);
  void _incMinute() => setState(() => minute = (minute + 1) % 60);
  void _decMinute() => setState(() => minute = (minute - 1 + 60) % 60);
  void _toggleAMPM() => setState(() => isAM = !isAM);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _arrowButton(Icons.chevron_left, _decHour),
        Text(
          hour.toString().padLeft(2, '0') +
              ':' +
              minute.toString().padLeft(2, '0'),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        _arrowButton(Icons.chevron_right, _incHour),
        SizedBox(width: 12),
        _arrowButton(Icons.chevron_left, _decMinute),
        Text(
          isAM ? 'AM' : 'PM',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        _arrowButton(Icons.chevron_right, _toggleAMPM),
      ],
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 32,
      height: 32,
      child: Material(
        color: Color.fromARGB(66, 27, 130, 164),
        borderRadius: BorderRadius.circular(1),
        child: InkWell(
          borderRadius: BorderRadius.circular(1),
          onTap: onTap,
          child: Center(child: Icon(icon, size: 32, color: Colors.black)),
        ),
      ),
    );
  }
}

class _TeamMembersList extends StatefulWidget {
  @override
  State<_TeamMembersList> createState() => _TeamMembersListState();
}

class _TeamMembersListState extends State<_TeamMembersList> {
  final List<Map<String, String>> members = [
    {"name": "Vaibhav Saini (Me)", "img": "assets/vaibhav.png"},
    {"name": "Rishabh Kumawat", "img": "assets/rishabh.png"},
    {"name": "Nikita Prajapat", "img": "assets/nikita.png"},
    {"name": "Vaibhav Saini (Me)", "img": "assets/vaibhav.png"},
    {"name": "Rishabh Kumawat", "img": "assets/rishabh.png"},
    {"name": "Nikita Prajapat", "img": "assets/nikita.png"},
  ];
  final Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: members.length,
      separatorBuilder: (_, __) => SizedBox(height: 8),
      itemBuilder: (context, i) {
        return Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(members[i]["img"]!),
              radius: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                members[i]["name"]!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Checkbox(
              value: selected.contains(i),
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selected.add(i);
                  } else {
                    selected.remove(i);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
