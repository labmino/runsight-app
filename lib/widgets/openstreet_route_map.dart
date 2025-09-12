import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../app_module/data/model/run.dart';

class OpenStreetRouteMap extends StatelessWidget {
  final List<Waypoint> waypoints;
  final double height;
  final double width;

  const OpenStreetRouteMap({
    super.key,
    required this.waypoints,
    this.height = 300,
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
              Icon(Icons.map_outlined, size: 48, color: Color(0xffcccccc)),
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
                style: TextStyle(fontSize: 12, color: Color(0xffcccccc)),
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff3abeff).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            _buildFlutterMap(),
            _buildMapControls(),
            _buildRouteStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildFlutterMap() {
    final bounds = _calculateBounds();
    final routePoints = waypoints.map((w) => LatLng(w.lat, w.lng)).toList();

    return FlutterMap(
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds(
            LatLng(bounds.minLat, bounds.minLng),
            LatLng(bounds.maxLat, bounds.maxLng),
          ),
        ),
        minZoom: 10.0,
        maxZoom: 18.0,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.scrollWheelZoom | InteractiveFlag.pinchZoom,
        ),
      ),
      children: [
        // OpenStreetMap Tile Layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.runsight_app',
          maxZoom: 19,
        ),

        // Route Polyline
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints,
              strokeWidth: 4.0,
              color: const Color(0xff3abeff),
              borderStrokeWidth: 6.0,
              borderColor: Colors.white.withOpacity(0.5),
              pattern: const StrokePattern.solid(),
            ),
          ],
        ),

        // Speed Heat Map (Optional Polylines with different colors)
        if (waypoints.length > 2) _buildSpeedHeatMapLayer(),

        // Markers Layer
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  Widget _buildSpeedHeatMapLayer() {
    final speeds = waypoints.map((w) => w.speed).toList();
    final minSpeed = speeds.reduce(math.min);
    final maxSpeed = speeds.reduce(math.max);

    if (maxSpeed - minSpeed < 0.1) {
      return const SizedBox.shrink(); // No speed variation
    }

    List<Polyline> speedSegments = [];

    for (int i = 0; i < waypoints.length - 1; i++) {
      final normalizedSpeed =
          (waypoints[i].speed - minSpeed) / (maxSpeed - minSpeed);
      final color = Color.lerp(
        const Color(0xff10b981), // Green for slow
        const Color(0xffef4444), // Red for fast
        normalizedSpeed,
      )!;

      speedSegments.add(
        Polyline(
          points: [
            LatLng(waypoints[i].lat, waypoints[i].lng),
            LatLng(waypoints[i + 1].lat, waypoints[i + 1].lng),
          ],
          strokeWidth: 6.0,
          color: color.withOpacity(0.8),
        ),
      );
    }

    return PolylineLayer(polylines: speedSegments);
  }

  List<Marker> _buildMarkers() {
    List<Marker> markers = [];

    if (waypoints.isNotEmpty) {
      // Start marker
      markers.add(
        Marker(
          point: LatLng(waypoints.first.lat, waypoints.first.lng),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff10b981),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
          ),
        ),
      );

      // End marker
      if (waypoints.length > 1) {
        markers.add(
          Marker(
            point: LatLng(waypoints.last.lat, waypoints.last.lng),
            width: 40,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffef4444),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.stop, color: Colors.white, size: 20),
            ),
          ),
        );
      }

      // Intermediate waypoint markers (show every 10th point for performance)
      final interval = math.max(1, waypoints.length ~/ 10);
      for (int i = interval; i < waypoints.length - interval; i += interval) {
        markers.add(
          Marker(
            point: LatLng(waypoints[i].lat, waypoints[i].lng),
            width: 16,
            height: 16,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff3abeff),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  Widget _buildMapControls() {
    return Positioned(
      top: 8,
      left: 8,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.map, size: 14, color: Colors.white),
                const SizedBox(width: 4),
                const Text(
                  'OpenStreetMap',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStats() {
    final distance = _calculateTotalDistance();
    final duration = _calculateRouteDuration();

    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${(distance / 1000).toStringAsFixed(2)} km',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xff3abeff),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${waypoints.length} GPS points',
              style: const TextStyle(fontSize: 10, color: Colors.white70),
            ),
            if (duration.isNotEmpty) ...[
              const SizedBox(height: 2),
              Text(
                duration,
                style: const TextStyle(fontSize: 10, color: Colors.white70),
              ),
            ],
          ],
        ),
      ),
    );
  }

  RouteBounds _calculateBounds() {
    if (waypoints.isEmpty) {
      return RouteBounds(
        minLat: 0,
        maxLat: 0,
        minLng: 0,
        maxLng: 0,
        latRange: 1,
        lngRange: 1,
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

    // Add padding to bounds (5% of range)
    final latPadding = (maxLat - minLat) * 0.05;
    final lngPadding = (maxLng - minLng) * 0.05;

    return RouteBounds(
      minLat: minLat - latPadding,
      maxLat: maxLat + latPadding,
      minLng: minLng - lngPadding,
      maxLng: maxLng + lngPadding,
      latRange: (maxLat - minLat) + (2 * latPadding),
      lngRange: (maxLng - minLng) + (2 * lngPadding),
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

  String _calculateRouteDuration() {
    if (waypoints.length < 2) return '';

    final start = waypoints.first.timestamp;
    final end = waypoints.last.timestamp;
    final duration = end.difference(start);

    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m ${duration.inSeconds.remainder(60)}s';
    }
  }

  double _calculateDistance(Waypoint point1, Waypoint point2) {
    const double earthRadius = 6371000; // meters

    final lat1Rad = point1.lat * math.pi / 180;
    final lat2Rad = point2.lat * math.pi / 180;
    final deltaLatRad = (point2.lat - point1.lat) * math.pi / 180;
    final deltaLngRad = (point2.lng - point1.lng) * math.pi / 180;

    final a =
        math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLngRad / 2) *
            math.sin(deltaLngRad / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
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

// Interactive Route Map Widget with zoom controls
class InteractiveRouteMap extends StatefulWidget {
  final List<Waypoint> waypoints;
  final double height;

  const InteractiveRouteMap({
    super.key,
    required this.waypoints,
    this.height = 400,
  });

  @override
  State<InteractiveRouteMap> createState() => _InteractiveRouteMapState();
}

class _InteractiveRouteMapState extends State<InteractiveRouteMap> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    if (widget.waypoints.isEmpty) {
      return OpenStreetRouteMap(
        waypoints: widget.waypoints,
        height: widget.height,
      );
    }

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xff3abeff).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            OpenStreetRouteMap(
              waypoints: widget.waypoints,
              height: widget.height,
            ),
            _buildZoomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      right: 8,
      top: 8,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    // Zoom in functionality would be implemented here
                    // _mapController.zoom += 1;
                  },
                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
                Container(height: 1, color: Colors.white.withOpacity(0.3)),
                IconButton(
                  onPressed: () {
                    // Zoom out functionality would be implemented here
                    // _mapController.zoom -= 1;
                  },
                  icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
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
