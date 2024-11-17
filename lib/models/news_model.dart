class News {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;

  News({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}
