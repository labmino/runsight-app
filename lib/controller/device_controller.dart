import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../app_module/data/model/device.dart';

class DeviceController extends ChangeNotifier {
  List<Device> _devices = [];
  Device? _selectedDevice;
  bool _isLoading = false;
  String? _errorMessage;
  final CookieRequest request;
  static const String baseUrl = 'http://34.101.37.162/api/v1';

  DeviceController({required this.request});

  List<Device> get devices => _devices;
  Device? get selectedDevice => _selectedDevice;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasDevices => _devices.isNotEmpty;
  List<Device> get activeDevices =>
      _devices.where((device) => device.isActive).toList();
  List<Device> get onlineDevices =>
      _devices.where((device) => device.isOnline).toList();

  Future<void> fetchDevices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/devices';
      final response = await request.get(url);

      if (response['success'] == true) {
        final List<dynamic> devicesData = response['data'] ?? [];
        _devices = devicesData
            .map((device) => Device.fromJson(device))
            .toList();
        _devices.sort((a, b) => b.pairedAt.compareTo(a.pairedAt));
        if (_selectedDevice == null && _devices.isNotEmpty) {
          _selectedDevice = _devices.firstWhere(
            (device) => device.isActive,
            orElse: () => _devices.first,
          );
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Failed to fetch devices';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Device?> registerDevice(DeviceRegisterRequest registerRequest) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final url = '$baseUrl/mobile/devices/register';
      final response = await request.postJson(
        url,
        jsonEncode(registerRequest.toJson()),
      );

      if (response['success'] == true) {
        final newDevice = Device.fromJson(response['data']);
        _devices.insert(0, newDevice);
        _selectedDevice = newDevice;

        _isLoading = false;
        notifyListeners();
        return newDevice;
      } else {
        _errorMessage = response['message'] ?? 'Failed to register device';
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

  Future<bool> updateDeviceStatus(
    String deviceId,
    DeviceStatusRequest statusRequest,
  ) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId/status';
      final response = await request.postJson(
        url,
        jsonEncode(statusRequest.toJson()),
      );

      if (response['success'] == true) {
        final index = _devices.indexWhere(
          (device) => device.deviceId == deviceId,
        );
        if (index != -1) {
          final updatedDevice = Device.fromJson(response['data']);
          _devices[index] = updatedDevice;
          if (_selectedDevice?.deviceId == deviceId) {
            _selectedDevice = updatedDevice;
          }
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to update device status';
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

      if (response['success'] == true) {
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

      if (response['success'] == true) {
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

  Future<bool> syncDevice(String deviceId) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId/sync';
      final response = await request.post(url, {});

      if (response['success'] == true) {
        final index = _devices.indexWhere(
          (device) => device.deviceId == deviceId,
        );
        if (index != -1) {
          final updatedDevice = Device.fromJson(response['data']);
          _devices[index] = updatedDevice;
          if (_selectedDevice?.deviceId == deviceId) {
            _selectedDevice = updatedDevice;
          }
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to sync device';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeDevice(String deviceId) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId';
      final response = await request.postJson(
        url,
        jsonEncode({'_method': 'DELETE'}),
      );

      if (response['success'] == true) {
        _devices.removeWhere((device) => device.deviceId == deviceId);
        if (_selectedDevice?.deviceId == deviceId) {
          _selectedDevice = _devices.isNotEmpty ? _devices.first : null;
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to remove device';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleDeviceStatus(String deviceId, bool isActive) async {
    try {
      final url = '$baseUrl/mobile/devices/$deviceId/toggle';
      final data = {'is_active': isActive};
      final response = await request.postJson(url, jsonEncode(data));

      if (response['success'] == true) {
        final index = _devices.indexWhere(
          (device) => device.deviceId == deviceId,
        );
        if (index != -1) {
          final updatedDevice = Device.fromJson(response['data']);
          _devices[index] = updatedDevice;
          if (_selectedDevice?.deviceId == deviceId) {
            _selectedDevice = updatedDevice;
          }
        }

        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to toggle device status';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Network error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void setSelectedDevice(Device device) {
    _selectedDevice = device;
    notifyListeners();
  }

  void clearSelectedDevice() {
    _selectedDevice = null;
    notifyListeners();
  }

  Map<String, dynamic> getDeviceStatistics() {
    return {
      'total_devices': _devices.length,
      'active_devices': activeDevices.length,
      'online_devices': onlineDevices.length,
      'offline_devices': _devices.length - onlineDevices.length,
      'device_types': _getDeviceTypeDistribution(),
      'battery_levels': _getBatteryLevels(),
    };
  }

  Map<String, int> _getDeviceTypeDistribution() {
    final distribution = <String, int>{};
    for (final device in _devices) {
      distribution[device.deviceType] =
          (distribution[device.deviceType] ?? 0) + 1;
    }
    return distribution;
  }

  List<Map<String, dynamic>> _getBatteryLevels() {
    return _devices
        .where((device) => device.batteryLevel != null)
        .map(
          (device) => {
            'device_id': device.deviceId,
            'device_name': device.displayName,
            'battery_level': device.batteryLevel,
            'battery_status': device.batteryStatus.displayName,
          },
        )
        .toList();
  }

  List<Device> getDevicesByType(String deviceType) {
    return _devices.where((device) => device.deviceType == deviceType).toList();
  }

  List<Device> getLowBatteryDevices({int threshold = 20}) {
    return _devices
        .where(
          (device) =>
              device.batteryLevel != null && device.batteryLevel! <= threshold,
        )
        .toList();
  }

  Device? getDeviceById(String deviceId) {
    try {
      return _devices.firstWhere((device) => device.deviceId == deviceId);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void refresh() {
    fetchDevices();
  }
}
