import 'run.dart';

class AIMetrics {
  final String id;
  final String runId;
  final int? totalFramesProcessed;
  final int? totalObstaclesDetected;
  final int? totalWarningsIssued;
  final int? laneDeviationsCount;
  final double? laneKeepingAccuracy;
  final double? avgInferenceTimeMs;
  final double? maxInferenceTimeMs;
  final double? minInferenceTimeMs;
  final DateTime createdAt;
  final Run? run;

  AIMetrics({
    required this.id,
    required this.runId,
    this.totalFramesProcessed,
    this.totalObstaclesDetected,
    this.totalWarningsIssued,
    this.laneDeviationsCount,
    this.laneKeepingAccuracy,
    this.avgInferenceTimeMs,
    this.maxInferenceTimeMs,
    this.minInferenceTimeMs,
    required this.createdAt,
    this.run,
  });

  factory AIMetrics.fromJson(Map<String, dynamic> json) {
    return AIMetrics(
      id: json['id'],
      runId: json['run_id'],
      totalFramesProcessed: json['total_frames_processed'],
      totalObstaclesDetected: json['total_obstacles_detected'],
      totalWarningsIssued: json['total_warnings_issued'],
      laneDeviationsCount: json['lane_deviations_count'],
      laneKeepingAccuracy: json['lane_keeping_accuracy']?.toDouble(),
      avgInferenceTimeMs: json['avg_inference_time_ms']?.toDouble(),
      maxInferenceTimeMs: json['max_inference_time_ms']?.toDouble(),
      minInferenceTimeMs: json['min_inference_time_ms']?.toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      run: json['run'] != null ? Run.fromJson(json['run']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'run_id': runId,
      'total_frames_processed': totalFramesProcessed,
      'total_obstacles_detected': totalObstaclesDetected,
      'total_warnings_issued': totalWarningsIssued,
      'lane_deviations_count': laneDeviationsCount,
      'lane_keeping_accuracy': laneKeepingAccuracy,
      'avg_inference_time_ms': avgInferenceTimeMs,
      'max_inference_time_ms': maxInferenceTimeMs,
      'min_inference_time_ms': minInferenceTimeMs,
      'created_at': createdAt.toIso8601String(),
      'run': run?.toJson(),
    };
  }

  String get laneKeepingAccuracyPercentage {
    if (laneKeepingAccuracy == null) return 'N/A';
    return '${(laneKeepingAccuracy! * 100).toStringAsFixed(1)}%';
  }

  String get avgInferenceTimeFormatted {
    if (avgInferenceTimeMs == null) return 'N/A';
    return '${avgInferenceTimeMs!.toStringAsFixed(2)} ms';
  }

  String get maxInferenceTimeFormatted {
    if (maxInferenceTimeMs == null) return 'N/A';
    return '${maxInferenceTimeMs!.toStringAsFixed(2)} ms';
  }

  String get minInferenceTimeFormatted {
    if (minInferenceTimeMs == null) return 'N/A';
    return '${minInferenceTimeMs!.toStringAsFixed(2)} ms';
  }

  double? get obstacleDetectionRate {
    if (totalFramesProcessed == null || totalObstaclesDetected == null)
      return null;
    if (totalFramesProcessed == 0) return 0.0;
    return totalObstaclesDetected! / totalFramesProcessed!;
  }

  String get obstacleDetectionRatePercentage {
    final rate = obstacleDetectionRate;
    if (rate == null) return 'N/A';
    return '${(rate * 100).toStringAsFixed(1)}%';
  }

  double? get warningRate {
    if (totalFramesProcessed == null || totalWarningsIssued == null)
      return null;
    if (totalFramesProcessed == 0) return 0.0;
    return totalWarningsIssued! / totalFramesProcessed!;
  }

  String get warningRatePercentage {
    final rate = warningRate;
    if (rate == null) return 'N/A';
    return '${(rate * 100).toStringAsFixed(1)}%';
  }

  double? get laneDeviationRate {
    if (totalFramesProcessed == null || laneDeviationsCount == null)
      return null;
    if (totalFramesProcessed == 0) return 0.0;
    return laneDeviationsCount! / totalFramesProcessed!;
  }

  String get laneDeviationRatePercentage {
    final rate = laneDeviationRate;
    if (rate == null) return 'N/A';
    return '${(rate * 100).toStringAsFixed(1)}%';
  }

  PerformanceLevel get inferencePerformanceLevel {
    if (avgInferenceTimeMs == null) return PerformanceLevel.unknown;
    if (avgInferenceTimeMs! <= 50) return PerformanceLevel.excellent;
    if (avgInferenceTimeMs! <= 100) return PerformanceLevel.good;
    if (avgInferenceTimeMs! <= 200) return PerformanceLevel.fair;
    return PerformanceLevel.poor;
  }

  SafetyLevel get safetyScoringLevel {
    if (laneKeepingAccuracy == null) return SafetyLevel.unknown;
    if (laneKeepingAccuracy! >= 0.95) return SafetyLevel.excellent;
    if (laneKeepingAccuracy! >= 0.85) return SafetyLevel.good;
    if (laneKeepingAccuracy! >= 0.70) return SafetyLevel.fair;
    return SafetyLevel.poor;
  }

  Map<String, dynamic> get analysisReport {
    return {
      'total_frames': totalFramesProcessed ?? 0,
      'obstacles_detected': totalObstaclesDetected ?? 0,
      'warnings_issued': totalWarningsIssued ?? 0,
      'lane_deviations': laneDeviationsCount ?? 0,
      'lane_keeping_accuracy': laneKeepingAccuracyPercentage,
      'avg_inference_time': avgInferenceTimeFormatted,
      'obstacle_detection_rate': obstacleDetectionRatePercentage,
      'warning_rate': warningRatePercentage,
      'lane_deviation_rate': laneDeviationRatePercentage,
      'performance_level': inferencePerformanceLevel.displayName,
      'safety_level': safetyScoringLevel.displayName,
    };
  }
}

class AIMetricsRequest {
  final int? totalFrames;
  final int? obstaclesDetected;
  final int? warningsIssued;
  final int? laneDeviations;
  final double? laneKeepingAccuracy;
  final double? avgInferenceMs;
  final double? maxInferenceMs;
  final double? minInferenceMs;

  AIMetricsRequest({
    this.totalFrames,
    this.obstaclesDetected,
    this.warningsIssued,
    this.laneDeviations,
    this.laneKeepingAccuracy,
    this.avgInferenceMs,
    this.maxInferenceMs,
    this.minInferenceMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'total_frames': totalFrames,
      'obstacles_detected': obstaclesDetected,
      'warnings_issued': warningsIssued,
      'lane_deviations': laneDeviations,
      'lane_keeping_accuracy': laneKeepingAccuracy,
      'avg_inference_ms': avgInferenceMs,
      'max_inference_ms': maxInferenceMs,
      'min_inference_ms': minInferenceMs,
    };
  }

  factory AIMetricsRequest.fromJson(Map<String, dynamic> json) {
    return AIMetricsRequest(
      totalFrames: json['total_frames'],
      obstaclesDetected: json['obstacles_detected'],
      warningsIssued: json['warnings_issued'],
      laneDeviations: json['lane_deviations'],
      laneKeepingAccuracy: json['lane_keeping_accuracy']?.toDouble(),
      avgInferenceMs: json['avg_inference_ms']?.toDouble(),
      maxInferenceMs: json['max_inference_ms']?.toDouble(),
      minInferenceMs: json['min_inference_ms']?.toDouble(),
    );
  }

  AIMetrics toModel(String runId) {
    return AIMetrics(
      id: '', 
      runId: runId,
      totalFramesProcessed: totalFrames,
      totalObstaclesDetected: obstaclesDetected,
      totalWarningsIssued: warningsIssued,
      laneDeviationsCount: laneDeviations,
      laneKeepingAccuracy: laneKeepingAccuracy,
      avgInferenceTimeMs: avgInferenceMs,
      maxInferenceTimeMs: maxInferenceMs,
      minInferenceTimeMs: minInferenceMs,
      createdAt: DateTime.now(),
    );
  }

  bool get isValid {
    return totalFrames != null ||
        obstaclesDetected != null ||
        warningsIssued != null ||
        laneDeviations != null ||
        laneKeepingAccuracy != null ||
        avgInferenceMs != null ||
        maxInferenceMs != null ||
        minInferenceMs != null;
  }

  String? get validationError {
    if (!isValid) {
      return 'At least one metric must be provided';
    }

    if (laneKeepingAccuracy != null &&
        (laneKeepingAccuracy! < 0 || laneKeepingAccuracy! > 1)) {
      return 'Lane keeping accuracy must be between 0 and 1';
    }

    if (totalFrames != null && totalFrames! < 0) {
      return 'Total frames cannot be negative';
    }

    if (obstaclesDetected != null && obstaclesDetected! < 0) {
      return 'Obstacles detected cannot be negative';
    }

    return null; 
  }
}

enum PerformanceLevel { unknown, excellent, good, fair, poor }

extension PerformanceLevelExtension on PerformanceLevel {
  String get displayName {
    switch (this) {
      case PerformanceLevel.unknown:
        return 'Unknown';
      case PerformanceLevel.excellent:
        return 'Excellent';
      case PerformanceLevel.good:
        return 'Good';
      case PerformanceLevel.fair:
        return 'Fair';
      case PerformanceLevel.poor:
        return 'Poor';
    }
  }

  String get description {
    switch (this) {
      case PerformanceLevel.unknown:
        return 'Performance data not available';
      case PerformanceLevel.excellent:
        return 'AI processing is very fast (≤50ms)';
      case PerformanceLevel.good:
        return 'AI processing is fast (≤100ms)';
      case PerformanceLevel.fair:
        return 'AI processing is moderate (≤200ms)';
      case PerformanceLevel.poor:
        return 'AI processing is slow (>200ms)';
    }
  }
}

enum SafetyLevel { unknown, excellent, good, fair, poor }

extension SafetyLevelExtension on SafetyLevel {
  String get displayName {
    switch (this) {
      case SafetyLevel.unknown:
        return 'Unknown';
      case SafetyLevel.excellent:
        return 'Excellent';
      case SafetyLevel.good:
        return 'Good';
      case SafetyLevel.fair:
        return 'Fair';
      case SafetyLevel.poor:
        return 'Poor';
    }
  }

  String get description {
    switch (this) {
      case SafetyLevel.unknown:
        return 'Safety data not available';
      case SafetyLevel.excellent:
        return 'Excellent lane keeping (≥95%)';
      case SafetyLevel.good:
        return 'Good lane keeping (≥85%)';
      case SafetyLevel.fair:
        return 'Fair lane keeping (≥70%)';
      case SafetyLevel.poor:
        return 'Poor lane keeping (<70%)';
    }
  }
}

class AIMetricsAnalyzer {
  static Map<String, dynamic> analyzeMetrics(AIMetrics metrics) {
    return {
      'performance_score': _calculatePerformanceScore(metrics),
      'safety_score': _calculateSafetyScore(metrics),
      'efficiency_score': _calculateEfficiencyScore(metrics),
      'overall_score': _calculateOverallScore(metrics),
      'recommendations': _generateRecommendations(metrics),
    };
  }

  static double _calculatePerformanceScore(AIMetrics metrics) {
    if (metrics.avgInferenceTimeMs == null) return 0.0;
    if (metrics.avgInferenceTimeMs! <= 50) return 100.0;
    if (metrics.avgInferenceTimeMs! <= 100) return 85.0;
    if (metrics.avgInferenceTimeMs! <= 200) return 70.0;
    return 50.0;
  }

  static double _calculateSafetyScore(AIMetrics metrics) {
    if (metrics.laneKeepingAccuracy == null) return 0.0;
    return metrics.laneKeepingAccuracy! * 100;
  }

  static double _calculateEfficiencyScore(AIMetrics metrics) {
    if (metrics.totalFramesProcessed == null ||
        metrics.totalWarningsIssued == null) {
      return 0.0;
    }

    final warningRate = metrics.warningRate ?? 0.0;
    if (warningRate >= 0.05 && warningRate <= 0.15) return 100.0;
    if (warningRate >= 0.02 && warningRate <= 0.25) return 80.0;
    return 60.0;
  }

  static double _calculateOverallScore(AIMetrics metrics) {
    final performance = _calculatePerformanceScore(metrics);
    final safety = _calculateSafetyScore(metrics);
    final efficiency = _calculateEfficiencyScore(metrics);

    return (performance + safety + efficiency) / 3;
  }

  static List<String> _generateRecommendations(AIMetrics metrics) {
    final recommendations = <String>[];

    if (metrics.avgInferenceTimeMs != null &&
        metrics.avgInferenceTimeMs! > 200) {
      recommendations.add(
        'Consider optimizing AI model for better performance',
      );
    }

    if (metrics.laneKeepingAccuracy != null &&
        metrics.laneKeepingAccuracy! < 0.85) {
      recommendations.add('Lane keeping accuracy could be improved');
    }

    final warningRate = metrics.warningRate;
    if (warningRate != null && warningRate > 0.25) {
      recommendations.add(
        'Too many warnings issued - consider tuning sensitivity',
      );
    }

    if (warningRate != null && warningRate < 0.02) {
      recommendations.add(
        'Very few warnings - consider increasing sensitivity',
      );
    }

    return recommendations;
  }
}
