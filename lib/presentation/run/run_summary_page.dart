import 'package:flutter/material.dart';
import '../homepage/dashboard.dart';

class RunSummaryPage extends StatelessWidget {
  final String selectedMode;
  final Duration totalTime;
  final double distanceKm;
  final double averagePace; 
  final int calories;
  final List<String> achievements;

  const RunSummaryPage({
    super.key,
    required this.selectedMode,
    required this.totalTime,
    required this.distanceKm,
    required this.averagePace,
    required this.calories,
    this.achievements = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCongratulations(),
                      const SizedBox(height: 32),
                      _buildRunStats(),
                      const SizedBox(height: 32),
                      if (achievements.isNotEmpty) ...[
                        _buildAchievements(),
                        const SizedBox(height: 32),
                      ],
                      _buildButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.emoji_events, color: Color(0xff3abeff), size: 32),
        SizedBox(width: 16),
        Text(
          'Run Complete!',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildCongratulations() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.directions_run, color: Color(0xff3abeff), size: 64),
          const SizedBox(height: 16),
          Text(
            'Great job completing your $selectedMode run!',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your run has been saved to your history.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xff888b94)),
          ),
        ],
      ),
    );
  }

  Widget _buildRunStats() {
    final minutes = totalTime.inMinutes;
    final seconds = totalTime.inSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final paceMinutes = averagePace.floor();
    final paceSeconds = ((averagePace - paceMinutes) * 60).round();
    final paceString =
        '${paceMinutes}:${paceSeconds.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Run Summary',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.timer,
                title: 'Time',
                value: timeString,
                unit: 'min',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.straighten,
                title: 'Distance',
                value: distanceKm.toStringAsFixed(2),
                unit: 'km',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.speed,
                title: 'Avg Pace',
                value: paceString,
                unit: 'min/km',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.local_fire_department,
                title: 'Calories',
                value: calories.toString(),
                unit: 'kcal',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String unit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xff3abeff), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Color(0xff888b94)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(fontSize: 12, color: Color(0xff888b94)),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0x193abeff),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: achievements
                .map(
                  (achievement) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffffd700),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          achievement,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
              (Route<dynamic> route) => false,
            );
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xff3abeff),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Back to Dashboard',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff121212),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Share functionality coming soon!'),
                backgroundColor: Color(0xff3abeff),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xff3abeff), width: 1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'Share Results',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff3abeff),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
