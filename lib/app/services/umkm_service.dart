
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/umkm_model.dart';

class UmkmService {
  static const String baseUrl =
      'http://localhost:8080/api/umkm';

  // GET - Mengambil seluruh data UMKM
  Future<List<UmkmModel>> getUmkm() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> data = jsonData['data'];

      return data
          .map((item) => UmkmModel.fromJson(item))
          .toList();
    }

    throw Exception('Gagal mengambil data UMKM');
  }

  // POST - Menambahkan data UMKM
  Future<bool> addUmkm(Map<String, String> data) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: data,
    );

    return response.statusCode == 201;
  }

  // PUT - Memperbarui data UMKM
  Future<bool> updateUmkm(
    int id,
    Map<String, String> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      body: data,
    );

    return response.statusCode == 200;
  }

  // DELETE - Menghapus data UMKM
  Future<bool> deleteUmkm(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    return response.statusCode == 200;
  }
}
