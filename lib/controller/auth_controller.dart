import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import '../app_module/data/model/user.dart';

class AuthController extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _token = '';
  User? _currentUser;
  final CookieRequest request;
  static const String baseUrl = 'http://34.101.37.162/api/v1';

  AuthController({required this.request}) {
    initialize();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get token => _token;
  User? get currentUser => _currentUser;
  String get username => _currentUser?.fullName ?? '';
  String get email => _currentUser?.email ?? '';

  Future<void> initialize() async {
    await checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      final url = '$baseUrl/auth/me';
      final response = await request.get(url);

      if (response['status'] == 'success' && response['data'] != null) {
        _isLoggedIn = true;
        _currentUser = User.fromJson(response['data']);
        _token = response['token'] ?? '';
      } else {
        _isLoggedIn = false;
        _currentUser = null;
        _token = '';
      }
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
      _token = '';
    }
    notifyListeners();
  }

  Future<AuthResponse> register(UserRegisterRequest registerRequest) async {
    try {
      final url = '$baseUrl/auth/register';
      final response = await request.postJson(
        url,
        jsonEncode(registerRequest.toJson()),
      );

      if (response['status'] == 'success') {
        _isLoggedIn = true;
        _currentUser = User.fromJson(response['data']['user']);
        _token = response['data']['token'];
        request.headers['Authorization'] = 'Bearer $_token';
      } else {
        _isLoggedIn = false;
        _currentUser = null;
        _token = '';
      }

      notifyListeners();
      return AuthResponse.fromJson(response);
    } catch (e) {
      notifyListeners();
      return AuthResponse(
        status: 'error',
        message: 'Registration failed: ${e.toString()}',
      );
    }
  }

  Future<AuthResponse> login(UserLoginRequest loginRequest) async {
    try {
      final url = '$baseUrl/auth/login';
      final response = await request.postJson(
        url,
        jsonEncode(loginRequest.toJson()),
      );

      if (response['status'] == 'success') {
        _isLoggedIn = true;
        _currentUser = User.fromJson(response['data']['user']);
        _token = response['data']['token'];
        request.headers['Authorization'] = 'Bearer $_token';
      } else {
        _isLoggedIn = false;
        _currentUser = null;
        _token = '';
      }

      notifyListeners();
      return AuthResponse.fromJson(response);
    } catch (e) {
      notifyListeners();
      return AuthResponse(
        status: 'error',
        message: 'Login failed: ${e.toString()}',
      );
    }
  }

  Future<AuthResponse> logout() async {
    try {
      final url = '$baseUrl/auth/logout';
      final response = await request.post(url, {});

      _isLoggedIn = false;
      _currentUser = null;
      _token = '';
      request.headers.remove('Authorization');

      notifyListeners();
      return AuthResponse.fromJson(response);
    } catch (e) {
      _isLoggedIn = false;
      _currentUser = null;
      _token = '';
      request.headers.remove('Authorization');

      notifyListeners();
      return AuthResponse(
        status: 'success',
        message: 'Logged out successfully',
      );
    }
  }

  Future<AuthResponse> updateProfile(UserUpdateRequest updateRequest) async {
    try {
      final url = '$baseUrl/auth/profile';
      final response = await request.postJson(
        url,
        jsonEncode(updateRequest.toJson()),
      );

      if (response['status'] == 'success') {
        _currentUser = User.fromJson(response['data']);
      }

      notifyListeners();
      return AuthResponse.fromJson(response);
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Update profile failed: ${e.toString()}',
      );
    }
  }

  Future<AuthResponse> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final url = '$baseUrl/auth/change-password';
      final data = {
        'current_password': currentPassword,
        'new_password': newPassword,
      };
      final response = await request.postJson(url, jsonEncode(data));

      notifyListeners();
      return AuthResponse.fromJson(response);
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Change password failed: ${e.toString()}',
      );
    }
  }

  Future<AuthResponse> refreshToken() async {
    try {
      final url = '$baseUrl/auth/refresh';
      final response = await request.post(url, {});

      if (response['status'] == 'success') {
        _token = response['data']['token'];
        request.headers['Authorization'] = 'Bearer $_token';
      }

      return AuthResponse.fromJson(response);
    } catch (e) {
      return AuthResponse(
        status: 'error',
        message: 'Token refresh failed: ${e.toString()}',
      );
    }
  }

  void clearUserData() {
    _isLoggedIn = false;
    _currentUser = null;
    _token = '';
    request.headers.remove('Authorization');
    notifyListeners();
  }
}

class AuthResponse {
  final String status;
  final String message;
  final Map<String, dynamic>? data;

  AuthResponse({required this.status, required this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? 'Unknown error',
      data: json['data'],
    );
  }

  bool get isSuccess => status == 'success';
  bool get isError => status == 'error';
}
