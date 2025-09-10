import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../controller/run_controller.dart';
import '../../controller/auth_controller.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../app_module/data/model/run.dart';
import '../homepage/dashboard.dart';
import '../authentication/login.dart';
import '../device/device_pairing_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRunHistory();
    });
  }

  void _loadRunHistory() {
    final runController = Provider.of<RunController>(context, listen: false);
    runController.fetchRuns();
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
        break;
      case 1:
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DevicePairingScreen()),
        );
        break;
      case 3:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Community page coming soon!')),
        );
        break;
      case 4:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings page coming soon!')),
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
              Expanded(child: _buildRunHistoryList()),
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
        padding: const EdgeInsets.only(
          left: 24,
          top: 24,
          right: 24,
          bottom: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Jog History',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 22,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Icon(
                  Icons.filter_list,
                  size: 24,
                  color: const Color(0xffffffff),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Your recent running sessions',
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 14,
                color: const Color(0xff3abeff),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunHistoryList() {
    return Consumer<RunController>(
      builder: (context, runController, child) {
        if (runController.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff3abeff)),
            ),
          );
        }

        if (runController.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: const Color(0xff888b94),
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading history',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  runController.errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xff888b94),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadRunHistory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff3abeff),
                    foregroundColor: const Color(0xff1b1f3b),
                  ),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        final runs = runController.runs;
        final completedRuns = runs.where((run) => run.endedAt != null).toList();

        if (completedRuns.isEmpty) {
          return _buildEmptyState();
        }

        return _buildGroupedRunList(completedRuns);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_run,
              size: 80,
              color: const Color(0xff888b94),
            ),
            const SizedBox(height: 24),
            Text(
              'No Running History',
              style: TextStyle(
                fontSize: 24,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start your first run to see your history here.\nConnect your smart glasses and begin your journey!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: const Color(0xff888b94)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DevicePairingScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3abeff),
                foregroundColor: const Color(0xff1b1f3b),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                'Start Your First Run',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedRunList(List<Run> runs) {
    return GroupedListView<Run, String>(
      elements: runs,
      groupBy: (run) => _formatDateGroup(run.startedAt),
      groupSeparatorBuilder: (String groupByValue) =>
          _buildDateSeparator(groupByValue),
      itemBuilder: (context, Run run) => _buildRunCard(run),
      order: GroupedListOrder.DESC,
      useStickyGroupSeparators: true,
      stickyHeaderBackgroundColor: const Color(0xff1b1f3b),
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
    );
  }

  Widget _buildDateSeparator(String dateGroup) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        dateGroup,
        style: TextStyle(
          fontSize: 16,
          color: const Color(0xff3abeff),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRunCard(Run run) {
    return Container(
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
                      style: TextStyle(
                        fontSize: 16,
                        color: const Color(0xff1b1f3b),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(run.startedAt),
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xff888b94),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.more_vert, color: const Color(0xff888b94)),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  icon: Icons.straighten,
                  value: run.formattedDistance.split(' ')[0],
                  unit: 'km',
                  color: const Color(0xff3abeff),
                ),
                _buildStatItem(
                  icon: Icons.timer,
                  value: _formatDurationToMinutes(run.durationSeconds ?? 0),
                  unit: 'min',
                  color: const Color(0xff10b981),
                ),
                _buildStatItem(
                  icon: Icons.speed,
                  value: _calculatePace(
                    run.distanceMeters ?? 0,
                    run.durationSeconds ?? 0,
                  ),
                  unit: 'min/km',
                  color: const Color(0xfff59e0b),
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  value: (run.caloriesBurned ?? 0).toString(),
                  unit: 'cal',
                  color: const Color(0xffef4444),
                ),
              ],
            ),
          ],
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
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xff1b1f3b),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          unit,
          style: TextStyle(fontSize: 12, color: const Color(0xff888b94)),
        ),
      ],
    );
  }

  String _formatDateGroup(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '$displayHour:$minute $period';
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
