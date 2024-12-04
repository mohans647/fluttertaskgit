class Issue {
  final String title;
  final int number;
  final String createdAt;
  final String author;
  final List<String> labels;
  final String? closedAt;

  Issue({
    required this.title,
    required this.number,
    required this.createdAt,
    required this.author,
    required this.labels,
    this.closedAt,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {
    List<String> labels = [];
    if (json['labels'] is List) {
      labels = (json['labels'] as List).map((label) => label['name'] as String).toList();
    }

    return Issue(
      title: json['title'] ?? '',
      number: json['number'] ?? 0,
      createdAt: json['created_at'] ?? '',
      author: json['user']?['login'] ?? '',
      labels: labels,
      closedAt: json['closed_at'],
    );
  }

}