import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 1. Genderize API
  static Future<Map<String, dynamic>> predictGender(String name) async {
    final res = await http.get(Uri.parse('https://api.genderize.io/?name=$name'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Error fetching gender data');
  }

  // 2. Agify API
  static Future<Map<String, dynamic>> predictAge(String name) async {
    final res = await http.get(Uri.parse('https://api.agify.io/?name=$name'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Error fetching age data');
  }

  // 3. Universities API
  static Future<List<dynamic>> getUniversities(String country) async {
    final encoded = Uri.encodeComponent(country);
    final res = await http.get(Uri.parse('https://adamix.net/proxy.php?country=$encoded'));
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data is List ? data : [];
    }
    throw Exception('Error fetching universities data');
  }

  // 4. Open-Meteo API
  static Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weathercode'
        '&daily=temperature_2m_max,temperature_2m_min,weathercode'
        '&timezone=America%2FSanto_Domingo'
        '&forecast_days=5'
    );
    final res = await http.get(url);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Error fetching weather data');
  }

  // 5. PokeAPI
  static Future<Map<String, dynamic>> getPokemon(String name) async {
    final res = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    }
    throw Exception('Pokemon no encontrado');
  }

  // 6. WordPress REST API (CSS-Tricks)
  static Future<List<dynamic>> getWordpressPosts(String apiUrl) async {
    final res = await http.get(Uri.parse(apiUrl), headers: {'User-Agent': 'Flutter App'});
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as List;
    }
    throw Exception('Error fetching WordPress posts');
  }
}
