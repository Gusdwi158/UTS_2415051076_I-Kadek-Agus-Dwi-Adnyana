class Cafe {
  final String id;
  final String name;
  final String location;
  final String description;
  final String imageUrl;
  final double rating;

  Cafe({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imageUrl,
    this.rating = 0.0,
  });

  // Fungsi untuk mengubah JSON dari API menjadi Object Dart
  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'].toString(),
      name: json['name'] ?? 'Nama Kafe Tidak Diketahui',
      location: json['location'] ?? 'Lokasi Tidak Diketahui',
      description: json['description'] ?? 'Tidak ada deskripsi.',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/150',
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
