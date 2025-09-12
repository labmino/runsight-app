import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<CommunityPost> _posts = [
    CommunityPost(
      id: '1',
      userName: 'Maria Santos',
      userInitial: 'M',
      timeAgo: '2 hours ago',
      content:
          'Just completed my first 5K with RunSight! The voice guidance was incredible - felt so confident navigating the new trail. Thank you to this amazing community for all the encouragement! 🏃‍♀️✨',
      runData: RunData(
        title: "Today's Run Summary",
        distance: '3.1',
        distanceUnit: 'miles',
        time: '32:15',
        timeUnit: 'minutes',
        pace: '10:23',
        paceUnit: 'min/mile',
      ),
      reactions: {'👏': 12, '❤️': 8, '🔥': 5},
    ),
    CommunityPost(
      id: '2',
      userName: 'James Chen',
      userInitial: 'J',
      timeAgo: '5 hours ago',
      content:
          'Week 3 of training for the Virtual Boston Marathon! Today\'s long run was challenging but the community support keeps me going. Special thanks to everyone sharing tips in the forum! 💪',
      runData: RunData(
        title: "Today's Long Run",
        distance: '8.2',
        distanceUnit: 'miles',
        time: '1:15:30',
        timeUnit: 'time',
        pace: '9:12',
        paceUnit: 'min/mile',
      ),
      reactions: {'👏': 18, '❤️': 15, '💪': 9},
    ),
    CommunityPost(
      id: '3',
      userName: 'Alex Rivera',
      userInitial: 'A',
      timeAgo: '1 day ago',
      content:
          'Milestone achieved! 🎉 Just hit 100 miles total with RunSight. This app has transformed my running experience. The confidence I\'ve gained is incredible!',
      achievement: Achievement(
        title: '100 Mile Milestone!',
        description: 'Total distance achievement unlocked',
        icon: '🏆',
      ),
      reactions: {'🎉': 25, '❤️': 20, '🏆': 12},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _buildPostCard(_posts[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x193abeff),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Community',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 52),
            child: Text(
              'Connect with fellow runners',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(CommunityPost post) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(post),
          const SizedBox(height: 16),
          _buildContent(post),
          if (post.runData != null) ...[
            const SizedBox(height: 16),
            _buildRunDataCard(post.runData!),
          ],
          if (post.achievement != null) ...[
            const SizedBox(height: 16),
            _buildAchievementCard(post.achievement!),
          ],
          const SizedBox(height: 16),
          _buildReactions(post),
        ],
      ),
    );
  }

  Widget _buildUserHeader(CommunityPost post) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xff3abeff),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              post.userInitial,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.userName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                post.timeAgo,
                style: const TextStyle(fontSize: 12, color: Color(0xff888b94)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContent(CommunityPost post) {
    return Text(
      post.content,
      style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.4),
    );
  }

  Widget _buildRunDataCard(RunData runData) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1b1f3b),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            runData.title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xff3abeff),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(runData.distance, runData.distanceUnit),
              _buildStatColumn(runData.time, runData.timeUnit),
              _buildStatColumn(runData.pace, runData.paceUnit),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(achievement.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  achievement.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff3abeff),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            achievement.description,
            style: const TextStyle(fontSize: 12, color: Color(0xff3abeff)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          unit,
          style: const TextStyle(fontSize: 10, color: Color(0xff888b94)),
        ),
      ],
    );
  }

  Widget _buildReactions(CommunityPost post) {
    return Row(
      children: [
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: post.reactions.entries.map((entry) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    post.reactions[entry.key] = entry.value + 1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(entry.key, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 8),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xff3abeff),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            _showCommentDialog(post);
          },
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.comment_outlined,
                  size: 16,
                  color: Color(0xff3abeff),
                ),
                SizedBox(width: 8),
                Text(
                  'Comment',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff3abeff),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCommentDialog(CommunityPost post) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0x193abeff),
        title: const Text('Comments', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Comment feature coming soon!',
          style: TextStyle(color: Color(0xff888b94)),
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
}

class CommunityPost {
  final String id;
  final String userName;
  final String userInitial;
  final String timeAgo;
  final String content;
  final RunData? runData;
  final Achievement? achievement;
  final Map<String, int> reactions;

  CommunityPost({
    required this.id,
    required this.userName,
    required this.userInitial,
    required this.timeAgo,
    required this.content,
    this.runData,
    this.achievement,
    required this.reactions,
  });
}

class RunData {
  final String title;
  final String distance;
  final String distanceUnit;
  final String time;
  final String timeUnit;
  final String pace;
  final String paceUnit;

  RunData({
    required this.title,
    required this.distance,
    required this.distanceUnit,
    required this.time,
    required this.timeUnit,
    required this.pace,
    required this.paceUnit,
  });
}

class Achievement {
  final String title;
  final String description;
  final String icon;

  Achievement({
    required this.title,
    required this.description,
    required this.icon,
  });
}
