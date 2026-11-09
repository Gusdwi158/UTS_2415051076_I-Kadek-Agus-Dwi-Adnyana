import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cafe_model.dart';

class ApiService {
  // TODO: Masukkan URL MockAPI yang kamu buat tadi (berakhiran /cafes)
  final String baseUrl = 'https://6af1f15d42c6561ced38d39b.mockapi.io/cafes';

  Future<List<Cafe>> fetchCafes() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Cafe.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data kafe dari API');
    }
  }
}
