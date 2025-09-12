import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'active_run_page.dart';

class RunBriefingPage extends StatefulWidget {
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
  State<RunBriefingPage> createState() => _RunBriefingPageState();
}

class _RunBriefingPageState extends State<RunBriefingPage> {
  FlutterTts tts = FlutterTts();
  bool _isPlaying = false;
  bool _isCompleted = false;

  final List<SafetyCheckItem> _safetyChecks = [
    SafetyCheckItem(
      icon: Icons.smart_display,
      text: 'Smart glasses connected and charged',
      isCompleted: true,
    ),
    SafetyCheckItem(
      icon: Icons.gps_fixed,
      text: 'GPS signal strong and location set',
      isCompleted: true,
    ),
    SafetyCheckItem(
      icon: Icons.volume_up,
      text: 'Voice guidance volume adjusted',
      isCompleted: true,
    ),
    SafetyCheckItem(
      icon: Icons.contact_emergency,
      text: 'Emergency contacts ready',
      isCompleted: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _playBriefing();
      });
    });
  }

  @override
  void dispose() {
    try {
      tts.stop();
    } catch (e) {
      print('TTS stop error on dispose: $e');
    }
    super.dispose();
  }

  Future<void> _initTts() async {
    try {
      await tts.setSpeechRate(
        0.5,
      ); // flutter_tts uses 0.0-1.0 range where 0.5 is normal speed
      await tts.setVolume(0.8);
      await tts.setPitch(1.0);
      await tts.setLanguage("en-US");
    } catch (e) {
      print('TTS initialization error: $e');
    }
  }

  String get _briefingText {
    return '''
Welcome to your RunSight safety briefing. 

You have selected ${widget.selectedMode} mode for today's run. 

GPS tracking is ${widget.gpsEnabled ? 'enabled' : 'disabled'} and voice guidance is ${widget.voiceEnabled ? 'enabled' : 'disabled'}.

Before we begin, let's ensure everything is properly configured.

First, verify that your smart glasses are connected and have sufficient battery charge.

Next, confirm that your GPS signal is strong and your location has been detected.

Check that your voice guidance volume is set appropriately. We recommend 70% to hear both guidance and ambient sounds clearly.

Finally, ensure your emergency contacts are ready if needed.

Remember, safety is our top priority. Stay alert, trust your instincts, and enjoy your run with confidence.

Tap the start button when you're ready to begin your guided run.
''';
  }

  Future<void> _playBriefing() async {
    try {
      if (_isPlaying) {
        await tts.stop();
        setState(() {
          _isPlaying = false;
        });
      } else {
        setState(() {
          _isPlaying = true;
        });

        // Set up completion handler
        tts.setCompletionHandler(() {
          if (mounted) {
            setState(() {
              _isPlaying = false;
              _isCompleted = true;
            });
          }
        });

        await tts.speak(_briefingText);
      }
    } catch (e) {
      print('TTS error: $e');
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isCompleted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice briefing not available, but you can continue'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildAudioSection(),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRunSummary(),
                      const SizedBox(height: 32),
                      _buildSafetyChecklist(),
                      const SizedBox(height: 32),
                      _buildSafetyTips(),
                    ],
                  ),
                ),
              ),
              _buildStartButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioSection() {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _playBriefing,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: _isPlaying
                    ? const Color(0xff3abeff)
                    : const Color(0xff2a2e45),
                borderRadius: BorderRadius.circular(60),
                border: Border.all(color: const Color(0xff3abeff), width: 2),
              ),
              child: Icon(
                _isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48,
                color: _isPlaying ? Colors.white : const Color(0xff3abeff),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _isPlaying
                ? '🔊 Playing audio briefing...'
                : _isCompleted
                ? '✅ Briefing completed'
                : '🔊 Tap to play briefing',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: _isCompleted ? Colors.green : const Color(0xff3abeff),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyChecklist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Safety Checklist',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(_safetyChecks.length, (index) {
          final item = _safetyChecks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Icon(
                  item.isCompleted ? Icons.check_circle : Icons.circle_outlined,
                  size: 24,
                  color: item.isCompleted
                      ? Colors.green
                      : const Color(0xff888b94),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: item.isCompleted
                          ? Colors.white
                          : const Color(0xff888b94),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
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
            _buildSummaryItem('Running Mode', widget.selectedMode),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'GPS Tracking',
              widget.gpsEnabled ? 'Enabled' : 'Disabled',
            ),
            const SizedBox(height: 12),
            _buildSummaryItem(
              'Voice Guidance',
              widget.voiceEnabled ? 'Enabled' : 'Disabled',
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
    final bool canStart =
        _safetyChecks.where((item) => item.isCompleted).length >= 3;

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Center(
        child: GestureDetector(
          onTap: canStart ? () => _startRun(context) : null,
          child: Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: canStart
                  ? const Color(0xff3abeff)
                  : const Color(0xff2a2e45),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_run,
                  size: 32,
                  color: canStart
                      ? const Color(0xff121212)
                      : const Color(0xff888b94),
                ),
                const SizedBox(width: 16),
                Text(
                  'Start My Run',
                  style: TextStyle(
                    fontSize: 18,
                    color: canStart
                        ? const Color(0xff121212)
                        : const Color(0xff888b94),
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

  void _startRun(BuildContext context) {
    try {
      tts.stop();
    } catch (e) {
      print('TTS stop error: $e');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff2a2e45),
        title: const Text(
          'Start Your Run?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you ready to begin your guided run with RunSight?',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ActiveRunPage(
                    selectedMode: widget.selectedMode,
                    gpsEnabled: widget.gpsEnabled,
                    voiceEnabled: widget.voiceEnabled,
                  ),
                ),
              );
            },
            child: const Text(
              'Start Run',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }
}

class SafetyCheckItem {
  final IconData icon;
  final String text;
  final bool isCompleted;

  SafetyCheckItem({
    required this.icon,
    required this.text,
    required this.isCompleted,
  });
}
