import 'package:flutter/material.dart';

class UserPreferencesSettings extends StatefulWidget {
  const UserPreferencesSettings({super.key});

  @override
  State<UserPreferencesSettings> createState() => _UserPreferencesSettingsState();
}

class _UserPreferencesSettingsState extends State<UserPreferencesSettings> {
  String selectedWeeklyGoal = '3 times per week';
  String selectedRunningMode = 'Beginner Mode';
  bool morningReminder = true;
  bool eveningReminder = true;
  bool restDayReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        title: const Text(
          'User Preferences',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeeklyGoalSection(),
                  const SizedBox(height: 24),
                  _buildRunningModeSection(),
                  const SizedBox(height: 24),
                  _buildDailyRemindersSection(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Running Goal',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildGoalOption(
          title: '3 times per week',
          description: 'Beginner friendly schedule',
          value: '3 times per week',
        ),
        const SizedBox(height: 12),
        _buildGoalOption(
          title: '5 times per week',
          description: 'Regular runner schedule',
          value: '5 times per week',
        ),
        const SizedBox(height: 12),
        _buildGoalOption(
          title: 'Daily running',
          description: 'Advanced runner schedule',
          value: 'Daily running',
        ),
      ],
    );
  }

  Widget _buildGoalOption({
    required String title,
    required String description,
    required String value,
  }) {
    final isSelected = selectedWeeklyGoal == value;

    return GestureDetector(
      onTap: () => setState(() => selectedWeeklyGoal = value),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isSelected ? Border.all(color: const Color(0xff3abeff), width: 2) : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
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
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xff3abeff) : const Color(0xffe5e7eb),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRunningModeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Preferred Running Mode',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _showRunningModeSelector,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedRunningMode,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xff1b1f3b),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.expand_more,
                    color: Color(0xff666666),
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

  Widget _buildDailyRemindersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Reminders',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
        _buildReminderOption(
          title: 'Morning Reminder',
          description: '7:00 AM daily motivation',
          value: morningReminder,
          onChanged: (value) => setState(() => morningReminder = value),
        ),
        const SizedBox(height: 12),
        _buildReminderOption(
          title: 'Evening Reminder',
          description: '6:00 PM gentle nudge',
          value: eveningReminder,
          onChanged: (value) => setState(() => eveningReminder = value),
        ),
        const SizedBox(height: 12),
        _buildReminderOption(
          title: 'Rest Day Reminder',
          description: 'Recovery day suggestions',
          value: restDayReminder,
          onChanged: (value) => setState(() => restDayReminder = value),
        ),
      ],
    );
  }

  Widget _buildReminderOption({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
            Container(
              width: 48,
              height: 28,
              decoration: BoxDecoration(
                color: value ? const Color(0xff3abeff) : const Color(0xffe5e7eb),
                borderRadius: BorderRadius.circular(14),
              ),
              child: GestureDetector(
                onTap: () => onChanged(!value),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xff3abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _savePreferences,
        child: const Text(
          'Save Preferences',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xff1b1f3b),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showRunningModeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Running Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xff1b1f3b),
              ),
            ),
            const SizedBox(height: 16),
            _buildRunningModeOption('Beginner Mode'),
            _buildRunningModeOption('Intermediate Mode'),
            _buildRunningModeOption('Advanced Mode'),
            _buildRunningModeOption('Custom Mode'),
          ],
        ),
      ),
    );
  }

  Widget _buildRunningModeOption(String mode) {
    return ListTile(
      title: Text(mode),
      onTap: () {
        setState(() => selectedRunningMode = mode);
        Navigator.pop(context);
      },
      trailing: selectedRunningMode == mode
          ? const Icon(Icons.check, color: Color(0xff3abeff))
          : null,
    );
  }

  void _savePreferences() {
    // Show confirmation with current settings
    final enabledReminders = <String>[];
    if (morningReminder) enabledReminders.add('Morning');
    if (eveningReminder) enabledReminders.add('Evening');
    if (restDayReminder) enabledReminders.add('Rest Day');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Preferences Saved',
          style: TextStyle(color: Color(0xff1b1f3b)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weekly Goal: $selectedWeeklyGoal'),
            Text('Running Mode: $selectedRunningMode'),
            Text('Reminders: ${enabledReminders.join(', ')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Color(0xff3abeff)),
            ),
          ),
        ],
      ),
    );
  }
}
