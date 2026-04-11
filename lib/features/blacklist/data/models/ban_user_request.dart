class BanUserRequest {
  final String banReason;

  BanUserRequest({required this.banReason});

  Map<String, dynamic> toJson() {
    return {
      'banReason': banReason,
    };
  }
}
