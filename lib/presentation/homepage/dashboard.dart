import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controller/auth_controller.dart';
import '../../controller/device_pairing_controller.dart';
import '../../controller/run_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../authentication/login.dart';
import '../community/community_page.dart';
import '../device/device_pairing_screen.dart';
import '../history/history_screen.dart';
import '../run/setup_run_page.dart';
import '../settings/settings_page.dart';

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

    final deviceController = Provider.of<DevicePairingController>(
      context,
      listen: false,
    );
    deviceController.getConnectedDevices();
  }

  void _onNavBarTap(int index) {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (!authController.isLoggedIn || authController.currentUser == null) {
      _navigateToLogin();
      return;
    }

    setState(() {
      _currentNavIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DevicePairingScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityPage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
        break;
    }
  }

  void _navigateToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _startRun() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (!authController.isLoggedIn || authController.currentUser == null) {
      _navigateToLogin();
      return;
    }

    final deviceController = Provider.of<DevicePairingController>(
      context,
      listen: false,
    );
    final devices = await deviceController.getConnectedDevices();

    if (devices.isNotEmpty && deviceController.hasPairedDevice) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SetupRunPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DevicePairingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: const Color(0xff1b1f3b)),
        child: SafeArea(
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
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 0),
        child: Consumer<AuthController>(
          builder: (context, authController, child) {
            final user = authController.currentUser;
            final userName = user?.fullName ?? 'User';
            final greeting = _getGreeting();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$greeting, $userName',
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 28,
                    color: Colors.white,
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
                    color: Colors.white,
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
                          color: const Color(0xffcccccc),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No runs yet',
                          style: TextStyle(
                            color: const Color(0xffcccccc),
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Start your first run today!',
                          style: TextStyle(
                            color: const Color(0xffcccccc),
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
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 12,
            color: const Color(0xffcccccc),
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
                        color: const Color(0xff3abeff),
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
                    color: const Color(0xffcccccc),
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
                    color: const Color(0xffcccccc),
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
    return Consumer<DevicePairingController>(
      builder: (context, deviceController, child) {
        final hasDevice = deviceController.hasPairedDevice;
        final buttonText = hasDevice ? 'Start Running' : 'Connect & Run';
        final buttonIcon = hasDevice ? Icons.play_arrow : Icons.link;

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              children: [
                if (hasDevice) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x194ade80),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xff4ade80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Device Connected',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff4ade80),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                GestureDetector(
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
                          buttonIcon,
                          size: 32,
                          color: const Color(0xff121212),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          buttonText,
                          style: const TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18,
                            color: Color(0xff121212),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
