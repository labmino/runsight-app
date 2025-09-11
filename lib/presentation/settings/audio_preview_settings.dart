import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioPreviewSettings extends StatefulWidget {
  const AudioPreviewSettings({super.key});

  @override
  State<AudioPreviewSettings> createState() => _AudioPreviewSettingsState();
}

class _AudioPreviewSettingsState extends State<AudioPreviewSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        title: const Text(
          'Audio Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.normal,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test your audio and vibration settings',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVoiceInstructionsSection(),
                    const SizedBox(height: 24),
                    _buildVibrationPatternsSection(),
                    const SizedBox(height: 24),
                    _buildAudioSystemStatus(),
                    const SizedBox(height: 24),
                    _buildTestAllButton(),
                    const SizedBox(height: 24), // Extra padding at bottom
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Instructions Preview',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildVoiceInstructionCard(
          title: 'Turn Left Instruction',
          instruction: '"In 50 meters, turn left onto Oak Street"',
          icon: Icons.turn_left,
          onPlay: () => _playInstruction('turn_left'),
        ),
        const SizedBox(height: 12),
        _buildVoiceInstructionCard(
          title: 'Obstacle Warning',
          instruction: '"Caution: obstacle detected 3 meters ahead"',
          icon: Icons.warning,
          onPlay: () => _playInstruction('obstacle'),
        ),
        const SizedBox(height: 12),
        _buildVoiceInstructionCard(
          title: 'Pace Update',
          instruction: '"Current pace: 8 minutes 30 seconds per mile"',
          icon: Icons.speed,
          onPlay: () => _playInstruction('pace'),
        ),
      ],
    );
  }

  Widget _buildVoiceInstructionCard({
    required String title,
    required String instruction,
    required IconData icon,
    required VoidCallback onPlay,
  }) {
    return GestureDetector(
      onTap: onPlay,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff1b1f3b),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      instruction,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xff3abeff).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, size: 24, color: const Color(0xff3abeff)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVibrationPatternsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vibration Patterns',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildVibrationCard(
          title: 'Turn Signal',
          description: 'Short pulse for direction changes',
          icon: Icons.vibration,
          onTest: () => _testVibration('turn'),
        ),
        const SizedBox(height: 12),
        _buildVibrationCard(
          title: 'Warning Alert',
          description: 'Double pulse for obstacles',
          icon: Icons.warning_amber,
          onTest: () => _testVibration('warning'),
        ),
      ],
    );
  }

  Widget _buildVibrationCard({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTest,
  }) {
    return GestureDetector(
      onTap: onTest,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff1b1f3b),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff666666),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xff3abeff).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, size: 24, color: const Color(0xff3abeff)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioSystemStatus() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 24,
                  color: Color(0xff3abeff),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Audio System Status',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff3abeff),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusItem('Smart glasses connected'),
            const SizedBox(height: 8),
            _buildStatusItem('Voice volume: 75%'),
            const SizedBox(height: 8),
            _buildStatusItem('Voice: Sarah (Female)'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xff3abeff),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xff3abeff),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestAllButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff3abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _testAllAudioAndVibration,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.play_arrow, size: 24, color: Color(0xff1b1f3b)),
            SizedBox(width: 12),
            Text(
              'Test All Audio & Vibration',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff1b1f3b),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _playInstruction(String type) {
    String message;
    switch (type) {
      case 'turn_left':
        message = 'Playing: Turn left instruction';
        break;
      case 'obstacle':
        message = 'Playing: Obstacle warning';
        break;
      case 'pace':
        message = 'Playing: Pace update';
        break;
      default:
        message = 'Playing instruction...';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xff3abeff),
        duration: const Duration(seconds: 2),
      ),
    );

    // Simulate TTS playing
    // In real implementation, you would use flutter_tts here
  }

  void _testVibration(String type) {
    String message;
    switch (type) {
      case 'turn':
        message = 'Testing: Turn signal vibration';
        // Light vibration for turn signal
        HapticFeedback.lightImpact();
        break;
      case 'warning':
        message = 'Testing: Warning vibration';
        // Strong vibration for warning
        HapticFeedback.heavyImpact();
        Future.delayed(const Duration(milliseconds: 200), () {
          HapticFeedback.heavyImpact();
        });
        break;
      default:
        message = 'Testing vibration...';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xff3abeff),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _testAllAudioAndVibration() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Testing all audio and vibration patterns...'),
        backgroundColor: Color(0xff3abeff),
        duration: Duration(seconds: 3),
      ),
    );

    // Test sequence
    Future.delayed(
      const Duration(seconds: 1),
      () => _playInstruction('turn_left'),
    );
    Future.delayed(const Duration(seconds: 3), () => _testVibration('turn'));
    Future.delayed(
      const Duration(seconds: 4),
      () => _playInstruction('obstacle'),
    );
    Future.delayed(const Duration(seconds: 6), () => _testVibration('warning'));
    Future.delayed(const Duration(seconds: 7), () => _playInstruction('pace'));
  }
}
