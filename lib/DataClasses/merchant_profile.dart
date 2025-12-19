class MerchantProfile {
  final String fullName;
  final String? businessName;
  final String? email;
  final String phoneNumber;

  MerchantProfile({
    required this.fullName,
    this.businessName,
    this.email,
    required this.phoneNumber,
  });

  factory MerchantProfile.fromJson(Map<String, dynamic> json) {
    return MerchantProfile(
      fullName: json['fullName'],
      businessName: json['businessName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
