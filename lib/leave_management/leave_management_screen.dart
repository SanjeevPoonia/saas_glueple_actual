
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:toast/toast.dart';

import '../dialogs/activity_correction.dart';
import '../widget/appbar.dart';
import 'my_leave_screen.dart';

class LeaveManagementScreen extends StatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  State<LeaveManagementScreen> createState() => _LeaveManagementScreen();
}

class _LeaveManagementScreen extends State<LeaveManagementScreen> {
  int selectedCenter = 0;

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final DateTime _today = DateTime.now();

  DateTimeRange? selectedRange;
  final startCtl = TextEditingController(text: '22-04-2023');
  final endCtl = TextEditingController(text: '23-04-2023');
  final reasonCtl = TextEditingController(text: 'Lorem Ipsum is a dummy text');
  late int charCount;

  List TeamImages = [
    'assets/natasha.png',
    'assets/sagar.png',
    'assets/girlavatar.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white, // White background
      appBar: CustomAppBar(
        title: 'Leave Management',
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
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

          // Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Toggle (Dashboard / Calendar)
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
                              onTap: () => setState(() => selectedCenter = 0),
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
                                    "Dashboard",
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
                              onTap: () => setState(() => selectedCenter = 1),
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
                                    "Calendar",
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

                  const SizedBox(height: 24),
                  if (selectedCenter == 0)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Leave\nBalance",
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      height: 1, // Reduce line spacing
                                    ),
                                  ),
                                  // Add animation(assets/Automation.json)
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: Lottie.asset(
                                        'assets/Automation.json',
                                        repeat: true,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard("05", "Paid\nLeaves"),
                                  GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (ctx) => StatefulBuilder(
                                          builder:
                                              (
                                                BuildContext context,
                                                StateSetter setModalState,
                                              ) {
                                                return Container(
                                                  padding: EdgeInsets.all(14),
                                                  decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                    color: Colors.white,
                                                  ),
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 20,
                                                        vertical: 20,
                                                      ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        width: 100,
                                                        height: 7,
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                      ),

                                                      SizedBox(height: 20),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Team Leaves",
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                ctx,
                                                              ).pop();
                                                            },
                                                            child: Icon(
                                                              Icons.close,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8),
                                                      Divider(),
                                                      SizedBox(height: 8),

                                                      Expanded(
                                                        child: ListView.builder(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                16,
                                                              ),
                                                          itemCount:
                                                              5, // Number of cards
                                                          itemBuilder: (context, index) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    bottom: 16,
                                                                  ),
                                                              decoration: BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8,
                                                                    ),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    blurRadius:
                                                                        4,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                          0.1,
                                                                        ),
                                                                    offset:
                                                                        const Offset(
                                                                          0,
                                                                          2,
                                                                        ),
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Container(
                                                                    decoration: const BoxDecoration(
                                                                      color: Color(
                                                                        0xFF02C7A5,
                                                                      ),
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft:
                                                                            Radius.circular(
                                                                              8,
                                                                            ),
                                                                        topRight:
                                                                            Radius.circular(
                                                                              8,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          10,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const Text(
                                                                          '12-06-2023',
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.access_time,
                                                                              color: Colors.white,
                                                                              size: 16,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 4,
                                                                            ),
                                                                            Text(
                                                                              'Expire in 10 days',
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 13,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    color: const Color(
                                                                      0xFFE6F7FF,
                                                                    ),
                                                                    padding: const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          16,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: const [
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Manual credit',
                                                                            ),
                                                                            SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                            Text(
                                                                              '08 Hrs',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Availd Hrs',
                                                                            ),
                                                                            SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                            Text(
                                                                              '00 Hrs',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              'Available',
                                                                            ),
                                                                            SizedBox(
                                                                              height: 4,
                                                                            ),
                                                                            Text(
                                                                              '08 Hrs',
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 25,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 5,
                                                          ),

                                                          SizedBox(height: 18),
                                                        ],
                                                      ),
                                                      SizedBox(height: 15),
                                                      Container(
                                                        width: double.maxFinite,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              blurRadius: 10,
                                                            ),
                                                          ],
                                                          gradient:
                                                              LinearGradient(
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
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      20,
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
                                                          child: Text(
                                                            "Back",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 16,
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                        ),
                                      );
                                    },
                                    child: _buildStatCard(
                                      "1.5",
                                      "Comp\nOff Balance",
                                      Image.asset(
                                        'assets/arrow_right.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                                  _buildStatCard("00", "Sick\nLeave"),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatCard("00", "Sick\nLeave"),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // More content...
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Leave Request",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 10),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: double.maxFinite,
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          CorrectionActivityBottomSheet(),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    fixedSize: Size(double.maxFinite, 50),
                                    side: const BorderSide(
                                      color: Color(
                                        0xFF00C797,
                                      ), // Changed border color
                                      width: 1,
                                    ),
                                    shape:  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                        5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Color(0xFF00C797),
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {},
                                        child: const Text(
                                          'Apply',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF00C797),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Team Leaves",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                // height: 80,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(155, 0, 199, 152),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: 18),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (
                                          int i = 0;
                                          i < TeamImages.length;
                                          i++
                                        )
                                          Align(
                                            widthFactor: 0.5,
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                TeamImages[i],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(width: 18),

                                    Text(
                                      "and 5 more....",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
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
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (ctx) => StatefulBuilder(
                                              builder:
                                                  (
                                                    BuildContext context,
                                                    StateSetter setModalState,
                                                  ) {
                                                    return Container(
                                                      padding: EdgeInsets.all(
                                                        14,
                                                      ),
                                                      decoration: const BoxDecoration(
                                                        borderRadius: BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                15,
                                                              ),
                                                        ),
                                                        color: Colors.white,
                                                      ),
                                                      margin:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 20,
                                                          ),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 100,
                                                            height: 7,
                                                            decoration:
                                                                BoxDecoration(
                                                                  color: Colors
                                                                      .grey,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        15,
                                                                      ),
                                                                ),
                                                          ),

                                                          SizedBox(height: 20),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Team Leaves",
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                    ctx,
                                                                  ).pop();
                                                                },
                                                                child: Icon(
                                                                  Icons.close,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 20,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 8),
                                                          Divider(),
                                                          SizedBox(height: 8),

                                                          SizedBox(
                                                            height: 300,
                                                            child: ListView.builder(
                                                              shrinkWrap: true,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemCount: 7,
                                                              itemBuilder: (context, index) {
                                                                final isNatasha =
                                                                    index % 2 ==
                                                                    0;
                                                                final name =
                                                                    isNatasha
                                                                    ? 'Natasha Jain'
                                                                    : 'Sagar Sharma';
                                                                final image =
                                                                    isNatasha
                                                                    ? 'assets/natasha.png'
                                                                    : 'assets/sagar.png';
                                                                final date =
                                                                    '23.07.2023 - 26.07.2023';
                                                                final status =
                                                                    isNatasha
                                                                    ? 'on leave'
                                                                    : 'Planned';
                                                                final statusColor =
                                                                    isNatasha
                                                                    ? Colors
                                                                          .purple
                                                                    : Colors
                                                                          .blue;
                                                                final daysLeft =
                                                                    isNatasha
                                                                    ? '3 days left'
                                                                    : '5 days left';

                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets.symmetric(
                                                                        vertical:
                                                                            6.0,
                                                                      ),
                                                                  child: Row(
                                                                    children: [
                                                                      CircleAvatar(
                                                                        radius:
                                                                            24,
                                                                        backgroundImage:
                                                                            AssetImage(
                                                                              image,
                                                                            ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            12,
                                                                      ),
                                                                      Expanded(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              name,
                                                                              style: const TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            Text(
                                                                              date,
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.black54,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            status,
                                                                            style: TextStyle(
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: statusColor,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          Text(
                                                                            daysLeft,
                                                                            style: const TextStyle(
                                                                              fontSize: 12,
                                                                              color: Colors.black54,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 25,
                                                          ),
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 5,
                                                              ),

                                                              SizedBox(
                                                                height: 18,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 15),
                                                          Container(
                                                            width: double
                                                                .maxFinite,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black26,
                                                                  blurRadius:
                                                                      10,
                                                                ),
                                                              ],
                                                              gradient: LinearGradient(
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
                                                                Navigator.pop(
                                                                  context,
                                                                );
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          12,
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
                                                              child: Text(
                                                                "Back",
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 16,
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
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
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "View",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // My Leaves and My Corrections
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            children: [
                              _buildMyLeavesCard(),
                              SizedBox(height: 20),
                              _buildMyCorrectionsCard(),
                            ],
                          ),
                        ),
                      ],
                    ),

                  if (selectedCenter == 1)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: CalendarFormat.month,
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Color(0xFF304C9F),
                                shape: BoxShape.circle,
                              ),
                              selectedDecoration: BoxDecoration(
                                color: Color(0xFF00C797),
                                shape: BoxShape.circle,
                              ),
                              markerDecoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              weekendTextStyle: TextStyle(color: Colors.red),
                            ),
                            headerStyle: HeaderStyle(
                              titleTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              formatButtonVisible: false,
                              titleCentered: true,
                              leftChevronIcon: Icon(Icons.arrow_back_ios),
                              rightChevronIcon: Icon(Icons.arrow_forward_ios),
                            ),
                            eventLoader: (day) => _getEventsForDay(day),
                            selectedDayPredicate: (day) {
                              return isSameDay(day, _selectedDay);
                            },
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                            },
                            calendarBuilders: CalendarBuilders(
                              selectedBuilder: (context, day, focusedDay) {
                                final events = _getEventsForDay(day);
                                if (events.isNotEmpty) {
                                  String event = events.first;
                                  Color color;
                                  String abbr;
                                  if (event == "Present") {
                                    color = Colors.green;
                                    abbr = "PR";
                                  } else if (event == "Absent") {
                                    color = Colors.red;
                                    abbr = "AB";
                                  } else if (event == "Week Off") {
                                    color = Colors.indigo;
                                    abbr = "WO";
                                  } else if (event == "Public Holiday") {
                                    color = Color(0xFF2B7B8A);
                                    abbr = "PH";
                                  } else if (event == "Paid Leave") {
                                    color = Colors.indigo;
                                    abbr = "PL";
                                  } else if (event == "Leave w/o Pay") {
                                    color = Colors.orange;
                                    abbr = "LW";
                                  } else if (event == "Half Day Absent") {
                                    color = Color(0xFFFF0000);
                                    abbr = "HD";
                                  } else {
                                    color = Color(0xFF1B81A4);
                                    abbr = event.substring(0, 2).toUpperCase();
                                  }
                                  return CircleAvatar(
                                    backgroundColor: color,
                                    radius: 18,
                                    child: Text(
                                      abbr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                } else {
                                  return CircleAvatar(
                                    backgroundColor: Color(0xFF1B81A4),
                                    radius: 18,
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              },
                              todayBuilder: (context, day, focusedDay) {
                                if (!isSameDay(day, _selectedDay)) {
                                  return CircleAvatar(
                                    backgroundColor: Color(0xFF304C9F),
                                    radius: 18,
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                } else {
                                  return null;
                                }
                              },
                              defaultBuilder: (context, day, focusedDay) {
                                final events = _getEventsForDay(day);
                                if (events.isNotEmpty) {
                                  String event = events.first;
                                  Color color;
                                  if (event == "Present")
                                    color = Colors.green;
                                  else if (event == "Absent")
                                    color = Colors.red;
                                  else if (event == "Week Off")
                                    color = Colors.indigo;
                                  else if (event == "Public Holiday")
                                    color = Color(0xFF2B7B8A);
                                  else if (event == "Paid Leave")
                                    color = Colors.indigo;
                                  else if (event == "Leave w/o Pay")
                                    color = Colors.orange;
                                  else if (event == "Half Day Absent")
                                    color = Color(0xFFFF0000);
                                  else
                                    color = Color(0xFF1B81A4);
                                  return Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(
                                        color: color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                                return Center(
                                  child: Text(
                                    '${day.day}',
                                    style: TextStyle(color: Colors.black),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  _legend("Today", Color(0xFF304C9F), "T"),
                                  _legend("Present", Color(0xFF1D963A), "PR"),
                                  _legend(
                                    "Public Holiday",
                                    Color(0xFF2B7B8A),
                                    "PH",
                                  ),
                                  _legend("Week Off", Color(0xFF5C5959), "WO"),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _legend("Paid Leave", Colors.indigo, "PL"),
                                  _legend("Leave w/o Pay", Colors.orange, "LW"),
                                  _legend(
                                    "Half Day Absent",
                                    Color(0xFFFF0000),
                                    "HD",
                                  ),
                                  _legend("Absent", Colors.red, "AB"),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: EdgeInsets.all(0),
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

                        Center(
                          child: Container(
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                ),
                              ],
                              gradient: LinearGradient(
                                colors: [Color(0xFF00C797), Color(0xFF1B81A4)],
                              ),
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, [Image? image]) {
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
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1B81A4),
                ),
              ),
              Spacer(),
              if (image != null) image,
            ],
          ),
          SizedBox(height: 7),
          Text(
            label,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 15,
              height: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Add these helper widgets at the end of the class
  Widget _buildMyLeavesCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FAF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/calendar.png',
                  width: 28,
                  height: 28,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'My Leaves',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 8),
          _buildLeaveItem(
            'Unpaid Leave (UPL)',
            'Pending',
            Color(0xFFF5DD09),
            Color(0xFF1B81A4),
          ),
          SizedBox(height: 10),
          _buildLeaveItem(
            'Paid Leave (UPL)',
            'Pending',
            Color(0xFFF5DD09),
            Color(0xFF1B81A4),
          ),
          SizedBox(height: 10),
          Divider(color: Colors.grey.shade300),
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyLeaveScreen()),
                );
              },
              child: Text(
                'View All',

                style: TextStyle(
                  fontSize: 18,

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

  Widget _buildLeaveItem(
    String title,
    String status,
    Color statusColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF5FBFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('25-07-2023', style: TextStyle(fontWeight: FontWeight.w500)),
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
              Text('26-07-2023', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 4),
          Center(
            child: Text(
              '1 day',
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

  Widget _buildMyCorrectionsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FAF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/correction.png',
                  width: 28,
                  height: 28,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'My Corrections',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(color: Colors.grey.shade300),
          SizedBox(height: 8),
          _buildCorrectionItem('18 Sept 2023', 'Pending', Color(0xFFF5DD09)),
          SizedBox(height: 10),
          _buildCorrectionItem('18 Sept 2023', 'Approved', Color(0xFF4CAF50)),
          SizedBox(height: 10),
          Divider(color: Colors.grey.shade300),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: TextStyle(
                  fontSize: 18,
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

  Widget _buildCorrectionItem(String date, String status, Color statusColor) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'First Half',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'PR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D963A),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Second Half',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'AB',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF0000),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Correction Time',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '00:59:00',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
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
    return TextButton(
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

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
  );

  Widget _buildLabelRow(String left, String right) => Row(
    children: [
      _buildLabel(left),
      const Spacer(),
      Text(right, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ],
  );

  Widget _dateField(
    TextEditingController ctl,
    BuildContext ctx,
    ValueChanged<String> onChanged,
  ) {
    return GestureDetector(
      onTap: () async {},
      child: AbsorbPointer(
        child: TextFormField(
          controller: ctl,
          decoration: const InputDecoration(
            isDense: true,
            suffixIcon: Icon(Icons.calendar_today, size: 18),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          ),
        ),
      ),
    );
  }
}
