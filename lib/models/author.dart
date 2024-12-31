class Author {
  String? id;
  String? name;
  String? username;
  String? profileImage;

  Author({this.id, this.name, this.profileImage, this.username});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        username: json['username'] as String?,
        profileImage: json['profileImage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'username': username,
        'profileImage': profileImage,
      };
}
