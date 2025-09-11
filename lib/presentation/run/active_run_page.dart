import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../../controller/run_controller.dart';
import '../../app_module/data/model/run.dart';
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
        // Simulate distance increase (roughly 0.1 miles per minute at moderate pace)
        _distance += 0.0017; // Approximately 0.1 miles per minute
        // Simulate slight pace variations
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
      body: Column(
        children: [
          _buildConnectionStatus(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildRunningStats(),
                  const SizedBox(height: 32),
                  _buildVoiceGuidanceSection(),
                  const SizedBox(height: 32),
                  _buildCurrentGuidance(),
                  const Spacer(),
                ],
              ),
            ),
          ),
          _buildBottomControls(),
        ],
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
        // Main timer
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
        // Distance and Pace
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
          // Emergency SOS Button
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
          // Control buttons row
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
    // TODO: Show run settings (voice volume, etc.)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Run settings coming soon!'),
        backgroundColor: Color(0xff3abeff),
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

  void _endRun() {
    _timer?.cancel();

    // Create run data to save
    final runController = Provider.of<RunController>(context, listen: false);

    final runData = RunCreateRequest(
      deviceId: 'device_001', // This should come from actual device pairing
      sessionId: 'session_${DateTime.now().millisecondsSinceEpoch}',
      title: 'Morning Run',
      notes: 'Great run with voice guidance!',
      startedAt: DateTime.now().subtract(Duration(seconds: _seconds)),
      endedAt: DateTime.now(),
      durationSeconds: _seconds,
      distanceMeters: (_distance * 1000).round().toDouble(),
      avgSpeedKmh: (_distance / (_seconds / 3600)).isFinite
          ? (_distance / (_seconds / 3600))
          : 0.0,
      maxSpeedKmh: _currentPace * 1.2, // Simulate max speed
      caloriesBurned: (_distance * 65 + _seconds * 0.5)
          .round(), // Rough calorie calculation
      stepsCount: (_distance * 1312)
          .round(), // Rough steps calculation (avg 1312 steps per mile)
      startLatitude: -6.200000 + (Random().nextDouble() - 0.5) * 0.01,
      startLongitude: 106.816666 + (Random().nextDouble() - 0.5) * 0.01,
      endLatitude: -6.200000 + (Random().nextDouble() - 0.5) * 0.01,
      endLongitude: 106.816666 + (Random().nextDouble() - 0.5) * 0.01,
    );

    // Save the run
    runController
        .startRun(runData)
        .then(
          (run) => {
            if (run != null)
              {
                // End the run immediately since it's already completed
                runController.endRun(
                  run.id,
                  RunUpdateRequest(endedAt: DateTime.now()),
                ),
              },
          },
        );

    // Navigate back to home with run summary
    Navigator.of(context).popUntil((route) => route.isFirst);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Run completed! Distance: ${_distance.toStringAsFixed(1)} miles, Time: ${_formatTime(_seconds)}',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
