import 'user.dart';

class Run {
  final String id;
  final String userId;
  final String deviceId;
  final String sessionId;
  final String? title;
  final String? notes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final int? caloriesBurned;
  final int? stepsCount;
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;

  Run({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.sessionId,
    this.title,
    this.notes,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.distanceMeters,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    this.caloriesBurned,
    this.stepsCount,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Run.fromJson(Map<String, dynamic> json) {
    return Run(
      id: json['id'],
      userId: json['user_id'],
      deviceId: json['device_id'],
      sessionId: json['session_id'],
      title: json['title'],
      notes: json['notes'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      durationSeconds: json['duration_seconds'],
      distanceMeters: json['distance_meters']?.toDouble(),
      avgSpeedKmh: json['avg_speed_kmh']?.toDouble(),
      maxSpeedKmh: json['max_speed_kmh']?.toDouble(),
      caloriesBurned: json['calories_burned'],
      stepsCount: json['steps_count'],
      startLatitude: json['start_latitude']?.toDouble(),
      startLongitude: json['start_longitude']?.toDouble(),
      endLatitude: json['end_latitude']?.toDouble(),
      endLongitude: json['end_longitude']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'device_id': deviceId,
      'session_id': sessionId,
      'title': title,
      'notes': notes,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'distance_meters': distanceMeters,
      'avg_speed_kmh': avgSpeedKmh,
      'max_speed_kmh': maxSpeedKmh,
      'calories_burned': caloriesBurned,
      'steps_count': stepsCount,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  // Helper methods for calculating run statistics
  String get formattedDuration {
    if (durationSeconds == null) return '00:00:00';

    final hours = durationSeconds! ~/ 3600;
    final minutes = (durationSeconds! % 3600) ~/ 60;
    final seconds = durationSeconds! % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedDistance {
    if (distanceMeters == null) return '0.00 km';
    return '${(distanceMeters! / 1000).toStringAsFixed(2)} km';
  }

  String get formattedAvgSpeed {
    if (avgSpeedKmh == null) return '0.0 km/h';
    return '${avgSpeedKmh!.toStringAsFixed(1)} km/h';
  }

  String get formattedMaxSpeed {
    if (maxSpeedKmh == null) return '0.0 km/h';
    return '${maxSpeedKmh!.toStringAsFixed(1)} km/h';
  }
}

class RunCreateRequest {
  final String deviceId;
  final String sessionId;
  final String? title;
  final String? notes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final int? caloriesBurned;
  final int? stepsCount;
  final double? startLatitude;
  final double? startLongitude;
  final double? endLatitude;
  final double? endLongitude;

  RunCreateRequest({
    required this.deviceId,
    required this.sessionId,
    this.title,
    this.notes,
    required this.startedAt,
    this.endedAt,
    this.durationSeconds,
    this.distanceMeters,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    this.caloriesBurned,
    this.stepsCount,
    this.startLatitude,
    this.startLongitude,
    this.endLatitude,
    this.endLongitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'session_id': sessionId,
      'title': title,
      'notes': notes,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'duration_seconds': durationSeconds,
      'distance_meters': distanceMeters,
      'avg_speed_kmh': avgSpeedKmh,
      'max_speed_kmh': maxSpeedKmh,
      'calories_burned': caloriesBurned,
      'steps_count': stepsCount,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'end_latitude': endLatitude,
      'end_longitude': endLongitude,
    };
  }

  factory RunCreateRequest.fromJson(Map<String, dynamic> json) {
    return RunCreateRequest(
      deviceId: json['device_id'],
      sessionId: json['session_id'],
      title: json['title'],
      notes: json['notes'],
      startedAt: DateTime.parse(json['started_at']),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      durationSeconds: json['duration_seconds'],
      distanceMeters: json['distance_meters']?.toDouble(),
      avgSpeedKmh: json['avg_speed_kmh']?.toDouble(),
      maxSpeedKmh: json['max_speed_kmh']?.toDouble(),
      caloriesBurned: json['calories_burned'],
      stepsCount: json['steps_count'],
      startLatitude: json['start_latitude']?.toDouble(),
      startLongitude: json['start_longitude']?.toDouble(),
      endLatitude: json['end_latitude']?.toDouble(),
      endLongitude: json['end_longitude']?.toDouble(),
    );
  }
}

class RunUpdateRequest {
  final String? title;
  final String? notes;
  final DateTime? endedAt;
  final int? durationSeconds;
  final double? distanceMeters;
  final double? avgSpeedKmh;
  final double? maxSpeedKmh;
  final int? caloriesBurned;
  final int? stepsCount;
  final double? endLatitude;
  final double? endLongitude;

  RunUpdateRequest({
    this.title,
    this.notes,
    this.endedAt,
    this.durationSeconds,
    this.distanceMeters,
    this.avgSpeedKmh,
    this.maxSpeedKmh,
    this.caloriesBurned,
    this.stepsCount,
    this.endLatitude,
    this.endLongitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (title != null) data['title'] = title;
    if (notes != null) data['notes'] = notes;
    if (endedAt != null) data['ended_at'] = endedAt!.toIso8601String();
    if (durationSeconds != null) data['duration_seconds'] = durationSeconds;
    if (distanceMeters != null) data['distance_meters'] = distanceMeters;
    if (avgSpeedKmh != null) data['avg_speed_kmh'] = avgSpeedKmh;
    if (maxSpeedKmh != null) data['max_speed_kmh'] = maxSpeedKmh;
    if (caloriesBurned != null) data['calories_burned'] = caloriesBurned;
    if (stepsCount != null) data['steps_count'] = stepsCount;
    if (endLatitude != null) data['end_latitude'] = endLatitude;
    if (endLongitude != null) data['end_longitude'] = endLongitude;

    return data;
  }

  factory RunUpdateRequest.fromJson(Map<String, dynamic> json) {
    return RunUpdateRequest(
      title: json['title'],
      notes: json['notes'],
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'])
          : null,
      durationSeconds: json['duration_seconds'],
      distanceMeters: json['distance_meters']?.toDouble(),
      avgSpeedKmh: json['avg_speed_kmh']?.toDouble(),
      maxSpeedKmh: json['max_speed_kmh']?.toDouble(),
      caloriesBurned: json['calories_burned'],
      stepsCount: json['steps_count'],
      endLatitude: json['end_latitude']?.toDouble(),
      endLongitude: json['end_longitude']?.toDouble(),
    );
  }
}

// Enum untuk status run
enum RunStatus { active, completed, paused }

extension RunStatusExtension on RunStatus {
  String get value {
    switch (this) {
      case RunStatus.active:
        return 'active';
      case RunStatus.completed:
        return 'completed';
      case RunStatus.paused:
        return 'paused';
    }
  }

  static RunStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return RunStatus.active;
      case 'completed':
        return RunStatus.completed;
      case 'paused':
        return RunStatus.paused;
      default:
        return RunStatus.active;
    }
  }
}
