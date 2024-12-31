class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? phone;
  String? password;
  String? bio;
  String? profileImage;
  String? bannerImage;
  List<String>? followers;
  List<String>? following;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.password,
    this.bio,
    this.profileImage,
    this.bannerImage,
    this.followers,
    this.following,
    this.createdAt,
    this.updatedAt,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Log the JSON data to check what is being received
    print('User JSON: $json');

    return User(
      id: json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      profileImage: json['profileImage'] as String? ??
          '', // Default to empty string if null
      bannerImage: json['bannerImage'] as String? ??
          '', // Default to empty string if null
      followers: (json['followers'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      following: (json['following'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
      'bio': bio,
      'profileImage': profileImage,
      'bannerImage': bannerImage,
      'followers': followers,
      'following': following,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
