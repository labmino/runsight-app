import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../controller/run_controller.dart';
import '../../app_module/data/model/run.dart';
import 'run_summary_page.dart';
import 'dart:math';

class ActiveRunPage extends StatefulWidget {
  final String selectedMode;
  final bool gpsEnabled;
  final bool voiceEnabled;

  const ActiveRunPage({
    super.key,
    required this.selectedMode,
    required this.gpsEnabled,
    required this.voiceEnabled,
  });

  @override
  State<ActiveRunPage> createState() => _ActiveRunPageState();
}

class _ActiveRunPageState extends State<ActiveRunPage> {
  Timer? _timer;
  int _seconds = 0;
  double _distance = 0.0;
  double _currentPace = 8.42;
  String _currentGuidance =
      'Continue straight for 200 meters, then turn right at the intersection.';
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
        _distance += 0.0017;
        _currentPace = 8.42 + ((_seconds % 30) / 30 - 0.5) * 0.5;
      });
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatPace(double pace) {
    int minutes = pace.floor();
    int seconds = ((pace - minutes) * 60).round();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      body: SafeArea(
        child: Column(
          children: [
            _buildConnectionStatus(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildRunningStats(),
                    const SizedBox(height: 32),
                    _buildVoiceGuidanceSection(),
                    const SizedBox(height: 32),
                    _buildCurrentGuidance(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: _isConnected ? const Color(0x193abeff) : const Color(0x19ff4f58),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _isConnected
                    ? const Color(0xff3abeff)
                    : const Color(0xffff4f58),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                fontSize: 12,
                color: _isConnected
                    ? const Color(0xff3abeff)
                    : const Color(0xffff4f58),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningStats() {
    return Column(
      children: [
        Text(
          _formatTime(_seconds),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 48,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Running Time',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xff888b94),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    _distance.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xff3abeff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'miles',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: [
                  Text(
                    _formatPace(_currentPace),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      color: Color(0xff3abeff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'min/mile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVoiceGuidanceSection() {
    return Column(
      children: [
        Icon(
          widget.voiceEnabled ? Icons.mic : Icons.mic_off,
          size: 80,
          color: widget.voiceEnabled
              ? const Color(0xff3abeff)
              : const Color(0xff888b94),
        ),
        const SizedBox(height: 16),
        Text(
          widget.voiceEnabled
              ? '🎤 Voice guidance active'
              : '🔇 Voice guidance disabled',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: widget.voiceEnabled
                ? const Color(0xff3abeff)
                : const Color(0xff888b94),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentGuidance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.navigation, color: Color(0xff3abeff), size: 20),
              SizedBox(width: 8),
              Text(
                'Current Direction',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff3abeff),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentGuidance,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          GestureDetector(
            onTap: _showEmergencyDialog,
            child: Container(
              width: 200,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xffff4f58),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emergency, size: 32, color: Colors.white),
                  SizedBox(width: 16),
                  Text(
                    'Emergency SOS',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: Icons.pause,
                label: 'Pause',
                onTap: _pauseRun,
              ),
              _buildControlButton(
                icon: Icons.stop,
                label: 'Stop',
                onTap: _showStopDialog,
                color: const Color(0xffff4f58),
              ),
              _buildControlButton(
                icon: Icons.settings,
                label: 'Settings',
                onTap: _showSettings,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final buttonColor = color ?? const Color(0xff3abeff);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: buttonColor, width: 2),
            ),
            child: Icon(icon, size: 24, color: buttonColor),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: buttonColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _pauseRun() {
    _timer?.cancel();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Run paused. Tap resume to continue.'),
        backgroundColor: Color(0xff3abeff),
      ),
    );
    // TODO: Implement pause functionality
  }

  void _showStopDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text('End Run?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to end your current run session?',
          style: TextStyle(color: Color(0xff888b94)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Continue Running',
              style: TextStyle(color: Color(0xff888b94)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _endRun();
            },
            child: const Text(
              'End Run',
              style: TextStyle(color: Color(0xffff4f58)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'Emergency SOS',
          style: TextStyle(color: Color(0xffff4f58)),
        ),
        content: const Text(
          'This will immediately contact your emergency contacts and share your location. Are you sure?',
          style: TextStyle(color: Color(0xff888b94)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xff888b94)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _triggerEmergency();
            },
            child: const Text(
              'Send SOS',
              style: TextStyle(color: Color(0xffff4f58)),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff2a2e45),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildRunSettingsModal(),
    );
  }

  Widget _buildRunSettingsModal() {
    return Container(
      padding: const EdgeInsets.all(24),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Run Settings',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),

          _buildSettingsSection(
            title: 'Voice Guidance',
            subtitle: widget.voiceEnabled
                ? 'Currently enabled'
                : 'Currently disabled',
            icon: widget.voiceEnabled ? Icons.mic : Icons.mic_off,
            onTap: () {
              Navigator.pop(context);
              _showVoiceSettings();
            },
          ),

          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'GPS & Navigation',
            subtitle: widget.gpsEnabled ? 'High accuracy mode' : 'GPS disabled',
            icon: widget.gpsEnabled ? Icons.gps_fixed : Icons.gps_off,
            onTap: () {
              Navigator.pop(context);
              _showGpsSettings();
            },
          ),

          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'Display Options',
            subtitle: 'Screen timeout, brightness',
            icon: Icons.brightness_6,
            onTap: () {
              Navigator.pop(context);
              _showDisplaySettings();
            },
          ),

          const SizedBox(height: 16),

          _buildSettingsSection(
            title: 'Emergency Settings',
            subtitle: 'Emergency contacts, SOS options',
            icon: Icons.emergency,
            onTap: () {
              Navigator.pop(context);
              _showEmergencySettings();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff3a3f56),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff3abeff).withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, color: const Color(0xff3abeff), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xff888b94),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showVoiceSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'Voice Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Adjust voice guidance during your run',
              style: TextStyle(color: Color(0xff888b94)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Voice Volume',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${widget.voiceEnabled ? "Enabled" : "Disabled"}',
                  style: const TextStyle(color: Color(0xff3abeff)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }

  void _showGpsSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'GPS Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'GPS tracking settings for your run',
              style: TextStyle(color: Color(0xff888b94)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GPS Status', style: TextStyle(color: Colors.white)),
                Text(
                  '${widget.gpsEnabled ? "Active" : "Disabled"}',
                  style: const TextStyle(color: Color(0xff3abeff)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisplaySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'Display Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Screen display options during your run',
              style: TextStyle(color: Color(0xff888b94)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Keep Screen On', style: TextStyle(color: Colors.white)),
                Text('Enabled', style: TextStyle(color: Color(0xff3abeff))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmergencySettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'Emergency Settings',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Configure emergency SOS settings',
              style: TextStyle(color: Color(0xff888b94)),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Emergency Contacts',
                  style: TextStyle(color: Colors.white),
                ),
                Text('2 contacts', style: TextStyle(color: Color(0xff3abeff))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }

  void _triggerEmergency() {
    // TODO: Implement emergency SOS functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emergency SOS sent! Help is on the way.'),
        backgroundColor: Color(0xffff4f58),
      ),
    );
  }

  void _endRun() async {
    _timer?.cancel();
    final runController = Provider.of<RunController>(context, listen: false);
    final totalTime = Duration(seconds: _seconds);
    final distanceKm = _distance * 1.60934;
    final averagePace = _seconds > 0 && distanceKm > 0
        ? (_seconds / 60) / distanceKm
        : 0.0;
    final calories = (_distance * 65 + _seconds * 0.5).round();

    final runData = RunCreateRequest(
      deviceId: 'device_001',
      sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: '${widget.selectedMode} Run',
      notes: 'Run completed with RunSight glasses',
      startedAt: DateTime.now().subtract(Duration(seconds: _seconds)),
      endedAt: DateTime.now(),
      durationSeconds: _seconds,
      distanceMeters: (distanceKm * 1000).round().toDouble(),
      avgSpeedKmh: (distanceKm / (_seconds / 3600)).isFinite
          ? (distanceKm / (_seconds / 3600))
          : 0.0,
      maxSpeedKmh: _currentPace * 1.2,
      caloriesBurned: calories,
      stepsCount: (distanceKm * 1312).round(),
      startLatitude: -6.200000 + (Random().nextDouble() - 0.5) * 0.01,
      startLongitude: 106.816666 + (Random().nextDouble() - 0.5) * 0.01,
      endLatitude: -6.200000 + (Random().nextDouble() - 0.5) * 0.01,
      endLongitude: 106.816666 + (Random().nextDouble() - 0.5) * 0.01,
    );

    try {
      final run = await runController.startRun(runData);
      if (run != null) {
        await runController.endRun(
          run.id,
          RunUpdateRequest(endedAt: DateTime.now()),
        );
      }

      List<String> achievements = [];
      if (distanceKm >= 5.0) achievements.add('5K Completed!');
      if (distanceKm >= 10.0) achievements.add('10K Master!');
      if (_seconds >= 1800) achievements.add('30+ Minutes Runner!');
      if (averagePace > 0 && averagePace < 6.0)
        achievements.add('Speed Demon!');

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RunSummaryPage(
              selectedMode: widget.selectedMode,
              totalTime: totalTime,
              distanceKm: distanceKm,
              averagePace: averagePace,
              calories: calories,
              achievements: achievements,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save run, but showing summary'),
            backgroundColor: Colors.orange,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RunSummaryPage(
              selectedMode: widget.selectedMode,
              totalTime: totalTime,
              distanceKm: distanceKm,
              averagePace: averagePace,
              calories: calories,
              achievements: [],
            ),
          ),
        );
      }
    }
  }
}
