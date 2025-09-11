import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../app_module/data/model/pairing_session.dart';
import '../app_module/data/model/device.dart';

class DevicePairingController extends ChangeNotifier {
  PairingSession? _currentSession;
  Device? _pairedDevice;
  bool _isLoading = false;
  String? _errorMessage;
  final CookieRequest request;
  static const String baseUrl = 'http://34.101.37.162/api/v1';

  DevicePairingController({required this.request});

  PairingSession? get currentSession => _currentSession;
  Device? get pairedDevice => _pairedDevice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPairedDevice => _pairedDevice != null;

  Future<PairingResponse?> requestPairingCode() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/pairing/request';
      print('DEBUG: Requesting pairing code from: $url');
      final response = await request.post(url, {});

      print('DEBUG: Raw response: $response');
      print('DEBUG: Response type: ${response.runtimeType}');
      print('DEBUG: Response keys: ${response.keys}');
      print('DEBUG: Response success: ${response['success']}');
      print('DEBUG: Response message: ${response['message']}');
      print('DEBUG: Response data: ${response['data']}');

      // Check if response contains pairing data - API uses "status": "success" not "success": true
      if (response['success'] == true ||
          response['status'] == 'success' ||
          (response.containsKey('code') &&
              response.containsKey('session_id'))) {
        print('DEBUG: Success response, parsing data...');

        // If data is nested under 'data' field, use that. Otherwise use response directly
        final dataToparse = response['data'] ?? response;

        // Ensure code is string for the model
        final Map<String, dynamic> normalizedData = Map<String, dynamic>.from(
          dataToparse,
        );
        if (normalizedData['code'] is int) {
          normalizedData['code'] = normalizedData['code'].toString();
        }

        final pairingResponse = PairingResponse.fromJson(normalizedData);
        print('DEBUG: Parsed pairing response: ${pairingResponse.toJson()}');

        _currentSession = PairingSession(
          id: pairingResponse.sessionId,
          userId: '',
          code: pairingResponse.code,
          status: PairingStatus.pending,
          expiresAt: pairingResponse.expiresAtDateTime,
          createdAt: DateTime.now(),
        );

        print('DEBUG: Created session: ${_currentSession?.toJson()}');
        _isLoading = false;
        notifyListeners();
        return pairingResponse;
      } else {
        print('DEBUG: Failed response');
        _errorMessage = response['message'] ?? 'Failed to request pairing code';
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      print('DEBUG: Exception occurred: $e');
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<PairingStatusResponse?> checkPairingStatus(String sessionId) async {
    try {
      final url = '$baseUrl/mobile/pairing/$sessionId/status';
      final response = await request.get(url);

      if (response['success'] == true || response['status'] == 'success') {
        final statusResponse = PairingStatusResponse.fromJson(response['data']);

        if (_currentSession != null && _currentSession!.id == sessionId) {
          if (statusResponse.paired && statusResponse.device != null) {
            _pairedDevice = Device(
              id: statusResponse.device!.deviceId,
              deviceId: statusResponse.device!.deviceId,
              userId: '',
              deviceName: statusResponse.device!.deviceName,
              deviceType: statusResponse.device!.deviceType,
              firmwareVersion: statusResponse.device!.firmwareVersion,
              isActive: true,
              pairedAt: statusResponse.device!.pairedAt,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            _currentSession = null;
          }
        }

        notifyListeners();
        return statusResponse;
      } else {
        _errorMessage = response['message'] ?? 'Failed to check pairing status';
        notifyListeners();
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return null;
    }
  }

  Future<bool> cancelPairing(String sessionId) async {
    try {
      final url = '$baseUrl/mobile/pairing/cancel/$sessionId';
      final response = await request.post(url, {});

      if (response['success'] == true || response['status'] == 'success') {
        _currentSession = null;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to cancel pairing';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<List<Device>> getConnectedDevices() async {
    try {
      final url = '$baseUrl/mobile/devices';
      final response = await request.get(url);

      if (response['success'] == true || response['status'] == 'success') {
        final List<dynamic> devicesData = response['data'] ?? [];
        final devices = devicesData
            .map((device) => Device.fromJson(device))
            .toList();

        if (devices.isNotEmpty) {
          _pairedDevice = devices.first;
        }

        notifyListeners();
        return devices;
      } else {
        _errorMessage = response['message'] ?? 'Failed to get devices';
        return [];
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return [];
    }
  }

  Future<bool> unpairDevice(String deviceId) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId';
      final response = await request.postJson(
        url,
        jsonEncode({'_method': 'DELETE'}),
      );

      if (response['success'] == true || response['status'] == 'success') {
        if (_pairedDevice?.deviceId == deviceId) {
          _pairedDevice = null;
        }
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to unpair device';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<DeviceConfig?> getDeviceConfig(String deviceId) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId/config';
      final response = await request.get(url);

      if (response['success'] == true || response['status'] == 'success') {
        return DeviceConfig.fromJson(response['data']);
      } else {
        _errorMessage = response['message'] ?? 'Failed to get device config';
        return null;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      return null;
    }
  }

  Future<bool> updateDeviceConfig(String deviceId, DeviceConfig config) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId/config';
      final response = await request.postJson(url, jsonEncode(config.toJson()));

      if (response['success'] == true || response['status'] == 'success') {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update device config';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSession() {
    _currentSession = null;
    notifyListeners();
  }
}
