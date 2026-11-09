class SavedCafe {
  final int id;
  final String cafeId;
  final String cafeName;
  final String reviewNote;
  final String createdAt;

  SavedCafe({
    required this.id,
    required this.cafeId,
    required this.cafeName,
    required this.reviewNote,
    required this.createdAt,
  });

  factory SavedCafe.fromJson(Map<String, dynamic> json) {
    return SavedCafe(
      id: json['id'],
      cafeId: json['cafe_id'].toString(),
      cafeName: json['cafe_name'] ?? '',
      reviewNote: json['review_note'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}
