import 'package:flutter/material.dart';

import '../dialogs/activity_correction.dart';
import '../dialogs/c_off_application.dart';
import '../dialogs/short_leave.dart';
import '../dialogs/tour_application.dart';
import '../dialogs/wfh_application.dart';
import 'apply_leaves.dart';


class LeaveManagementDialog extends StatefulWidget {
  @override
  State<LeaveManagementDialog> createState() => _LeaveManagementDialog();
}

class _LeaveManagementDialog extends State<LeaveManagementDialog> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: DraggableScrollableSheet(
        initialChildSize: 0.58,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 100,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Leave Management",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.search),
                    const SizedBox(width: 20),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 6),
                Column(
                  children: [
                    //  Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: const EdgeInsets.all(6),
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xFFE6FAF6),
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Image.asset(
                    //                 'assets/calendar_icon.png',
                    //                 width: 48,
                    //                 height: 48,
                    //               ),
                    //             ),
                    //             Text(
                    //               "Apply Leaves",
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w900,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           children: [
                    //             Container(
                    //               padding: const EdgeInsets.all(6),
                    //               decoration: BoxDecoration(
                    //                 color: const Color(0xFFE6FAF6),
                    //                 borderRadius: BorderRadius.circular(8),
                    //               ),
                    //               child: Image.asset(
                    //                 'assets/c_off_icon.png',
                    //                 width: 48,
                    //                 height: 48,
                    //               ),
                    //             ),
                    //             Text(
                    //               "Apply C-OFF",
                    //               style: TextStyle(
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w900,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ApplyLeaveScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/calendar_icon.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Apply Leaves",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          COFFApplicationBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/c_off_icon.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Apply C-OFF",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          TourApplicationBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/suitcase_icon.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Apply Tour",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          CorrectionActivityBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/edit_icon.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Attendence\nCorrection",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          ShortLeaveBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/timer.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Short Leave/\nOfficial In-Out",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          WFHApplicationBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/timer.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "WFH\nAttendance",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          CorrectionActivityBottomSheet(),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6FAF6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Image.asset(
                                      'assets/timer.png',
                                      width: 48,
                                      height: 48,
                                    ),
                                  ),
                                ),
                                const Text(
                                  "Activity\nCorrection",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      const BoxShadow(color: Colors.black26, blurRadius: 10),
                    ],
                    color: const Color(0xFF00C797),
                  ),
                  child: TextButton(
                    onPressed: () {},
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
                    child: const Text(
                      "Back",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}