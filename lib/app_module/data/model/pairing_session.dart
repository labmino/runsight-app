import 'user.dart';

class PairingSession {
  final String id;
  final String userId;
  final String code;
  final String? deviceId;
  final PairingStatus status;
  final DateTime expiresAt;
  final DateTime? pairedAt;
  final DateTime createdAt;
  final User? user;

  PairingSession({
    required this.id,
    required this.userId,
    required this.code,
    this.deviceId,
    required this.status,
    required this.expiresAt,
    this.pairedAt,
    required this.createdAt,
    this.user,
  });

  factory PairingSession.fromJson(Map<String, dynamic> json) {
    return PairingSession(
      id: json['id'],
      userId: json['user_id'],
      code: json['code'],
      deviceId: json['device_id'],
      status: PairingStatusExtension.fromString(json['status']),
      expiresAt: DateTime.parse(json['expires_at']),
      pairedAt: json['paired_at'] != null
          ? DateTime.parse(json['paired_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'code': code,
      'device_id': deviceId,
      'status': status.value,
      'expires_at': expiresAt.toIso8601String(),
      'paired_at': pairedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  int get remainingSeconds {
    final remaining = expiresAt.difference(DateTime.now()).inSeconds;
    return remaining < 0 ? 0 : remaining;
  }

  Duration get remainingTime {
    final remaining = expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get formattedRemainingTime {
    final remaining = remainingTime;
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isPaired => status == PairingStatus.paired;
  bool get isPending => status == PairingStatus.pending;
}

class PairingRequest {
  PairingRequest();

  Map<String, dynamic> toJson() {
    return {};
  }

  factory PairingRequest.fromJson(Map<String, dynamic> json) {
    return PairingRequest();
  }
}

class PairingResponse {
  final String code;
  final String sessionId;
  final String expiresAt;
  final int expiresInSeconds;

  PairingResponse({
    required this.code,
    required this.sessionId,
    required this.expiresAt,
    required this.expiresInSeconds,
  });

  factory PairingResponse.fromJson(Map<String, dynamic> json) {
    return PairingResponse(
      code: json['code'],
      sessionId: json['session_id'],
      expiresAt: json['expires_at'],
      expiresInSeconds: json['expires_in_seconds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'session_id': sessionId,
      'expires_at': expiresAt,
      'expires_in_seconds': expiresInSeconds,
    };
  }

  DateTime get expiresAtDateTime => DateTime.parse(expiresAt);

  String get formattedCode {
    if (code.length == 6) {
      return '${code.substring(0, 3)} ${code.substring(3)}';
    }
    return code;
  }
}

class PairingStatusResponse {
  final bool paired;
  final bool expired;
  final int? remainingSeconds;
  final PairingDeviceInfo? device;

  PairingStatusResponse({
    required this.paired,
    required this.expired,
    this.remainingSeconds,
    this.device,
  });

  factory PairingStatusResponse.fromJson(Map<String, dynamic> json) {
    return PairingStatusResponse(
      paired: json['paired'],
      expired: json['expired'],
      remainingSeconds: json['remaining_seconds'],
      device: json['device'] != null
          ? PairingDeviceInfo.fromJson(json['device'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paired': paired,
      'expired': expired,
      'remaining_seconds': remainingSeconds,
      'device': device?.toJson(),
    };
  }

  String get statusText {
    if (expired) return 'Expired';
    if (paired) return 'Paired';
    return 'Pending';
  }

  String get formattedRemainingTime {
    if (remainingSeconds == null || remainingSeconds! <= 0) {
      return '00:00';
    }
    final minutes = remainingSeconds! ~/ 60;
    final seconds = remainingSeconds! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class PairingDeviceInfo {
  final String deviceId;
  final String deviceName;
  final String deviceType;
  final String firmwareVersion;
  final DateTime pairedAt;

  PairingDeviceInfo({
    required this.deviceId,
    required this.deviceName,
    required this.deviceType,
    required this.firmwareVersion,
    required this.pairedAt,
  });

  factory PairingDeviceInfo.fromJson(Map<String, dynamic> json) {
    return PairingDeviceInfo(
      deviceId: json['device_id'],
      deviceName: json['device_name'],
      deviceType: json['device_type'],
      firmwareVersion: json['firmware_version'],
      pairedAt: DateTime.parse(json['paired_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'device_name': deviceName,
      'device_type': deviceType,
      'firmware_version': firmwareVersion,
      'paired_at': pairedAt.toIso8601String(),
    };
  }

  String get displayName {
    return '$deviceName ($deviceType)';
  }

  String get formattedPairedAt {
    return '${pairedAt.day}/${pairedAt.month}/${pairedAt.year} ${pairedAt.hour}:${pairedAt.minute.toString().padLeft(2, '0')}';
  }
}

enum PairingStatus { pending, paired, expired }

extension PairingStatusExtension on PairingStatus {
  String get value {
    switch (this) {
      case PairingStatus.pending:
        return 'pending';
      case PairingStatus.paired:
        return 'paired';
      case PairingStatus.expired:
        return 'expired';
    }
  }

  static PairingStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return PairingStatus.pending;
      case 'paired':
        return PairingStatus.paired;
      case 'expired':
        return PairingStatus.expired;
      default:
        return PairingStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case PairingStatus.pending:
        return 'Pending';
      case PairingStatus.paired:
        return 'Paired';
      case PairingStatus.expired:
        return 'Expired';
    }
  }
}

class PairingConstants {
  static const Duration pairingCodeTTL = Duration(minutes: 5);
  static const String pairingStatusPending = 'pending';
  static const String pairingStatusPaired = 'paired';
  static const String pairingStatusExpired = 'expired';
  static String generateSessionIdPrefix() => 'pair_';
}
