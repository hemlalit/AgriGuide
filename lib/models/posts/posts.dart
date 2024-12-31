import '../author.dart';
import '../comment.dart';

class Posts {
  String? id;
  String? content;
  Author? author;
  List<dynamic>? likes;
  List<dynamic>? retweetedBy;
  int? retweetCount;
  List<Comment>? comments;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Posts({
    this.id,
    this.content,
    this.author,
    this.likes,
    this.retweetedBy,
    this.retweetCount,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        id: json['_id'] as String?,
        content: json['content'] as String?,
        author: json['author'] == null
            ? null
            : Author.fromJson(json['author'] as Map<String, dynamic>),
        likes: json['likes'] as List<dynamic>?,
        retweetedBy: json['retweetedBy'] as List<dynamic>?,
        retweetCount: json['retweetCount'] as int?,
        comments: (json['comments'] as List<dynamic>?)
            ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.parse(json['createdAt'] as String),
        updatedAt: json['updatedAt'] == null
            ? null
            : DateTime.parse(json['updatedAt'] as String),
        v: json['__v'] as int?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'content': content,
        'author': author?.toJson(),
        'likes': likes,
        'retweetedBy': retweetedBy,
        'retweetCount': retweetCount,
        'comments': comments?.map((e) => e.toJson()).toList(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        '__v': v,
      };
}
