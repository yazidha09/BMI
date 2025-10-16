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
    required String gender,
    required int age,
    required String activityLevel,
    required String bodyComposition,
  }) async {
    try {
      final prompt =
          '''
You are an expert fitness and nutrition advisor. Provide comprehensive, actionable health advice based on this profile:

📊 METRICS:
BMI: ${bmi.toStringAsFixed(1)} ($status)
Height: ${height.toStringAsFixed(1)} cm | Weight: ${weight.toStringAsFixed(1)} kg
Gender: $gender | Age: $age years
Activity: $activityLevel
Body Type: $bodyComposition

🎯 CRITICAL CONTEXT:
- "Skinny": Ectomorph body type, struggles to gain weight/muscle, fast metabolism, needs caloric surplus
- "Balanced": Average metabolism, moderate muscle-to-fat ratio
- "Mostly Fat": Higher body fat %, needs caloric deficit and fat loss focus
- "Mostly Muscles": Athletic/muscular, higher BMI is healthy (muscle weighs more than fat)

📋 PROVIDE SPECIFIC ADVICE ON:

1. **Health Assessment** (2 sentences)
   - Is their BMI accurate for their body type?
   - Overall health status considering muscle/fat ratio

2. **Nutrition Plan** (3-4 points)
   For Skinny: High-calorie foods (3000+ cal), protein (1.6-2g/kg), healthy fats, frequent meals
   For Fat Loss: Caloric deficit (500 cal below maintenance), high protein, reduce processed foods
   For Muscle Gain: Protein timing, carbs around workouts, meal frequency
   For Maintenance: Balanced macros (40% carbs, 30% protein, 30% fats)

3. **Gym/Training Recommendations** (3-4 points)
   For Beginners/Skinny: Full-body workouts 3x/week, compound movements (squats, deadlifts, bench press), progressive overload
   For Bodybuilding: Split routines, hypertrophy rep ranges (8-12), focus on form
   For CrossFit/Running: Mix strength training, recovery importance
   For Sedentary: Start with walking 30min daily, gradually increase intensity

4. **Key Action Steps** (2-3 specific, measurable goals)

Keep response under 250 words. Be motivating, practical, and direct. Use bullet points for clarity.
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
          'max_tokens': 400,
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
