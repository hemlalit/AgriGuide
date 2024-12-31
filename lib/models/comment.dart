class CommentedBy {
  String? id;
  String? name;
  String? username;

  CommentedBy({
    this.id,
    this.name,
    this.username,
  });

  factory CommentedBy.fromJson(Map<String, dynamic> json) => CommentedBy(
        id: json['_id'] as String?,
        name: json['name'] as String?,
        username: json['username'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'username': username,
      };
}

class Comment {
  CommentedBy? commentedBy;
  String? content;
  DateTime? timestamp;
  String? id;

  Comment({this.commentedBy, this.content, this.timestamp, this.id});

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        commentedBy: json['commentedBy'] == null
            ? null
            : CommentedBy.fromJson(json['commentedBy'] as Map<String, dynamic>),
        content: json['content'] as String?,
        timestamp: json['timestamp'] == null
            ? null
            : DateTime.parse(json['timestamp'] as String),
        id: json['_id'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'commentedBy': commentedBy?.toJson(),
        'content': content,
        'timestamp': timestamp?.toIso8601String(),
        '_id': id,
      };
}
