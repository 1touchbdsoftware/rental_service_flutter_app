class DeviceInputRequest {
  final String userId;
  final String deviceToken;
  final String platform;

  DeviceInputRequest({
    required this.userId,
    required this.deviceToken,
    required this.platform,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceToken': deviceToken,
      'platform': platform,
    };
  }
}
