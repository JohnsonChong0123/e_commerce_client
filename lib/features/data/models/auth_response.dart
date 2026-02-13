import 'package:equatable/equatable.dart';

import 'user_model.dart';

/// Data layer model representing the authentication response
/// returned by the remote API.
class AuthResponse extends Equatable {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final String provider;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.provider,
  });
  
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      provider: json['provider'],
    );
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, provider];
}
