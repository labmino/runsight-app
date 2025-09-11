import 'package:flutter/material.dart';
import '../../app_module/data/model/run.dart';

class RunDetailPage extends StatefulWidget {
  final Run run;

  const RunDetailPage({super.key, required this.run});

  @override
  State<RunDetailPage> createState() => _RunDetailPageState();
}

class _RunDetailPageState extends State<RunDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: 375,
        height: 812,
        decoration: BoxDecoration(color: const Color(0xff1b1f3b)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                height: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 0,
                    right: 24,
                    bottom: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRunSummary(),
                      const SizedBox(height: 20),
                      _buildPaceChart(),
                      const SizedBox(height: 20),
                      _buildRouteMap(),
                      const SizedBox(height: 20),
                      _buildRunNotes(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                top: 48,
                right: 24,
                bottom: 16,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        widget.run.title ?? 'Morning Run',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 22,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      child: Text(
                                        _formatDateTime(widget.run.startedAt),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 14,
                                          color: const Color(0xff3abeff),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
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
          ),
        ),
      ],
    );
  }

  Widget _buildRunSummary() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Run Summary',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: const Color(0xff1b1f3b),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatDistance(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 28,
                                      color: const Color(0xff1b1f3b),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'km',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _formatDuration(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 28,
                                      color: const Color(0xff1b1f3b),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'minutes',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    _calculatePace(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 28,
                                      color: const Color(0xff1b1f3b),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'min/km',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.run.caloriesBurned ?? 285}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xff3abeff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'calories',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.run.stepsCount ?? 4120}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xff3abeff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'steps',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${widget.run.avgSpeedKmh?.toStringAsFixed(1) ?? '45'} m',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xff3abeff),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'avg speed',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 12,
                                      color: const Color(0xff666666),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
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
          ),
        ),
      ],
    );
  }

  Widget _buildPaceChart() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Pace Over Time',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xff1b1f3b),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff3abeff),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 6,
                                    right: 12,
                                    bottom: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.volume_up,
                                        size: 16,
                                        color: const Color(0xffffffff),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Listen',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xfff8fafc),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Pace Chart\n(Simulated Data)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xff666666),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Average pace: ${_calculatePace()} min/km • Fastest: ${_getFastestPace()} • Slowest: ${_getSlowestPace()}',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRouteMap() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    'Route Map',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.none,
                                      fontSize: 16,
                                      color: const Color(0xff1b1f3b),
                                      fontWeight: FontWeight.normal,
                                    ),
                                    maxLines: 9999,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff3abeff),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    top: 6,
                                    right: 12,
                                    bottom: 6,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.description,
                                        size: 16,
                                        color: const Color(0xffffffff),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Describe',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 12,
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.normal,
                                        ),
                                        maxLines: 9999,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: const Color(0xfff0f8ff),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.map,
                                size: 60,
                                color: const Color(0xff3abeff),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Route Map',
                                style: TextStyle(
                                  color: const Color(0xff1b1f3b),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Start → Finish',
                                style: TextStyle(
                                  color: const Color(0xff666666),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Route: Park Loop Trail • Total max speed: ${widget.run.maxSpeedKmh?.toStringAsFixed(1) ?? '45'} km/h',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 12,
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRunNotes() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xffffffff),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            'Run Notes',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: const Color(0xff1b1f3b),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.run.notes ??
                                'Great morning run! Weather was perfect and felt strong throughout. Voice guidance worked perfectly.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: const Color(0xff666666),
                              fontWeight: FontWeight.normal,
                            ),
                            maxLines: 9999,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
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
    if (widget.run.distanceMeters == null) return '3.2';
    return (widget.run.distanceMeters! / 1000).toStringAsFixed(1);
  }

  String _formatDuration() {
    if (widget.run.durationSeconds == null) return '28:45';
    final minutes = widget.run.durationSeconds! ~/ 60;
    final seconds = widget.run.durationSeconds! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _calculatePace() {
    if (widget.run.distanceMeters == null ||
        widget.run.durationSeconds == null) {
      return '9:02';
    }

    final distanceKm = widget.run.distanceMeters! / 1000;
    if (distanceKm <= 0) return '0:00';

    final paceMinutesPerKm = widget.run.durationSeconds! / 60 / distanceKm;
    final minutes = paceMinutesPerKm.floor();
    final seconds = ((paceMinutesPerKm - minutes) * 60).round();

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getFastestPace() {
    // Simulate fastest pace (10% faster than average)
    final avgPace = _calculatePace();
    final parts = avgPace.split(':');
    if (parts.length != 2) return '8:15';

    final totalSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final fastestSeconds = (totalSeconds * 0.9).round();
    final minutes = fastestSeconds ~/ 60;
    final seconds = fastestSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String _getSlowestPace() {
    // Simulate slowest pace (15% slower than average)
    final avgPace = _calculatePace();
    final parts = avgPace.split(':');
    if (parts.length != 2) return '9:45';

    final totalSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
    final slowestSeconds = (totalSeconds * 1.15).round();
    final minutes = slowestSeconds ~/ 60;
    final seconds = slowestSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
