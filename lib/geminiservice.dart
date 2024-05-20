import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const _apiKey = 'AIzaSyCk9iMFBbpTFXIpw3-gK6By9gnzZr1b_Ak';
  static const _baseUrl = 'https://api.your-gemini-service.com/v1/modify';

  Future<String> getUpdatedText(String prompt) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: json.encode({
        'prompt': prompt,
        'max_tokens': 100,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['text'];
    } else {
      throw Exception('Failed to fetch AI response');
    }
  }
}
