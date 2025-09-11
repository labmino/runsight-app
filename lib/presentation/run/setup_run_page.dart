import 'package:flutter/material.dart';
import 'run_briefing_page.dart';

class SetupRunPage extends StatefulWidget {
  const SetupRunPage({super.key});

  @override
  State<StatefulWidget> createState() => _SetupRunPageState();
}

class _SetupRunPageState extends State<SetupRunPage> {
  String _selectedRunMode = 'Beginner Mode';
  bool _gpsTrackingEnabled = true;
  bool _voiceGuidanceEnabled = true;

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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRunModeSection(),
                        const SizedBox(height: 32),
                        _buildVoiceAndSafetySection(),
                        const SizedBox(height: 32),
                        _buildContinueButton(),
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

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 24,
            height: 24,
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            'Setup Your Run',
            textAlign: TextAlign.left,
            style: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 28,
              color: Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildRunModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Running Mode',
          textAlign: TextAlign.left,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 18,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildRunModeOption(
          title: 'Beginner Mode',
          description:
              'Gentle pace with frequent voice guidance and safety tips',
          isSelected: _selectedRunMode == 'Beginner Mode',
          onTap: () => setState(() => _selectedRunMode = 'Beginner Mode'),
        ),
        const SizedBox(height: 12),
        _buildRunModeOption(
          title: 'Free Run Mode',
          description: 'Run at your own pace with minimal interruptions',
          isSelected: _selectedRunMode == 'Free Run Mode',
          onTap: () => setState(() => _selectedRunMode = 'Free Run Mode'),
        ),
        const SizedBox(height: 12),
        _buildRunModeOption(
          title: 'Challenge Mode',
          description: 'Goal-based running with performance coaching',
          isSelected: _selectedRunMode == 'Challenge Mode',
          onTap: () => setState(() => _selectedRunMode = 'Challenge Mode'),
        ),
      ],
    );
  }

  Widget _buildRunModeOption({
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0x193abeff),
          border: isSelected
              ? Border.all(color: const Color(0xff3abeff), width: 2)
              : null,
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
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 16,
                        color: isSelected
                            ? const Color(0xff3abeff)
                            : const Color(0xffffffff),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xff3abeff),
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 14,
                  color: Color(0xff888b94),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVoiceAndSafetySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice & Safety Settings',
          textAlign: TextAlign.left,
          style: TextStyle(
            decoration: TextDecoration.none,
            fontSize: 18,
            color: Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        _buildSettingToggle(
          title: 'GPS Tracking',
          description: 'Track your route and location',
          isEnabled: _gpsTrackingEnabled,
          onToggle: (value) => setState(() => _gpsTrackingEnabled = value),
        ),
        const SizedBox(height: 16),
        _buildSettingToggle(
          title: 'Voice Guidance',
          description: 'Real-time audio instructions',
          isEnabled: _voiceGuidanceEnabled,
          onToggle: (value) => setState(() => _voiceGuidanceEnabled = value),
        ),
      ],
    );
  }

  Widget _buildSettingToggle({
    required String title,
    required String description,
    required bool isEnabled,
    required Function(bool) onToggle,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 16,
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 12,
                      color: Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => onToggle(!isEnabled),
              child: Container(
                width: 48,
                height: 28,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? const Color(0xff3abeff)
                      : const Color(0xff888b94),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: AnimatedAlign(
                  alignment: isEnabled
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: GestureDetector(
        onTap: _onContinueToBriefing,
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xff3abeff),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'Continue to Briefing',
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 16,
                color: Color(0xff121212),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onContinueToBriefing() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunBriefingPage(
          selectedMode: _selectedRunMode,
          gpsEnabled: _gpsTrackingEnabled,
          voiceEnabled: _voiceGuidanceEnabled,
        ),
      ),
    );
  }
}
