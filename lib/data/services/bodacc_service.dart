import 'dart:convert';
import 'package:http/http.dart' as http;

class BodaccService {
  static const String baseUrl =
      "https://bodacc-datadila.opendatasoft.com/api/records/1.0/search/?dataset=annonces-commerciales";

  Future<List<dynamic>> fetchAnnonces({
    String query = "",
    int rows = 20,
  }) async {
    final url = Uri.parse("$baseUrl&q=$query&rows=$rows");

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Erreur API BODACC : ${response.statusCode}");
    }

    final data = jsonDecode(response.body);

    return data["records"] ?? [];
  }
}
