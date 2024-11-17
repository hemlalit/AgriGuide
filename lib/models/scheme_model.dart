class Scheme {
  final String title;
  final String details;
  final String eligibility;
  final String benefits;

  Scheme({
    required this.title,
    required this.details,
    required this.eligibility,
    required this.benefits,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      title: json['title'] ?? 'No Title',
      details: json['details'] ?? 'No Details',
      eligibility: json['eligibility'] ?? 'No Eligibility Info',
      benefits: json['benefits'] ?? 'No Benefits Info',
    );
  }
}
