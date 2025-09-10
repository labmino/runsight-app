import 'run.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Run>? runs;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.runs,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      runs: json['runs'] != null
          ? (json['runs'] as List).map((e) => Run.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'runs': runs?.map((e) => e.toJson()).toList(),
    };
  }
}

class UserRegisterRequest {
  final String fullName;
  final String email;
  final String? phone;
  final String password;
  final String confirmPassword;

  UserRegisterRequest({
    required this.fullName,
    required this.email,
    this.phone,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }

  factory UserRegisterRequest.fromJson(Map<String, dynamic> json) {
    return UserRegisterRequest(
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      confirmPassword: json['confirm_password'],
    );
  }
}

class UserLoginRequest {
  final String email;
  final String password;

  UserLoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  factory UserLoginRequest.fromJson(Map<String, dynamic> json) {
    return UserLoginRequest(email: json['email'], password: json['password']);
  }
}

class UserUpdateRequest {
  final String? fullName;
  final String? phone;

  UserUpdateRequest({this.fullName, this.phone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (fullName != null) data['full_name'] = fullName;
    if (phone != null) data['phone'] = phone;
    return data;
  }

  factory UserUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequest(fullName: json['full_name'], phone: json['phone']);
  }
}
