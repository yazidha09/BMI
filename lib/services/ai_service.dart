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
You are an expert fitness and nutrition advisor. Analyze this SPECIFIC person's profile and provide TAILORED advice based on THEIR unique combination of metrics:

📊 USER PROFILE:
- BMI: ${bmi.toStringAsFixed(1)} (Status: $status)
- Height: ${height.toStringAsFixed(1)} cm | Weight: ${weight.toStringAsFixed(1)} kg
- Gender: $gender | Age: $age years old
- Current Activity: $activityLevel
- Body Composition: $bodyComposition

🎯 ANALYZE THIS SPECIFIC COMBINATION:
You MUST consider how their body composition + activity level + BMI status work together:

• If "Skinny" + "Underweight/Normal" → Focus on BULKING (caloric surplus, heavy compound lifts)
• If "Skinny" + "Sedentary" → Focus on building workout habit first, then add calories
• If "Mostly Muscles" + "Overweight/Obese" BMI → AFFIRM their BMI is misleading due to muscle mass
• If "Mostly Muscles" + "Bodybuilding" → Advanced training splits and periodization
• If "Mostly Fat" + "Overweight/Obese" → Fat loss priority with caloric deficit
• If "Mostly Fat" + "Sedentary" → Start with walking, gradually add resistance training
• If "Balanced" → Maintain or adjust based on their activity level goals

IMPORTANT: Address their EXACT activity level:
- Sedentary → How to start exercising safely
- Fitness → How to optimize their light workouts
- Bodybuilding → Advanced muscle-building techniques
- CrossFit → Performance optimization and recovery
- Running → Strength training to complement cardio
- Other Sport → Cross-training and injury prevention

📋 PROVIDE THIS STRUCTURE:

1. **Personalized Health Assessment** (2-3 sentences)
   - Directly address their BMI (${bmi.toStringAsFixed(1)}) in context of "$bodyComposition" body type
   - Mention if BMI is accurate or misleading for them
   - Comment on their "$activityLevel" routine

2. **Custom Nutrition Plan** (4-5 specific points)
   - EXACT calorie target based on their goal (bulk/cut/maintain)
   - Protein goal in grams: ${(weight * 1.8).toStringAsFixed(0)}g+ (1.8g/kg minimum)
   - Meal timing and frequency
   - Specific foods to eat MORE of
   - Foods to limit or avoid

3. **Activity-Specific Training** (4-5 points)
   - Address their CURRENT activity level: "$activityLevel"
   - If sedentary: how to start
   - If active: how to optimize or progress
   - Specific exercises (name them)
   - Sets, reps, frequency

4. **Action Plan** (3 measurable steps)
   - Weekly goals
   - Progress tracking metrics
   - Timeline expectations

CRITICAL: Your advice MUST reflect their specific selections. Don't give generic advice. If they selected "Bodybuilding", talk about splits and hypertrophy. If they selected "Skinny", emphasize mass gaining. If they selected "CrossFit", mention high-intensity training.

Keep response under 300 words but make every word count. Be direct and motivating.
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
          'max_tokens': 450,
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
