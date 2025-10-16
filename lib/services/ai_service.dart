import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String apiKey =
      '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';
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  Future<String> getBMIAdvice({
    required double bmi,
    required String status,
    required double height,
    required double weight,
  }) async {
    try {
      final prompt =
          '''
You are a helpful health advisor. Based on the following BMI information, provide concise, practical health advice (max 150 words):

BMI: ${bmi.toStringAsFixed(1)}
Status: $status
Height: ${height.toStringAsFixed(1)} cm
Weight: ${weight.toStringAsFixed(1)} kg

Provide specific advice including:
1. Brief health assessment
2. One or two actionable recommendations
3. Encouragement

Keep it friendly, supportive, and actionable.
''';

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://github.com/yazidha09/bmi-calculator',
          'X-Title': 'BMI Calculator App',
        },
        body: jsonEncode({
          'model': 'meta-llama/llama-3.2-3b-instruct:free',
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 250,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final advice = data['choices'][0]['message']['content'] as String;
        return advice.trim();
      } else {
        return 'Unable to get advice at the moment. Please try again later.';
      }
    } catch (e) {
      return 'Error getting advice. Please check your connection.';
    }
  }
}
