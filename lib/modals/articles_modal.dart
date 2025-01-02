class Articles {
  String author;
  String title;
  String description;
  String newsUrl;
  String imageUrl;
  String publishDate;
  String content;

  Articles({
    required this.author,
    required this.title,
    required this.description,
    required this.newsUrl,
    required this.imageUrl,
    required this.publishDate,
    required this.content,
  });

  factory Articles.fromJson(Map<String, dynamic> json) {
    return Articles(
      author: json['author'] ?? 'Unknown Author', // Handle null values
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      newsUrl: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishDate: json['publishedAt'] ?? '',
      content: json['content'] ?? 'No Content',
    );
  }
}
