import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../app_module/data/model/ai_metrics.dart';

class AIMetricsController extends ChangeNotifier {
  List<AIMetrics> _aiMetrics = [];
  AIMetrics? _currentMetrics;
  bool _isLoading = false;
  String? _errorMessage;
  final CookieRequest request;
  static const String baseUrl = 'http://34.101.37.162/api/v1';

  AIMetricsController({required this.request});

  List<AIMetrics> get aiMetrics => _aiMetrics;
  AIMetrics? get currentMetrics => _currentMetrics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAIMetrics({String? runId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      String url;
      if (runId != null) {
        url = '$baseUrl/mobile/runs/$runId/ai-metrics';
      } else {
        url = '$baseUrl/mobile/ai-metrics';
      }

      final response = await request.get(url);

      if (response['success'] == true) {
        if (runId != null) {
          // Single AI metrics for specific run
          _currentMetrics = AIMetrics.fromJson(response['data']);
        } else {
          // List of AI metrics
          final List<dynamic> metricsData = response['data'] ?? [];
          _aiMetrics = metricsData
              .map((metrics) => AIMetrics.fromJson(metrics))
              .toList();

          // Sort by creation date (newest first)
          _aiMetrics.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch AI metrics';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AIMetrics?> submitAIMetrics(
    String runId,
    AIMetricsRequest metricsRequest,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/runs/$runId/ai-metrics';
      final response = await request.postJson(
        url,
        jsonEncode(metricsRequest.toJson()),
      );

      if (response['success'] == true) {
        final newMetrics = AIMetrics.fromJson(response['data']);
        _currentMetrics = newMetrics;
        _aiMetrics.insert(0, newMetrics); // Add to beginning of list

        _isLoading = false;
        notifyListeners();
        return newMetrics;
      } else {
        _errorMessage = response['message'] ?? 'Failed to submit AI metrics';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<AIMetrics?> updateAIMetrics(
    String metricsId,
    AIMetricsRequest updateRequest,
  ) async {
    try {
      final url = '$baseUrl/mobile/ai-metrics/$metricsId';
      final response = await request.postJson(
        url,
        jsonEncode(updateRequest.toJson()),
      );

      if (response['success'] == true) {
        final updatedMetrics = AIMetrics.fromJson(response['data']);

        // Update current metrics
        if (_currentMetrics?.id == metricsId) {
          _currentMetrics = updatedMetrics;
        }

        // Update in metrics list
        final index = _aiMetrics.indexWhere(
          (metrics) => metrics.id == metricsId,
        );
        if (index != -1) {
          _aiMetrics[index] = updatedMetrics;
        }

        notifyListeners();
        return updatedMetrics;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update AI metrics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteAIMetrics(String metricsId) async {
    try {
      final url = '$baseUrl/mobile/ai-metrics/$metricsId';
      final response = await request.postJson(
        url,
        jsonEncode({'_method': 'DELETE'}),
      );

      if (response['success'] == true) {
        // Remove from current metrics if it's the same
        if (_currentMetrics?.id == metricsId) {
          _currentMetrics = null;
        }

        // Remove from metrics list
        _aiMetrics.removeWhere((metrics) => metrics.id == metricsId);

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete AI metrics';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Analysis methods
  Map<String, dynamic> analyzeAIMetrics(AIMetrics metrics) {
    return AIMetricsAnalyzer.analyzeMetrics(metrics);
  }

  Map<String, dynamic> getOverallPerformanceStats() {
    if (_aiMetrics.isEmpty) {
      return {
        'total_metrics': 0,
        'avg_performance_score': 0.0,
        'avg_safety_score': 0.0,
        'avg_efficiency_score': 0.0,
        'overall_score': 0.0,
      };
    }

    double totalPerformance = 0.0;
    double totalSafety = 0.0;
    double totalEfficiency = 0.0;
    int validMetrics = 0;

    for (final metrics in _aiMetrics) {
      final analysis = AIMetricsAnalyzer.analyzeMetrics(metrics);
      totalPerformance += analysis['performance_score'] ?? 0.0;
      totalSafety += analysis['safety_score'] ?? 0.0;
      totalEfficiency += analysis['efficiency_score'] ?? 0.0;
      validMetrics++;
    }

    final avgPerformance = validMetrics > 0
        ? totalPerformance / validMetrics
        : 0.0;
    final avgSafety = validMetrics > 0 ? totalSafety / validMetrics : 0.0;
    final avgEfficiency = validMetrics > 0
        ? totalEfficiency / validMetrics
        : 0.0;
    final overallScore = (avgPerformance + avgSafety + avgEfficiency) / 3;

    return {
      'total_metrics': _aiMetrics.length,
      'avg_performance_score': avgPerformance,
      'avg_safety_score': avgSafety,
      'avg_efficiency_score': avgEfficiency,
      'overall_score': overallScore,
      'performance_trend': _calculateTrend('performance'),
      'safety_trend': _calculateTrend('safety'),
      'efficiency_trend': _calculateTrend('efficiency'),
    };
  }

  Map<String, dynamic> getInferencePerformanceStats() {
    if (_aiMetrics.isEmpty) return {};

    final validMetrics = _aiMetrics
        .where((m) => m.avgInferenceTimeMs != null)
        .toList();
    if (validMetrics.isEmpty) return {};

    final inferenceTimes = validMetrics
        .map((m) => m.avgInferenceTimeMs!)
        .toList();
    inferenceTimes.sort();

    return {
      'avg_inference_time':
          inferenceTimes.reduce((a, b) => a + b) / inferenceTimes.length,
      'min_inference_time': inferenceTimes.first,
      'max_inference_time': inferenceTimes.last,
      'median_inference_time': inferenceTimes[inferenceTimes.length ~/ 2],
      'excellent_count': validMetrics
          .where(
            (m) => m.inferencePerformanceLevel == PerformanceLevel.excellent,
          )
          .length,
      'good_count': validMetrics
          .where((m) => m.inferencePerformanceLevel == PerformanceLevel.good)
          .length,
      'fair_count': validMetrics
          .where((m) => m.inferencePerformanceLevel == PerformanceLevel.fair)
          .length,
      'poor_count': validMetrics
          .where((m) => m.inferencePerformanceLevel == PerformanceLevel.poor)
          .length,
    };
  }

  Map<String, dynamic> getSafetyAnalysis() {
    if (_aiMetrics.isEmpty) return {};

    final validMetrics = _aiMetrics
        .where((m) => m.laneKeepingAccuracy != null)
        .toList();
    if (validMetrics.isEmpty) return {};

    final accuracies = validMetrics.map((m) => m.laneKeepingAccuracy!).toList();
    accuracies.sort();

    return {
      'avg_lane_accuracy':
          accuracies.reduce((a, b) => a + b) / accuracies.length,
      'min_lane_accuracy': accuracies.first,
      'max_lane_accuracy': accuracies.last,
      'median_lane_accuracy': accuracies[accuracies.length ~/ 2],
      'excellent_safety_count': validMetrics
          .where((m) => m.safetyScoringLevel == SafetyLevel.excellent)
          .length,
      'good_safety_count': validMetrics
          .where((m) => m.safetyScoringLevel == SafetyLevel.good)
          .length,
      'fair_safety_count': validMetrics
          .where((m) => m.safetyScoringLevel == SafetyLevel.fair)
          .length,
      'poor_safety_count': validMetrics
          .where((m) => m.safetyScoringLevel == SafetyLevel.poor)
          .length,
    };
  }

  List<Map<String, dynamic>> getTopRecommendations({int limit = 10}) {
    final recommendations = <Map<String, dynamic>>[];

    for (final metrics in _aiMetrics.take(limit)) {
      final analysis = AIMetricsAnalyzer.analyzeMetrics(metrics);
      final metricRecommendations = analysis['recommendations'] as List<String>;

      for (final recommendation in metricRecommendations) {
        recommendations.add({
          'recommendation': recommendation,
          'run_id': metrics.runId,
          'created_at': metrics.createdAt,
          'priority': _calculateRecommendationPriority(recommendation, metrics),
        });
      }
    }

    // Sort by priority and return unique recommendations
    recommendations.sort((a, b) => b['priority'].compareTo(a['priority']));
    return recommendations.take(limit).toList();
  }

  String _calculateTrend(String type) {
    if (_aiMetrics.length < 2) return 'insufficient_data';

    final recentMetrics = _aiMetrics.take(5).toList();
    final olderMetrics = _aiMetrics.skip(5).take(5).toList();

    if (olderMetrics.isEmpty) return 'insufficient_data';

    double recentAvg = 0.0;
    double olderAvg = 0.0;

    for (final metrics in recentMetrics) {
      final analysis = AIMetricsAnalyzer.analyzeMetrics(metrics);
      recentAvg += analysis['${type}_score'] ?? 0.0;
    }
    recentAvg /= recentMetrics.length;

    for (final metrics in olderMetrics) {
      final analysis = AIMetricsAnalyzer.analyzeMetrics(metrics);
      olderAvg += analysis['${type}_score'] ?? 0.0;
    }
    olderAvg /= olderMetrics.length;

    final difference = recentAvg - olderAvg;
    if (difference > 5) return 'improving';
    if (difference < -5) return 'declining';
    return 'stable';
  }

  int _calculateRecommendationPriority(
    String recommendation,
    AIMetrics metrics,
  ) {
    int priority = 1;

    // Higher priority for performance issues
    if (recommendation.contains('performance') ||
        recommendation.contains('optimization')) {
      priority += 3;
    }

    // Higher priority for safety issues
    if (recommendation.contains('safety') ||
        recommendation.contains('accuracy')) {
      priority += 5;
    }

    // Recent metrics get higher priority
    final daysSinceCreated = DateTime.now()
        .difference(metrics.createdAt)
        .inDays;
    if (daysSinceCreated <= 7) priority += 2;
    if (daysSinceCreated <= 1) priority += 3;

    return priority;
  }

  List<AIMetrics> getMetricsForRun(String runId) {
    return _aiMetrics.where((metrics) => metrics.runId == runId).toList();
  }

  List<AIMetrics> getRecentMetrics({int limit = 10}) {
    return _aiMetrics.take(limit).toList();
  }

  List<AIMetrics> getMetricsThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _aiMetrics
        .where((metrics) => metrics.createdAt.isAfter(weekStart))
        .toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCurrentMetrics() {
    _currentMetrics = null;
    notifyListeners();
  }

  void refresh() {
    fetchAIMetrics();
  }
}
