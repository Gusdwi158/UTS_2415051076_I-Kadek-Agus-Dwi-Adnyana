import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/saved_cafe_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // READ: Mengambil daftar kafe favorit
  Future<List<SavedCafe>> getSavedCafes() async {
    final response = await _supabase
        .from('saved_cafes')
        .select()
        .order('created_at', ascending: false);
    return response.map((data) => SavedCafe.fromJson(data)).toList();
  }

  // CREATE: Menyimpan kafe ke favorit
  Future<void> addSavedCafe(
    String cafeId,
    String cafeName,
    String reviewNote,
  ) async {
    await _supabase.from('saved_cafes').insert({
      'cafe_id': cafeId,
      'cafe_name': cafeName,
      'review_note': reviewNote,
    });
  }

  // UPDATE: Mengubah catatan review
  Future<void> updateReview(int id, String newReviewNote) async {
    await _supabase
        .from('saved_cafes')
        .update({'review_note': newReviewNote})
        .eq('id', id);
  }

  // DELETE: Menghapus dari favorit
  Future<void> deleteSavedCafe(int id) async {
    await _supabase.from('saved_cafes').delete().eq('id', id);
  }
}
