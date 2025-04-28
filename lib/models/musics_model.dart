
class Musics {
  final String id;
  final String tiles;
  final String filename;
 

  Musics({
    required this.id,
    required this.tiles,
    required this.filename,
  });

  factory Musics.fromMap(String id, Map<String, dynamic> data) {
    return Musics(
      id: id,
      tiles: data['tiles'] ?? '',
      filename: data['filename'] ?? '',
      
    );
  }
}
