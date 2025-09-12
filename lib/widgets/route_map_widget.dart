import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../app_module/data/model/run.dart';

class RouteMapWidget extends StatelessWidget {
  final List<Waypoint> waypoints;
  final double height;
  final double width;

  const RouteMapWidget({
    super.key,
    required this.waypoints,
    this.height = 200,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    if (waypoints.isEmpty) {
      return Container(
        height: height,
        width: width,
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
      );
    }

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xff1b1f3b),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CustomPaint(
          size: Size(width, height),
          painter: RouteMapPainter(waypoints: waypoints),
          child: Container(),
        ),
      ),
    );
  }
}

class RouteMapPainter extends CustomPainter {
  final List<Waypoint> waypoints;

  RouteMapPainter({required this.waypoints});

  @override
  void paint(Canvas canvas, Size size) {
    if (waypoints.length < 2) return;

    // Calculate bounds
    final bounds = _calculateBounds();
    
    // Add padding
    const padding = 20.0;
    final drawableWidth = size.width - (padding * 2);
    final drawableHeight = size.height - (padding * 2);

    // Paint styles
    final routePaint = Paint()
      ..color = const Color(0xff3abeff)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final startPointPaint = Paint()
      ..color = const Color(0xff10b981)
      ..style = PaintingStyle.fill;

    final endPointPaint = Paint()
      ..color = const Color(0xffef4444)
      ..style = PaintingStyle.fill;

    final backgroundPaint = Paint()
      ..color = const Color(0xff0f1729)
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw grid lines for reference
    _drawGrid(canvas, size);

    // Convert waypoints to screen coordinates
    final points = waypoints.map((waypoint) {
      final x = padding + ((waypoint.lng - bounds.minLng) / bounds.lngRange) * drawableWidth;
      final y = padding + drawableHeight - ((waypoint.lat - bounds.minLat) / bounds.latRange) * drawableHeight;
      return Offset(x, y);
    }).toList();

    // Draw route path
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      
      canvas.drawPath(path, routePaint);
    }

    // Draw waypoint markers (only show a subset for performance)
    final markerInterval = math.max(1, waypoints.length ~/ 20); // Show max 20 markers
    for (int i = 0; i < points.length; i += markerInterval) {
      if (i == 0) {
        // Start point
        canvas.drawCircle(points[i], 6, startPointPaint);
        canvas.drawCircle(points[i], 3, Paint()..color = Colors.white);
      } else if (i >= points.length - markerInterval) {
        // End point
        canvas.drawCircle(points.last, 6, endPointPaint);
        canvas.drawCircle(points.last, 3, Paint()..color = Colors.white);
      } else {
        // Intermediate waypoints
        canvas.drawCircle(points[i], 2, Paint()..color = const Color(0xff3abeff).withOpacity(0.6));
      }
    }

    // Draw speed heat map overlay
    _drawSpeedHeatMap(canvas, points, waypoints);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xff3abeff).withOpacity(0.1)
      ..strokeWidth = 0.5;

    const gridSpacing = 40.0;
    
    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSpacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    
    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawSpeedHeatMap(Canvas canvas, List<Offset> points, List<Waypoint> waypoints) {
    if (points.length != waypoints.length) return;

    // Find min and max speeds
    final speeds = waypoints.map((w) => w.speed).toList();
    final minSpeed = speeds.reduce(math.min);
    final maxSpeed = speeds.reduce(math.max);
    
    if (maxSpeed - minSpeed < 0.1) return; // No significant speed variation

    for (int i = 0; i < points.length; i++) {
      final normalizedSpeed = (waypoints[i].speed - minSpeed) / (maxSpeed - minSpeed);
      
      // Color from blue (slow) to red (fast)
      final color = Color.lerp(
        const Color(0xff3abeff),
        const Color(0xffef4444),
        normalizedSpeed,
      )!;

      final speedPaint = Paint()
        ..color = color.withOpacity(0.7)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[i], 3, speedPaint);
    }
  }

  RouteBounds _calculateBounds() {
    if (waypoints.isEmpty) {
      return RouteBounds(
        minLat: 0, maxLat: 0, minLng: 0, maxLng: 0,
        latRange: 1, lngRange: 1,
      );
    }

    double minLat = waypoints.first.lat;
    double maxLat = waypoints.first.lat;
    double minLng = waypoints.first.lng;
    double maxLng = waypoints.first.lng;

    for (final waypoint in waypoints) {
      minLat = math.min(minLat, waypoint.lat);
      maxLat = math.max(maxLat, waypoint.lat);
      minLng = math.min(minLng, waypoint.lng);
      maxLng = math.max(maxLng, waypoint.lng);
    }

    // Add some padding to bounds
    final latPadding = (maxLat - minLat) * 0.1;
    final lngPadding = (maxLng - minLng) * 0.1;
    
    minLat -= latPadding;
    maxLat += latPadding;
    minLng -= lngPadding;
    maxLng += lngPadding;

    return RouteBounds(
      minLat: minLat,
      maxLat: maxLat,
      minLng: minLng,
      maxLng: maxLng,
      latRange: maxLat - minLat,
      lngRange: maxLng - minLng,
    );
  }

  @override
  bool shouldRepaint(covariant RouteMapPainter oldDelegate) {
    return oldDelegate.waypoints != waypoints;
  }
}

class RouteBounds {
  final double minLat;
  final double maxLat;
  final double minLng;
  final double maxLng;
  final double latRange;
  final double lngRange;

  RouteBounds({
    required this.minLat,
    required this.maxLat,
    required this.minLng,
    required this.maxLng,
    required this.latRange,
    required this.lngRange,
  });
}

// Additional widget for route statistics overlay
class RouteStatsOverlay extends StatelessWidget {
  final List<Waypoint> waypoints;

  const RouteStatsOverlay({super.key, required this.waypoints});

  @override
  Widget build(BuildContext context) {
    if (waypoints.isEmpty) return const SizedBox.shrink();

    final distance = _calculateTotalDistance();
    final maxSpeed = waypoints.map((w) => w.speed).reduce(math.max);
    final avgSpeed = waypoints.map((w) => w.speed).reduce((a, b) => a + b) / waypoints.length;

    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xff1b1f3b).withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(distance / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${waypoints.length} points',
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xffcccccc),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotalDistance() {
    if (waypoints.length < 2) return 0.0;

    double totalDistance = 0.0;
    for (int i = 1; i < waypoints.length; i++) {
      totalDistance += _calculateDistance(waypoints[i - 1], waypoints[i]);
    }
    return totalDistance;
  }

  double _calculateDistance(Waypoint point1, Waypoint point2) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = point1.lat * math.pi / 180;
    final lat2Rad = point2.lat * math.pi / 180;
    final deltaLatRad = (point2.lat - point1.lat) * math.pi / 180;
    final deltaLngRad = (point2.lng - point1.lng) * math.pi / 180;

    final a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }
}