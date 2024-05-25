import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jenis_kopi.dart';

class ApiService {
  static const String _baseUrl = 'https://fake-coffee-api.vercel.app/api';

  Future<List<JenisKopi>> fetchCoffees() async {
    final response = await http.get(Uri.parse('$_baseUrl/coffee'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<JenisKopi> coffees = body.map((dynamic item) => JenisKopi.fromJson(item)).toList();
      return coffees;
    } else {
      throw Exception('Failed to load coffees');
    }
  }
}
