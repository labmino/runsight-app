import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controller/auth_controller.dart';
import '../../controller/run_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboardData();
    });
  }

  void _loadDashboardData() {
    final runController = Provider.of<RunController>(context, listen: false);
    runController.fetchRuns();
  }

  void _onNavBarTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
      case 2:
        Navigator.pushNamed(context, '/run');
        break;
      case 3:
        Navigator.pushNamed(context, '/community');
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  void _startRun() {
    Navigator.pushNamed(context, '/start-run');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xff1b1f3b)),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildYesterdayRunCard(),
                      const SizedBox(height: 24),
                      _buildWeeklyGoalCard(),
                      const SizedBox(height: 24),
                      _buildStartRunButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _onNavBarTap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 60, right: 24, bottom: 0),
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            final user = authController.currentUser;
            final userName = (user?.fullName?.trim().split(" ").where((e) => e.isNotEmpty).first) ?? 'User';
            final greeting = _getGreeting();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 28,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ready for your run?',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    color: const Color(0xff3abeff),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildYesterdayRunCard() {
    return Consumer<RunController>(
      builder: (context, runController, child) {
        final runs = runController.runs;
        final lastRun = runs.isNotEmpty ? runs.first : null;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0x193abeff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Latest Run',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    color: const Color(0xff3abeff),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 16),
                if (lastRun != null && lastRun.endedAt != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRunStat(
                        value: lastRun.formattedDistance.split(' ')[0],
                        unit: 'km',
                      ),
                      _buildRunStat(
                        value: _formatDurationToMinutes(
                          lastRun.durationSeconds ?? 0,
                        ),
                        unit: 'minutes',
                      ),
                      _buildRunStat(
                        value: _calculatePace(
                          lastRun.distanceMeters ?? 0,
                          lastRun.durationSeconds ?? 0,
                        ),
                        unit: 'min/km',
                      ),
                    ],
                  ),
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.directions_run,
                          size: 48,
                          color: const Color(0xff888b94),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No runs yet',
                          style: TextStyle(
                            color: const Color(0xff888b94),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Start your first run today!',
                          style: TextStyle(
                            color: const Color(0xff888b94),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRunStat({required String value, required String unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 24,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 12,
            color: const Color(0xff888b94),
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyGoalCard() {
    return Consumer<RunController>(
      builder: (context, runController, child) {
        final runsThisWeek = runController.getRunsThisWeek();
        final weeklyProgress = runsThisWeek.fold<double>(
          0.0,
          (sum, run) => sum + ((run.distanceMeters ?? 0.0) / 1000),
        );
        const double weeklyGoal = 15.0; 
        final progressPercentage = weeklyGoal > 0
            ? (weeklyProgress / weeklyGoal)
            : 0.0;
        final remaining = weeklyGoal - weeklyProgress;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0x193abeff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Weekly Goal',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        color: const Color(0xffffffff),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      '${weeklyProgress.toStringAsFixed(1)} / ${weeklyGoal.toStringAsFixed(1)} km',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 14,
                        color: const Color(0xff3abeff),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xff888b94),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: progressPercentage.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff3abeff),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Text(
                  remaining > 0
                      ? '${remaining.toStringAsFixed(1)} km to go!'
                      : 'Goal achieved! 🎉',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 14,
                    color: const Color(0xff888b94),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartRunButton() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: GestureDetector(
          onTap: _startRun,
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xff3abeff),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.play_arrow,
                  size: 32,
                  color: const Color(0xff121212),
                ),
                const SizedBox(width: 12),
                Text(
                  'Start Running',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 18,
                    color: const Color(0xff121212),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _formatDurationToMinutes(int seconds) {
    final minutes = (seconds / 60).round();
    return minutes.toString();
  }

  String _calculatePace(double distanceMeters, int durationSeconds) {
    if (distanceMeters <= 0 || durationSeconds <= 0) return '0:00';

    final distanceKm = distanceMeters / 1000;
    final paceMinutesPerKm = durationSeconds / 60 / distanceKm;
    final minutes = paceMinutesPerKm.floor();
    final seconds = ((paceMinutesPerKm - minutes) * 60).round();

    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
}
