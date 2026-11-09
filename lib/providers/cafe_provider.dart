import 'package:flutter/material.dart';

import '../models/cafe_model.dart';
import '../models/saved_cafe_model.dart';
import '../services/api_service.dart';
import '../services/supabase_service.dart';

class CafeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final SupabaseService _supabaseService = SupabaseService();

  List<Cafe> _cafes = [];
  List<Cafe> get cafes => _cafes;

  List<SavedCafe> _savedCafes = [];
  List<SavedCafe> get savedCafes => _savedCafes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Ambil data API
  Future<void> loadCafesFromApi() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cafes = await _apiService.fetchCafes();
    } catch (e) {
      _errorMessage = "Gagal mengambil data katalog kafe.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Ambil data Database
  Future<void> loadSavedCafes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _savedCafes = await _supabaseService.getSavedCafes();
    } catch (e) {
      _errorMessage = "Gagal mengambil data favorit.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Wrapper untuk simpan (Create)
  Future<void> saveCafe(String cafeId, String cafeName, String note) async {
    await _supabaseService.addSavedCafe(cafeId, cafeName, note);
    await loadSavedCafes();
  }

  // Wrapper untuk ubah (Update)
  Future<void> updateCafeNote(int id, String note) async {
    await _supabaseService.updateReview(id, note);
    await loadSavedCafes();
  }

  // Wrapper untuk hapus (Delete)
  Future<void> deleteCafe(int id) async {
    await _supabaseService.deleteSavedCafe(id);
    await loadSavedCafes();
  }
}
