class Video {
  final int id;
  final String name;
  final String thumbnail;
  final String url;
  final String categoryId;
  final String category;

  Video({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.url,
    required this.categoryId,
    required this.category,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      url: json['url'],
      categoryId: json['category_id'],
      category: json['category'],
    );
  }
}
