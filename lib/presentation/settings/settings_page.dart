import 'package:flutter/material.dart';
import 'voice_navigation_settings.dart';
import 'audio_preview_settings.dart';
import 'user_preferences_settings.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
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
              'Customize your running experience',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                children: [
                  _buildSettingsCard(
                    icon: Icons.record_voice_over,
                    title: 'Voice Navigation',
                    subtitle: 'Customize your audio guidance',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VoiceNavigationSettings(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    icon: Icons.volume_up,
                    title: 'Audio Preview',
                    subtitle: 'Test your audio and vibration settings',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AudioPreviewSettings(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard(
                    icon: Icons.person_outline,
                    title: 'User Preferences',
                    subtitle: 'Customize your running experience',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPreferencesSettings(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff3abeff).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xff3abeff),
              ),
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
                      color: Color(0xff1b1f3b),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff666666),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xff888b94),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
