import 'package:flutter/material.dart';

class VoiceNavigationSettings extends StatefulWidget {
  const VoiceNavigationSettings({super.key});

  @override
  State<VoiceNavigationSettings> createState() =>
      _VoiceNavigationSettingsState();
}

class _VoiceNavigationSettingsState extends State<VoiceNavigationSettings> {
  String selectedVoice = 'Sarah';
  String selectedLanguage = 'English (US)';
  double voiceVolume = 75.0;
  String selectedSensitivity = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        title: const Text(
          'Voice Navigation',
          style: TextStyle(
            color: const Color(0x193abeff),
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
              'Customize your audio guidance',
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
                    _buildVoiceTypeSection(),
                    const SizedBox(height: 24),
                    _buildLanguageSection(),
                    const SizedBox(height: 24),
                    _buildVoiceVolumeSection(),
                    const SizedBox(height: 24),
                    _buildGuidanceSensitivitySection(),
                    const SizedBox(height: 24),
                    _buildSaveButton(),
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

  Widget _buildVoiceTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Type',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0x193abeff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildVoiceOption(
          name: 'Sarah (Female)',
          description: 'Clear, friendly tone',
          isSelected: selectedVoice == 'Sarah',
          onTap: () => setState(() => selectedVoice = 'Sarah'),
          avatarIcon: Icons.face,
        ),
        const SizedBox(height: 12),
        _buildVoiceOption(
          name: 'David (Male)',
          description: 'Deep, confident tone',
          isSelected: selectedVoice == 'David',
          onTap: () => setState(() => selectedVoice = 'David'),
          avatarIcon: Icons.face_2,
        ),
      ],
    );
  }

  Widget _buildVoiceOption({
    required String name,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
    required IconData avatarIcon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x193abeff),
          border: isSelected
              ? Border.all(color: const Color(0xff3abeff), width: 2)
              : null,
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
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: const Color(0xffcccccc),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xff3abeff).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  avatarIcon,
                  size: 20,
                  color: const Color(0xff3abeff),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Language',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0x193abeff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _showLanguageSelector,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0x193abeff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLanguage,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.expand_more,
                    color: const Color(0xffcccccc),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceVolumeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Volume',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0x193abeff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0x193abeff),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Slider(
                value: voiceVolume,
                min: 0,
                max: 100,
                divisions: 10,
                activeColor: const Color(0xff3abeff),
                inactiveColor: const Color(0xffe5e7eb),
                onChanged: (value) => setState(() => voiceVolume = value),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _testVolume,
                child: Text(
                  '${voiceVolume.round()}% - Tap to test volume',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff3abeff),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidanceSensitivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Guidance Sensitivity',
          style: TextStyle(
            fontSize: 16,
            color: const Color(0x193abeff),
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildSensitivityOption(
          title: 'High Sensitivity',
          description: 'Frequent updates and warnings',
          value: 'High',
        ),
        const SizedBox(height: 12),
        _buildSensitivityOption(
          title: 'Medium Sensitivity',
          description: 'Balanced guidance frequency',
          value: 'Medium',
        ),
        const SizedBox(height: 12),
        _buildSensitivityOption(
          title: 'Low Sensitivity',
          description: 'Minimal interruptions',
          value: 'Low',
        ),
      ],
    );
  }

  Widget _buildSensitivityOption({
    required String title,
    required String description,
    required String value,
  }) {
    final isSelected = selectedSensitivity == value;

    return GestureDetector(
      onTap: () => setState(() => selectedSensitivity = value),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x193abeff),
          border: isSelected
              ? Border.all(color: const Color(0xff3abeff), width: 2)
              : null,
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
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: const Color(0xffcccccc),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff3abeff)
                      : const Color(0xffe5e7eb),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0x193abeff),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff3abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _saveSettings,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Save Voice Settings',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff1b1f3b),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff1b1f3b),
              ),
            ),
            const SizedBox(height: 16),
            _buildLanguageOption('English (US)'),
            _buildLanguageOption('English (UK)'),
            _buildLanguageOption('Spanish'),
            _buildLanguageOption('French'),
            _buildLanguageOption('German'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    return ListTile(
      title: Text(language),
      onTap: () {
        setState(() => selectedLanguage = language);
        Navigator.pop(context);
      },
      trailing: selectedLanguage == language
          ? const Icon(Icons.check, color: Color(0xff3abeff))
          : null,
    );
  }

  void _testVolume() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Testing volume at ${voiceVolume.round()}%'),
        backgroundColor: const Color(0xff3abeff),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice settings saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }
}
