

class News {
  final String id;
  final String tiles;
  final String content;
  final String img;
  final dynamic timestamp; // Firestore Timestamp or DateTime

  News({
    required this.id,
    required this.tiles,
    required this.content,
    required this.img,
    required this.timestamp,
  });

  factory News.fromMap(String id, Map<String, dynamic> data) {
    return News(
      id: id,
      tiles: data['tiles'] ?? '',
      content: data['content'] ?? '',
      img: data['img'] ?? '',
      timestamp: data['timestamp'],
    );
  }
}
