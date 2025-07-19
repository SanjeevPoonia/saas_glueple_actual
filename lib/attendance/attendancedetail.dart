import 'package:flutter/material.dart';

import '../widget/appbar.dart';




class AttendanceDetailScreen extends StatelessWidget {
  const AttendanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Attendance',
        leading: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.category, size: 30, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
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
                                        // shape: BoxShape.circle,
                                        // gradient: const LinearGradient(
                                        // color: Color(0xFF00C797),
                                        //   begin: Alignment.topLeft,
                                        //   end: Alignment.bottomRight,
                                        // ),
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
                                        // shape: BoxShape.circle,
                                        // gradient: const LinearGradient(
                                        // color: Color(0xFF1B81A4),
                                        // begin: Alignment.topRight,
                                        // end: Alignment.bottomLeft,
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
                                left: 0,
                                right: 0,
                                top: 32,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      SizedBox(height: 24),
                                      Text(
                                        'Today',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '19 Sept 2023',
                                        style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 200,
                                right: 0,
                                top: 10,
                                child: Center(
                                  child: Container(
                                    height: 170,
                                    width: 170,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.asset(
                                      'assets/boyimg.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 150,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Activity',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 16),
                                            _buildTimeline(),
                                            const SizedBox(height: 16),
                                            _buildPagination(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    final activities = [
      {'label': 'Entrance Gate\nIN', 'time': '10:00 AM'},
      {'label': 'Entrance Gate\nOUT', 'time': '10:38 AM'},
      {'label': 'Canteen Gate\nOUT', 'time': '01:38 PM'},
      {'label': 'Canteen Gate\nIN', 'time': '02:00 PM'},
      {'label': 'Entrance Gate\nOUT', 'time': '04:38 PM'},
      {'label': 'Entrance Gate\nIN', 'time': '04:58 PM'},
    ];
    return Column(
      children: List.generate(activities.length, (index) {
        final isLast = index == activities.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.brown.shade900,
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 46, color: Color(0xFF00C797)),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        activities[index]['label']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FAF6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(
                            'assets/facedetec.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          activities[index]['time']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPagination() {
    int activeIndex = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < 3; i++) _buildNumberedDot(i + 1, activeIndex == i),
        const Icon(Icons.more_horiz, size: 20, color: Colors.black26),
      ],
    );
  }

  Widget _buildNumberedDot(int number, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1B81A4) : Colors.white,
        border: Border.all(color: const Color(0xFF1B81A4)),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$number',
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF1B81A4),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
