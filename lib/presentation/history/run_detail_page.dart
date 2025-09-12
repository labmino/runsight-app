import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_module/data/model/run.dart';
import '../../controller/run_controller.dart';
import '../../widgets/openstreet_route_map.dart';
import 'fullscreen_map_page.dart';

class RunDetailPage extends StatefulWidget {
  final Run run;

  const RunDetailPage({super.key, required this.run});

  @override
  State<RunDetailPage> createState() => _RunDetailPageState();
}

class _RunDetailPageState extends State<RunDetailPage> {
  Run? detailedRun;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRunDetails();
  }

  void _loadRunDetails() async {
    print('RunDetail - Loading details for run ID: ${widget.run.id}');
    final runController = Provider.of<RunController>(context, listen: false);

    print('RunDetail - Original run steps: ${widget.run.stepsCount}');
    print('RunDetail - Original run notes: ${widget.run.notes}');
    print('RunDetail - Original run routeData: ${widget.run.routeData}');

    final detailed = await runController.getRunDetails(widget.run.id);

    if (detailed != null) {
      print('RunDetail - SUCCESS: Got detailed run data');
      print('RunDetail - Detailed run steps: ${detailed.stepsCount}');
      print('RunDetail - Detailed run notes: ${detailed.notes}');
      print('RunDetail - Detailed run routeData: ${detailed.routeData}');
    } else {
      print('RunDetail - ERROR: Failed to get detailed run data');
      print('RunDetail - Controller error: ${runController.errorMessage}');
    }

    setState(() {
      detailedRun = detailed ?? widget.run;
      isLoading = false;
    });
  }

  Run get currentRun => detailedRun ?? widget.run;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xff1b1f3b),
        body: Center(
          child: CircularProgressIndicator(color: const Color(0xff3abeff)),
        ),
      );
    }

    // Debug current data
    print('RunDetail BUILD - Steps: ${currentRun.stepsCount}');
    print('RunDetail BUILD - Notes: ${currentRun.notes}');
    print('RunDetail BUILD - Notes length: ${currentRun.notes?.length}');
    print(
      'RunDetail BUILD - RouteData exists: ${currentRun.routeData != null}',
    );
    print(
      'RunDetail BUILD - RouteData length: ${currentRun.routeData?.length}',
    );
    print('RunDetail BUILD - Distance: ${currentRun.distanceMeters}');
    print('RunDetail BUILD - Duration: ${currentRun.durationSeconds}');
    print('RunDetail BUILD - Waypoints count: ${currentRun.waypoints.length}');
    return Scaffold(
      backgroundColor: const Color(0xff1b1f3b),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                left: 24,
                top: 0,
                right: 24,
                bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRunSummary(),
                  const SizedBox(height: 20),
                  _buildPaceChart(),
                  const SizedBox(height: 20),
                  _buildRouteMap(),
                  const SizedBox(height: 20),
                  _buildRunNotes(),
                  const SizedBox(height: 20), // Extra bottom padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          top: 16,
          right: 24,
          bottom: 16,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                size: 24,
                color: const Color(0xffffffff),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentRun.title ?? 'Morning Run',
                    style: TextStyle(
                      fontSize: 22,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateTime(currentRun.startedAt),
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xff3abeff),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xff3abeff),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.directions_run,
                size: 24,
                color: const Color(0xffffffff),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunSummary() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Run Summary',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatColumn(_formatDistanceMeters(), 'meters'),
              _buildStatColumn(_formatDuration(), 'minutes'),
              _buildStatColumn(_calculatePace(), 'min/km'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSmallStatColumn(
                '${currentRun.caloriesBurned ?? 0}',
                'calories',
              ),
              _buildSmallStatColumn('${currentRun.stepsCount ?? 0}', 'steps'),
              _buildSmallStatColumn(
                '${currentRun.avgSpeedKmh?.toStringAsFixed(1) ?? '0.0'}',
                'km/h',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: const Color(0xffcccccc)),
        ),
      ],
    );
  }

  Widget _buildSmallStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: const Color(0xff3abeff),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: const Color(0xffcccccc)),
        ),
      ],
    );
  }

  Widget _buildPaceChart() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pace Over Time',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff3abeff),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volume_up, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Listen',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xfff8fafc),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildPaceLineChart(),
          ),
          const SizedBox(height: 12),
          Text(
            'Average: ${_calculatePace()} min/km • Fastest: ${_getFastestPace()} • Slowest: ${_getSlowestPace()}',
            style: TextStyle(fontSize: 12, color: const Color(0xffcccccc)),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteMap() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Route Map',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (currentRun.waypoints.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3abeff),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map, size: 16, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        '${currentRun.waypoints.length} pts',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Main Route Map Visualization
          GestureDetector(
            onTap: currentRun.waypoints.isNotEmpty
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FullscreenMapPage(run: currentRun),
                      ),
                    );
                  }
                : null,
            child: Container(
              height: 250,
              width: double.infinity,
              child: Stack(
                children: [
                  currentRun.waypoints.isNotEmpty
                      ? OpenStreetRouteMap(
                          waypoints: currentRun.waypoints,
                          height: 250,
                          width: double.infinity,
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff1b1f3b),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map_outlined,
                                  size: 48,
                                  color: Color(0xffcccccc),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'No Route Data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xffcccccc),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'GPS tracking was not available',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xffcccccc),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                  // Tap to expand overlay
                  if (currentRun.waypoints.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fullscreen,
                              size: 14,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              'Tap to expand',
                              style: TextStyle(
                                fontSize: 10,
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
            ),
          ),

          const SizedBox(height: 16),

          // Route Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff1b1f3b),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRouteStatItem(
                      '${currentRun.totalWaypoints}',
                      'total points',
                      Icons.location_on,
                    ),
                    _buildRouteStatItem(
                      '${currentRun.waypoints.length}',
                      'recorded',
                      Icons.route,
                    ),
                    _buildRouteStatItem(
                      '${currentRun.maxSpeedKmh?.toStringAsFixed(1) ?? '0.0'}',
                      'max km/h',
                      Icons.speed,
                    ),
                  ],
                ),
                if (currentRun.waypoints.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Start: ${_formatCoordinate(currentRun.waypoints.first.lat, currentRun.waypoints.first.lng)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xffcccccc),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'End: ${_formatCoordinate(currentRun.waypoints.last.lat, currentRun.waypoints.last.lng)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: const Color(0xffcccccc),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRunNotes() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x193abeff),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Run Notes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            currentRun.notes != null && currentRun.notes!.isNotEmpty
                ? currentRun.notes!
                : 'No notes available for this run.',
            style: TextStyle(
              fontSize: 14,
              color: currentRun.notes != null && currentRun.notes!.isNotEmpty
                  ? const Color(0xffcccccc)
                  : const Color(0xffaaaaaa),
              height: 1.4,
              fontStyle: currentRun.notes == null || currentRun.notes!.isEmpty
                  ? FontStyle.italic
                  : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} • $displayHour:$minute $period';
  }

  String _formatDistance() {
    if (currentRun.distanceMeters == null) return '3.2';
    return (currentRun.distanceMeters! / 1000).toStringAsFixed(1);
  }

  String _formatDistanceMeters() {
    if (currentRun.distanceMeters == null) return '0';
    return currentRun.distanceMeters!.toStringAsFixed(1);
  }

  String _formatDuration() {
    if (currentRun.durationSeconds == null) return '0:00';
    final minutes = currentRun.durationSeconds! ~/ 60;
    final seconds = currentRun.durationSeconds! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _calculatePace() {
    if (currentRun.distanceMeters == null ||
        currentRun.durationSeconds == null) {
      return '0:00';
    }

    final distanceKm = currentRun.distanceMeters! / 1000;
    if (distanceKm <= 0) return '0:00';

    final paceMinutesPerKm = currentRun.durationSeconds! / 60 / distanceKm;
    final minutes = paceMinutesPerKm.floor();
    final seconds = ((paceMinutesPerKm - minutes) * 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getFastestPace() {
    if (currentRun.waypoints.isEmpty) return '0:00';

    double minPace = double.infinity;
    for (final waypoint in currentRun.waypoints) {
      if (waypoint.speed > 0) {
        final pace = 60.0 / waypoint.speed;
        if (pace < minPace) minPace = pace;
      }
    }

    if (minPace == double.infinity) return '0:00';

    final minutes = minPace.floor();
    final seconds = ((minPace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getSlowestPace() {
    if (currentRun.waypoints.isEmpty) return '0:00';

    double maxPace = 0;
    for (final waypoint in currentRun.waypoints) {
      if (waypoint.speed > 0) {
        final pace = 60.0 / waypoint.speed;
        if (pace > maxPace) maxPace = pace;
      }
    }

    if (maxPace == 0) return '0:00';

    final minutes = maxPace.floor();
    final seconds = ((maxPace - minutes) * 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  List<FlSpot> _calculatePaceData() {
    if (currentRun.waypoints.isEmpty) return [];

    final startTime = currentRun.waypoints.first.timestamp;
    final spots = <FlSpot>[];

    for (final waypoint in currentRun.waypoints) {
      if (waypoint.speed > 0) {
        final elapsedMinutes =
            waypoint.timestamp.difference(startTime).inSeconds / 60.0;
        final paceMinPerKm = 60.0 / waypoint.speed; // Convert km/h to min/km
        spots.add(FlSpot(elapsedMinutes, paceMinPerKm));
      }
    }

    return spots;
  }

  Widget _buildPaceLineChart() {
    final paceData = _calculatePaceData();

    if (paceData.isEmpty) {
      return Center(
        child: Text(
          'No pace data available',
          style: TextStyle(color: const Color(0xffcccccc), fontSize: 14),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final minutes = value.floor();
                  final seconds = ((value - minutes) * 60).round();
                  return Text(
                    '$minutes:${seconds.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: const Color(0xffcccccc),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  final minutes = value.round();
                  return Text(
                    '${minutes}m',
                    style: TextStyle(
                      color: const Color(0xffcccccc),
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: paceData,
              isCurved: true,
              color: const Color(0xff3abeff),
              barWidth: 2,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: const Color(0xff3abeff).withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xff3abeff)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: const Color(0xffcccccc)),
        ),
      ],
    );
  }

  String _formatStartEndCoordinates() {
    final waypoints = currentRun.waypoints;
    if (waypoints.isEmpty) return 'No route data';

    final start = waypoints.first;
    final end = waypoints.last;

    return 'Start: ${start.lat.toStringAsFixed(4)}, ${start.lng.toStringAsFixed(4)} → End: ${end.lat.toStringAsFixed(4)}, ${end.lng.toStringAsFixed(4)}';
  }

  String _formatCoordinate(double lat, double lng) {
    return '${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
  }
}
