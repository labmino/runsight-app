class UserResponse {
  final bool status;
  final String message;
  final String? username;

  UserResponse({
    required this.status,
    required this.message,
    this.username,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      username: json['username'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (username != null) 'username': username,
    };
  }
}
