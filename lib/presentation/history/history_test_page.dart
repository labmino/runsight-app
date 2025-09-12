import 'package:flutter/material.dart';

import '../../app_module/data/model/run.dart';
import '../history/run_detail_page.dart';

class HistoryTestPage extends StatelessWidget {
  const HistoryTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dummy runs for testing
    final List<Run> dummyRuns = [
      Run(
        id: '1',
        userId: 'user1',
        deviceId: 'device1',
        sessionId: 'session1',
        title: 'Morning Run',
        notes:
            'Great morning run! Weather was perfect and felt strong throughout.',
        startedAt: DateTime.now().subtract(const Duration(hours: 2)),
        endedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        durationSeconds: 1800, // 30 minutes
        distanceMeters: 5000, // 5 km
        avgSpeedKmh: 10.0,
        maxSpeedKmh: 15.0,
        caloriesBurned: 400,
        stepsCount: 6500,
        startLatitude: -6.200000,
        startLongitude: 106.816666,
        endLatitude: -6.201000,
        endLongitude: 106.817666,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 30),
        ),
      ),
      Run(
        id: '2',
        userId: 'user1',
        deviceId: 'device1',
        sessionId: 'session2',
        title: 'Evening Jog',
        notes: 'Nice evening jog around the park.',
        startedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        endedAt: DateTime.now().subtract(
          const Duration(days: 1, hours: 2, minutes: 25),
        ),
        durationSeconds: 2100, // 35 minutes
        distanceMeters: 7000, // 7 km
        avgSpeedKmh: 12.0,
        maxSpeedKmh: 18.0,
        caloriesBurned: 520,
        stepsCount: 9100,
        startLatitude: -6.200000,
        startLongitude: 106.816666,
        endLatitude: -6.202000,
        endLongitude: 106.818666,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        updatedAt: DateTime.now().subtract(
          const Duration(days: 1, hours: 2, minutes: 25),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        title: const Text('Run History', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your recent running sessions',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: dummyRuns.length,
                itemBuilder: (context, index) {
                  final run = dummyRuns[index];
                  return _buildRunCard(context, run);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunCard(BuildContext context, Run run) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RunDetailPage(run: run)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xffffffff),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        run.title ?? 'Morning Run',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff1b1f3b),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatTime(run.startedAt),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff888b94),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.chevron_right, color: Color(0xff888b94)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem(
                    icon: Icons.straighten,
                    value: (run.distanceMeters! / 1000).toStringAsFixed(1),
                    unit: 'km',
                    color: const Color(0xff3abeff),
                  ),
                  _buildStatItem(
                    icon: Icons.timer,
                    value: (run.durationSeconds! / 60).round().toString(),
                    unit: 'min',
                    color: const Color(0xff10b981),
                  ),
                  _buildStatItem(
                    icon: Icons.speed,
                    value: run.avgSpeedKmh!.toStringAsFixed(1),
                    unit: 'km/h',
                    color: const Color(0xfff59e0b),
                  ),
                  _buildStatItem(
                    icon: Icons.local_fire_department,
                    value: run.caloriesBurned.toString(),
                    unit: 'cal',
                    color: const Color(0xffef4444),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xff1b1f3b),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 12, color: Color(0xff888b94)),
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
  }
}
