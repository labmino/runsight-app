import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../app_module/data/model/run.dart';
import '../app_module/data/model/ai_metrics.dart';

class RunController extends ChangeNotifier {
  List<Run> _runs = [];
  Run? _currentRun;
  bool _isLoading = false;
  String? _errorMessage;
  final CookieRequest request;
  static const String baseUrl = 'http://34.101.37.162/api/v1';

  RunController({required this.request});

  List<Run> get runs => _runs;
  Run? get currentRun => _currentRun;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasActiveRun => _currentRun != null && _currentRun!.endedAt == null;

  Future<void> fetchRuns({
    int page = 1,
    int limit = 10,
    String? startDate,
    String? endDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      var url = '$baseUrl/mobile/runs?page=$page&limit=$limit';
      if (startDate != null) url += '&start_date=$startDate';
      if (endDate != null) url += '&end_date=$endDate';

      final response = await request.get(url);

      // Debug: Print response to understand its structure
      print('RunController - Response type: ${response.runtimeType}');
      print('RunController - Response: $response');

      // Handle different response formats
      List<dynamic> runsData = [];

      if (response is Map<String, dynamic>) {
        if (response['success'] == true) {
          // Handle data that could be either a List or a pagination object
          final dynamic data = response['data'];

          if (data is Map<String, dynamic> && data.containsKey('runs')) {
            // Paginated response
            runsData = data['runs'] ?? [];
          } else if (data is List) {
            runsData = data;
          } else if (data is Map<String, dynamic>) {
            // If data is a single object, wrap it in a list
            runsData = [data];
          }
          // If data is null, runsData remains empty list
        } else if (response['success'] == false) {
          // Server returned an error status
          if (response['message']?.toString().toLowerCase().contains(
                    'not found',
                  ) ==
                  true ||
              response['message']?.toString().toLowerCase().contains(
                    'no runs',
                  ) ==
                  true) {
            // Treat "not found" as empty data, not an error
            runsData = [];
          } else {
            _errorMessage = response['message'] ?? 'Failed to fetch runs';
            _isLoading = false;
            notifyListeners();
            return;
          }
        }
      } else if (response is List) {
        // Handle direct list response
        runsData = response;
      }
      // If response is neither Map nor List, runsData remains empty

      // Convert to Run objects
      _runs = runsData
          .map((runData) {
            try {
              return Run.fromJson(runData);
            } catch (e) {
              print('Error parsing run data: $e');
              print('Run data: $runData');
              return null;
            }
          })
          .where((run) => run != null)
          .cast<Run>()
          .toList();

      _runs.sort((a, b) => b.startedAt.compareTo(a.startedAt));
      _currentRun = _runs.isNotEmpty && _runs.first.endedAt == null
          ? _runs.first
          : null;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('Unexpected character') ||
          e.toString().contains('is not a subtype of type')) {
        _runs = [];
        _currentRun = null;
        _errorMessage = null;
      } else {
        _errorMessage = 'Network error: ${e.toString()}';
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Run?> startRun(RunCreateRequest runRequest) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/runs';
      final response = await request.postJson(
        url,
        jsonEncode(runRequest.toJson()),
      );

      if (response['success'] == true) {
        final newRun = Run.fromJson(response['data']);
        _currentRun = newRun;
        _runs.insert(0, newRun);

        _isLoading = false;
        notifyListeners();
        return newRun;
      } else {
        _errorMessage = response['message'] ?? 'Failed to start run';
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

  Future<Run?> endRun(String runId, RunUpdateRequest? updateData) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/runs/$runId/end';
      final data = updateData?.toJson() ?? {};
      data['ended_at'] = DateTime.now().toIso8601String();

      final response = await request.postJson(url, jsonEncode(data));

      if (response['success'] == true) {
        final updatedRun = Run.fromJson(response['data']);
        if (_currentRun?.id == runId) {
          _currentRun = updatedRun;
        }
        final index = _runs.indexWhere((run) => run.id == runId);
        if (index != -1) {
          _runs[index] = updatedRun;
        }

        _isLoading = false;
        notifyListeners();
        return updatedRun;
      } else {
        _errorMessage = response['message'] ?? 'Failed to end run';
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

  Future<Run?> updateRun(String runId, RunUpdateRequest updateRequest) async {
    try {
      final url = '$baseUrl/mobile/runs/$runId';
      final data = updateRequest.toJson();
      data['_method'] = 'PATCH';
      final response = await request.postJson(url, jsonEncode(data));

      if (response['success'] == true) {
        final updatedRun = Run.fromJson(response['data']);
        if (_currentRun?.id == runId) {
          _currentRun = updatedRun;
        }
        final index = _runs.indexWhere((run) => run.id == runId);
        if (index != -1) {
          _runs[index] = updatedRun;
        }

        notifyListeners();
        return updatedRun;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update run';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<bool> deleteRun(String runId) async {
    try {
      final url = '$baseUrl/mobile/runs/$runId';
      final response = await request.postJson(
        url,
        jsonEncode({'_method': 'DELETE'}),
      );

      if (response['success'] == true) {
        if (_currentRun?.id == runId) {
          _currentRun = null;
        }
        _runs.removeWhere((run) => run.id == runId);

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to delete run';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<Run?> getRunDetails(String runId) async {
    try {
      final url = '$baseUrl/mobile/runs/$runId';
      final response = await request.get(url);

      if (response['success'] == true) {
        return Run.fromJson(response['data']);
      } else {
        _errorMessage = response['message'] ?? 'Failed to get run details';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return null;
    }
  }

  // Add statistics endpoint
  Future<Map<String, dynamic>?> getUserStatistics() async {
    try {
      final url = '$baseUrl/mobile/stats';
      final response = await request.get(url);

      if (response['success'] == true) {
        return response['data'];
      } else {
        _errorMessage = response['message'] ?? 'Failed to get statistics';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return null;
    }
  }

  Future<AIMetrics?> submitAIMetrics(
    String runId,
    AIMetricsRequest metricsRequest,
  ) async {
    try {
      final url = '$baseUrl/mobile/runs/$runId/ai-metrics';
      final response = await request.postJson(
        url,
        jsonEncode(metricsRequest.toJson()),
      );

      if (response['success'] == true) {
        final aiMetrics = AIMetrics.fromJson(response['data']);
        notifyListeners();
        return aiMetrics;
      } else {
        _errorMessage = response['message'] ?? 'Failed to submit AI metrics';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<AIMetrics?> getAIMetrics(String runId) async {
    try {
      final url = '$baseUrl/mobile/runs/$runId/ai-metrics';
      final response = await request.get(url);

      if (response['success'] == true) {
        return AIMetrics.fromJson(response['data']);
      } else {
        _errorMessage = response['message'] ?? 'Failed to get AI metrics';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return null;
    }
  }

  Map<String, dynamic> getRunStatistics() {
    if (_runs.isEmpty) {
      return {
        'total_runs': 0,
        'total_distance': 0.0,
        'total_duration': 0,
        'avg_speed': 0.0,
        'total_calories': 0,
      };
    }

    final completedRuns = _runs.where((run) => run.endedAt != null).toList();

    final totalDistance = completedRuns.fold<double>(
      0.0,
      (sum, run) => sum + (run.distanceMeters ?? 0.0),
    );

    final totalDuration = completedRuns.fold<int>(
      0,
      (sum, run) => sum + (run.durationSeconds ?? 0),
    );

    final totalCalories = completedRuns.fold<int>(
      0,
      (sum, run) => sum + (run.caloriesBurned ?? 0),
    );

    final avgSpeed = completedRuns.isNotEmpty
        ? completedRuns.fold<double>(
                0.0,
                (sum, run) => sum + (run.avgSpeedKmh ?? 0.0),
              ) /
              completedRuns.length
        : 0.0;

    return {
      'total_runs': completedRuns.length,
      'total_distance': totalDistance,
      'total_duration': totalDuration,
      'avg_speed': avgSpeed,
      'total_calories': totalCalories,
      'formatted_distance': '${(totalDistance / 1000).toStringAsFixed(2)} km',
      'formatted_duration': _formatDuration(totalDuration),
      'formatted_avg_speed': '${avgSpeed.toStringAsFixed(1)} km/h',
    };
  }

  List<Run> getRecentRuns({int limit = 10}) {
    return _runs.take(limit).toList();
  }

  List<Run> getRunsThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _runs.where((run) => run.startedAt.isAfter(weekStart)).toList();
  }

  List<Run> getRunsThisMonth() {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    return _runs.where((run) => run.startedAt.isAfter(monthStart)).toList();
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m ${secs}s';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearCurrentRun() {
    _currentRun = null;
    notifyListeners();
  }
}
