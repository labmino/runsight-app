import 'package:flutter/material.dart';

class RunBriefingPage extends StatelessWidget {
  final String selectedMode;
  final bool gpsEnabled;
  final bool voiceEnabled;

  const RunBriefingPage({
    super.key,
    required this.selectedMode,
    required this.gpsEnabled,
    required this.voiceEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Color(0xff1b1f3b)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRunSummary(),
                        const SizedBox(height: 32),
                        _buildSafetyTips(),
                        const SizedBox(height: 32),
                        _buildStartButton(context),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Text(
            'Run Briefing',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunSummary() {
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
            const Text(
              'Your Run Setup',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem('Running Mode', selectedMode),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'GPS Tracking',
              gpsEnabled ? 'Enabled' : 'Disabled',
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'Voice Guidance',
              voiceEnabled ? 'Enabled' : 'Disabled',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xff3abeff),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTips() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Safety Tips',
          style: TextStyle(
            fontSize: 18,
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSafetyTip('Stay aware of your surroundings'),
                const SizedBox(height: 8),
                _buildSafetyTip('Keep your device charged'),
                const SizedBox(height: 8),
                _buildSafetyTip('Follow traffic rules and signals'),
                const SizedBox(height: 8),
                _buildSafetyTip('Stay hydrated during your run'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xff3abeff), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GestureDetector(
        onTap: () => _startRun(context),
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xff3abeff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Start Running',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xff121212),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _startRun(BuildContext context) {
    // TODO: Start the actual run session
    // For now, show a success message and go back to dashboard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Run started! Good luck!'),
        backgroundColor: Color(0xff3abeff),
      ),
    );

    // Navigate back to home/dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
