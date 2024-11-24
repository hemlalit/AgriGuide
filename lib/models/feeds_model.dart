class News {
  final String title;
  final String description;
  final String imageUrl;
  final String date;
  final String? sourceUrl;

  News({
    this.sourceUrl,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      sourceUrl: json['url'] ?? 'No url',
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'],
    );
  }
}
