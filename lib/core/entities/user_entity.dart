import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String? address;
  final double? latitude;
  final double? longitude;
  final double? wallet;

  const UserEntity({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    this.address,
    this.latitude,
    this.longitude,
    this.wallet,
  });

  @override
  List<Object?> get props => [
        userId,
        firstName,
        lastName,
        email,
        phone,
        image,
        address,
        latitude,
        longitude,
        wallet,
      ];
}