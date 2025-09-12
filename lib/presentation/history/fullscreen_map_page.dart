import 'package:flutter/material.dart';
import '../../app_module/data/model/run.dart';
import '../../widgets/openstreet_route_map.dart';

class FullscreenMapPage extends StatelessWidget {
  final Run run;

  const FullscreenMapPage({super.key, required this.run});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      appBar: AppBar(
        backgroundColor: const Color(0xff1b1f3b),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Container(
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              run.title ?? 'Run Route',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatRunDate(run.startedAt),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xffcccccc),
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showMapLegend(context);
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0x193abeff),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: run.waypoints.isNotEmpty
          ? InteractiveRouteMap(
              waypoints: run.waypoints,
              height: MediaQuery.of(context).size.height,
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Color(0xffcccccc),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No GPS Data Available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This run was completed without GPS tracking',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xffcccccc),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: run.waypoints.isNotEmpty
          ? _buildBottomStats(context)
          : null,
    );
  }

  Widget _buildBottomStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0x193abeff),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffcccccc).withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  icon: Icons.straighten,
                  label: 'Distance',
                  value: run.formattedDistance,
                  color: const Color(0xff3abeff),
                ),
                _buildStatItem(
                  icon: Icons.timer,
                  label: 'Duration',
                  value: run.formattedDuration,
                  color: const Color(0xff10b981),
                ),
                _buildStatItem(
                  icon: Icons.speed,
                  label: 'Avg Speed',
                  value: run.formattedAvgSpeed,
                  color: const Color(0xfff59e0b),
                ),
                _buildStatItem(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${run.caloriesBurned ?? 0}',
                  color: const Color(0xffef4444),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff1b1f3b),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.my_location,
                          size: 16,
                          color: Color(0xff3abeff),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${run.waypoints.length} GPS Points',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xffcccccc),
          ),
        ),
      ],
    );
  }

  String _formatRunDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    
    return '$day $month $year';
  }

  void _showMapLegend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff1b1f3b),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Map Legend',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Color(0xffcccccc),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              _buildLegendItem(
                icon: Icons.play_arrow,
                color: const Color(0xff10b981),
                title: 'Start Point',
                description: 'Where your run began',
              ),
              
              _buildLegendItem(
                icon: Icons.stop,
                color: const Color(0xffef4444),
                title: 'End Point',
                description: 'Where your run finished',
              ),
              
              _buildLegendItem(
                icon: Icons.circle,
                color: const Color(0xff3abeff),
                title: 'Route Path',
                description: 'Your running route with speed colors',
              ),
              
              _buildLegendItem(
                icon: Icons.location_on,
                color: const Color(0xff3abeff),
                title: 'Waypoints',
                description: 'GPS tracking points along the route',
              ),
              
              const SizedBox(height: 8),
              
              const Divider(color: Color(0xff3abeff)),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff10b981), Color(0xffef4444)],
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Speed Visualization: Green (slow) → Red (fast)',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xffcccccc),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xffcccccc),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}