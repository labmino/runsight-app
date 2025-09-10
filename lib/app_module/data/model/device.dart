import 'user.dart';
import 'run.dart';

class Device {
  final String id;
  final String deviceId;
  final String userId;
  final String? deviceName;
  final String deviceType;
  final String? firmwareVersion;
  final String? hardwareVersion;
  final String? macAddress;
  final bool isActive;
  final int? batteryLevel;
  final DateTime? lastSyncAt;
  final DateTime pairedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final List<Run>? runs;

  Device({
    required this.id,
    required this.deviceId,
    required this.userId,
    this.deviceName,
    required this.deviceType,
    this.firmwareVersion,
    this.hardwareVersion,
    this.macAddress,
    required this.isActive,
    this.batteryLevel,
    this.lastSyncAt,
    required this.pairedAt,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.runs,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      deviceId: json['device_id'],
      userId: json['user_id'],
      deviceName: json['device_name'],
      deviceType: json['device_type'],
      firmwareVersion: json['firmware_version'],
      hardwareVersion: json['hardware_version'],
      macAddress: json['mac_address'],
      isActive: json['is_active'] ?? true,
      batteryLevel: json['battery_level'],
      lastSyncAt: json['last_sync_at'] != null
          ? DateTime.parse(json['last_sync_at'])
          : null,
      pairedAt: DateTime.parse(json['paired_at']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      runs: json['runs'] != null
          ? (json['runs'] as List).map((e) => Run.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_id': deviceId,
      'user_id': userId,
      'device_name': deviceName,
      'device_type': deviceType,
      'firmware_version': firmwareVersion,
      'hardware_version': hardwareVersion,
      'mac_address': macAddress,
      'is_active': isActive,
      'battery_level': batteryLevel,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'paired_at': pairedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'runs': runs?.map((e) => e.toJson()).toList(),
    };
  }

  String get displayName => deviceName ?? deviceId;

  String get statusText => isActive ? 'Active' : 'Inactive';

  BatteryStatus get batteryStatus {
    if (batteryLevel == null) return BatteryStatus.unknown;
    if (batteryLevel! <= 20) return BatteryStatus.low;
    if (batteryLevel! <= 50) return BatteryStatus.medium;
    return BatteryStatus.high;
  }

  String get batteryDisplayText {
    if (batteryLevel == null) return 'Unknown';
    return '$batteryLevel%';
  }

  String get formattedPairedAt {
    return '${pairedAt.day}/${pairedAt.month}/${pairedAt.year}';
  }

  String get formattedLastSync {
    if (lastSyncAt == null) return 'Never';
    final now = DateTime.now();
    final difference = now.difference(lastSyncAt!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  bool get isOnline {
    if (lastSyncAt == null) return false;
    final difference = DateTime.now().difference(lastSyncAt!);
    return difference.inMinutes <=
        5; 
  }

  ConnectionStatus get connectionStatus {
    if (!isActive) return ConnectionStatus.offline;
    if (isOnline) return ConnectionStatus.online;
    return ConnectionStatus.disconnected;
  }
}

class DeviceRegisterRequest {
  final String code;
  final String deviceId;
  final String deviceType;
  final String? firmwareVersion;
  final String? hardwareVersion;
  final String? macAddress;

  DeviceRegisterRequest({
    required this.code,
    required this.deviceId,
    required this.deviceType,
    this.firmwareVersion,
    this.hardwareVersion,
    this.macAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'device_id': deviceId,
      'device_type': deviceType,
      'firmware_version': firmwareVersion,
      'hardware_version': hardwareVersion,
      'mac_address': macAddress,
    };
  }

  factory DeviceRegisterRequest.fromJson(Map<String, dynamic> json) {
    return DeviceRegisterRequest(
      code: json['code'],
      deviceId: json['device_id'],
      deviceType: json['device_type'],
      firmwareVersion: json['firmware_version'],
      hardwareVersion: json['hardware_version'],
      macAddress: json['mac_address'],
    );
  }
}

class DeviceStatusRequest {
  final String deviceId;
  final int? batteryLevel;
  final int? storageAvailableMB;
  final String? firmwareVersion;
  final int? errorCount;
  final DateTime? lastRunAt;

  DeviceStatusRequest({
    required this.deviceId,
    this.batteryLevel,
    this.storageAvailableMB,
    this.firmwareVersion,
    this.errorCount,
    this.lastRunAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'battery_level': batteryLevel,
      'storage_available_mb': storageAvailableMB,
      'firmware_version': firmwareVersion,
      'error_count': errorCount,
      'last_run_at': lastRunAt?.toIso8601String(),
    };
  }

  factory DeviceStatusRequest.fromJson(Map<String, dynamic> json) {
    return DeviceStatusRequest(
      deviceId: json['device_id'],
      batteryLevel: json['battery_level'],
      storageAvailableMB: json['storage_available_mb'],
      firmwareVersion: json['firmware_version'],
      errorCount: json['error_count'],
      lastRunAt: json['last_run_at'] != null
          ? DateTime.parse(json['last_run_at'])
          : null,
    );
  }
}

class DeviceConfig {
  final int uploadIntervalSeconds;
  final int batchSize;
  final bool compressionEnabled;

  DeviceConfig({
    required this.uploadIntervalSeconds,
    required this.batchSize,
    required this.compressionEnabled,
  });

  factory DeviceConfig.fromJson(Map<String, dynamic> json) {
    return DeviceConfig(
      uploadIntervalSeconds: json['upload_interval_seconds'],
      batchSize: json['batch_size'],
      compressionEnabled: json['compression_enabled'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'upload_interval_seconds': uploadIntervalSeconds,
      'batch_size': batchSize,
      'compression_enabled': compressionEnabled,
    };
  }

  String get uploadIntervalText {
    if (uploadIntervalSeconds < 60) {
      return '${uploadIntervalSeconds}s';
    } else if (uploadIntervalSeconds < 3600) {
      return '${uploadIntervalSeconds ~/ 60}m';
    } else {
      return '${uploadIntervalSeconds ~/ 3600}h';
    }
  }

  static DeviceConfig get defaultConfig {
    return DeviceConfig(
      uploadIntervalSeconds: 30,
      batchSize: 100,
      compressionEnabled: true,
    );
  }
}

enum BatteryStatus { unknown, low, medium, high }

extension BatteryStatusExtension on BatteryStatus {
  String get displayName {
    switch (this) {
      case BatteryStatus.unknown:
        return 'Unknown';
      case BatteryStatus.low:
        return 'Low';
      case BatteryStatus.medium:
        return 'Medium';
      case BatteryStatus.high:
        return 'High';
    }
  }

  String get iconName {
    switch (this) {
      case BatteryStatus.unknown:
        return 'battery_unknown';
      case BatteryStatus.low:
        return 'battery_alert';
      case BatteryStatus.medium:
        return 'battery_std';
      case BatteryStatus.high:
        return 'battery_full';
    }
  }
}

enum ConnectionStatus { online, offline, disconnected }

extension ConnectionStatusExtension on ConnectionStatus {
  String get displayName {
    switch (this) {
      case ConnectionStatus.online:
        return 'Online';
      case ConnectionStatus.offline:
        return 'Offline';
      case ConnectionStatus.disconnected:
        return 'Disconnected';
    }
  }

  String get iconName {
    switch (this) {
      case ConnectionStatus.online:
        return 'wifi';
      case ConnectionStatus.offline:
        return 'wifi_off';
      case ConnectionStatus.disconnected:
        return 'signal_wifi_off';
    }
  }
}

enum DeviceType { smartwatch, fitnessTracker, smartphone, other }

extension DeviceTypeExtension on DeviceType {
  String get value {
    switch (this) {
      case DeviceType.smartwatch:
        return 'smartwatch';
      case DeviceType.fitnessTracker:
        return 'fitness_tracker';
      case DeviceType.smartphone:
        return 'smartphone';
      case DeviceType.other:
        return 'other';
    }
  }

  static DeviceType fromString(String type) {
    switch (type.toLowerCase()) {
      case 'smartwatch':
        return DeviceType.smartwatch;
      case 'fitness_tracker':
        return DeviceType.fitnessTracker;
      case 'smartphone':
        return DeviceType.smartphone;
      default:
        return DeviceType.other;
    }
  }

  String get displayName {
    switch (this) {
      case DeviceType.smartwatch:
        return 'Smart Watch';
      case DeviceType.fitnessTracker:
        return 'Fitness Tracker';
      case DeviceType.smartphone:
        return 'Smartphone';
      case DeviceType.other:
        return 'Other Device';
    }
  }

  String get iconName {
    switch (this) {
      case DeviceType.smartwatch:
        return 'watch';
      case DeviceType.fitnessTracker:
        return 'fitness_center';
      case DeviceType.smartphone:
        return 'phone_android';
      case DeviceType.other:
        return 'devices_other';
    }
  }
}
