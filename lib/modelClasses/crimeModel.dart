import 'package:http/http.dart' as http;
import 'dart:convert';

class PredictionService {
  Future<List<dynamic>> fetchPredictions() async {
    var url = Uri.parse('https://model-deployment-v2-80qo.onrender.com/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
