class User {
  final String name;
  final String email;
  final String phone;
  final String? profileImageUrl;

  User({
    required this.name,
    required this.email,
    required this.phone,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      // Adjust the key as needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'profile_image_url': profileImageUrl,
    };
  }
}
