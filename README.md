# 🏃‍♂️ BMI Calculator with AI Health Advisor

A comprehensive Flutter-based BMI (Body Mass Index) calculator that goes beyond simple calculations by providing **personalized AI-powered health, nutrition, and fitness advice** tailored to your unique body type, activity level, and fitness goals.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## ✨ Features

### 📊 Comprehensive Health Metrics
- **BMI Calculation** - Accurate BMI calculation based on height and weight
- **Health Status** - Instant classification (Underweight, Normal, Overweight, Obese)
- **Gender & Age** - Personalized advice based on demographics
- **Activity Level Tracking** - Track your fitness routine:
  - Sedentary (Little to no exercise)
  - Fitness (Light exercise 1-3 days/week)
  - Bodybuilding (Intense training)
  - CrossFit (High intensity workouts)
  - Running (Regular cardio)
  - Other Sports (Active lifestyle)
- **Body Composition** - Understand your body type:
  - Skinny/Ectomorph (Hard gainer, fast metabolism)
  - Balanced (Average muscle-to-fat ratio)
  - Mostly Fat (Higher body fat percentage)
  - Mostly Muscles (Athletic/muscular build)

### 🤖 AI-Powered Health Advisor
Powered by **OpenRouter API** with Meta's LLaMA 3.2 model, the app provides:
- **Intelligent BMI Analysis** - Understands that muscle weighs more than fat
- **Custom Nutrition Plans** - Specific calorie targets and macro breakdowns
- **Workout Recommendations** - Exercise programs based on your activity level
- **Meal Planning** - Food suggestions and meal frequency advice
- **Progressive Strategies** - Step-by-step action plans for your goals

#### Example AI Advice for Different Users:

**🏋️ For Skinny/Ectomorph Users:**
- Caloric surplus plans (3000+ calories)
- High-protein diet recommendations (1.6-2g/kg)
- Full-body workout programs with compound movements
- Mass gainer and supplement suggestions

**💪 For Bodybuilders:**
- Recognizes high BMI can be healthy muscle mass
- Split routine recommendations
- Hypertrophy training advice (8-12 rep ranges)
- Protein timing strategies

**🔥 For Fat Loss Goals:**
- Caloric deficit strategies (500 cal below maintenance)
- High-protein diets to preserve muscle
- Cardio and resistance training balance

**🧘 For Beginners:**
- Gentle introduction to exercise
- Walking programs (30 minutes daily)
- Progressive intensity increases
- Habit-building strategies

### 📱 User-Friendly Interface
- **Clean Material Design** - Modern UI with Google Fonts (Poppins)
- **Color-Coded Results** - Visual health status indicators
- **Responsive Layout** - Works on all screen sizes
- **Smooth Animations** - Enhanced user experience
- **Loading States** - Clear feedback during AI processing

### 💾 Complete History Tracking
- **SQLite Database** - All BMI records saved locally
- **Detailed History** - View past calculations with full context
- **Record Management** - Delete unwanted entries
- **Comprehensive Data** - Includes gender, age, activity, and body composition
- **Date/Time Stamps** - Track your progress over time

## 🎯 Why This App Stands Out

### 1. **Context-Aware Advice**
Unlike basic BMI calculators, this app understands:
- A bodybuilder with BMI 27 is **healthy** (muscle mass)
- A sedentary person with BMI 27 needs **lifestyle changes**
- A skinny person needs **different advice** than someone with higher body fat

### 2. **Actionable Recommendations**
Not just generic advice, but specific:
- "Eat 3000 calories" vs "eat more"
- "Do squats, deadlifts, bench press 3x/week" vs "exercise"
- "1.6-2g protein per kg body weight" vs "eat protein"

### 3. **Scientific Foundation**
- Evidence-based nutrition advice
- Progressive overload principles
- Proper macro ratios (40/30/30)
- Recovery importance
- Form before weight philosophy

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yazidha09/BMI.git
cd bmi
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### Configuration

The app uses OpenRouter API for AI-powered advice. The API key is configured in:
```
lib/services/ai_service.dart
```

To use your own API key:
1. Get an API key from [OpenRouter](https://openrouter.ai/)
2. Replace the `apiKey` constant in `ai_service.dart`

## 📁 Project Structure

```
lib/
├── main.dart                    # Main app entry point & UI
├── models/
│   └── bmi_record.dart         # BMI record data model
├── database/
│   └── database_helper.dart    # SQLite database management
└── services/
    └── ai_service.dart         # OpenRouter AI integration

test/
└── widget_test.dart            # Unit tests
```

## 🗄️ Database Schema

**Version 3** (Current)
```sql
CREATE TABLE bmi_records (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  height REAL NOT NULL,
  weight REAL NOT NULL,
  bmi REAL NOT NULL,
  status TEXT NOT NULL,
  date TEXT NOT NULL,
  gender TEXT NOT NULL,
  age INTEGER NOT NULL,
  activityLevel TEXT NOT NULL,
  bodyComposition TEXT NOT NULL
)
```

## 🤖 AI Prompt Engineering

The app uses a sophisticated prompt that provides:
1. **Health Assessment** - 2 sentences on BMI accuracy and status
2. **Nutrition Plan** - 3-4 specific dietary recommendations
3. **Training Program** - 3-4 exercise recommendations
4. **Action Steps** - 2-3 measurable goals

Example prompt structure:
```
📊 METRICS: BMI, height, weight, gender, age, activity, body type
🎯 CONTEXT: Body type explanations (ectomorph, balanced, etc.)
📋 ADVICE: Structured nutrition + gym + action plan
```

## 🎨 UI Screenshots

*Coming soon - Add screenshots of your app here*

## 📊 Use Cases

### Use Case 1: Skinny Beginner
```
Input: 19M, 170cm, 55kg, Fitness, Skinny
BMI: 19.0 (Underweight)
Output: 
✅ Caloric surplus plan (3000-3500 cal/day)
✅ Beginner full-body workout
✅ High-protein meal ideas
✅ Progressive overload strategy
```

### Use Case 2: Experienced Bodybuilder
```
Input: 25M, 180cm, 90kg, Bodybuilding, Mostly Muscles
BMI: 27.7 (Overweight)
Output:
✅ "Your BMI is high due to muscle mass - healthy!"
✅ Hypertrophy-focused training
✅ Protein timing strategies
✅ Carb cycling advice
```

### Use Case 3: Fat Loss Journey
```
Input: 30F, 165cm, 75kg, Sedentary, Mostly Fat
BMI: 27.5 (Overweight)
Output:
✅ 500 calorie deficit plan
✅ Start with 30min walks
✅ High-protein diet
✅ Gradual progression plan
```

## 🔧 Technologies Used

- **Flutter** - Cross-platform mobile development
- **Dart** - Programming language
- **SQLite (sqflite)** - Local database storage
- **Google Fonts** - Beautiful typography
- **intl** - Date formatting
- **http** - API communication
- **OpenRouter API** - AI-powered advice
- **Meta LLaMA 3.2** - Large language model

## 📈 Roadmap

- [ ] Add graphs for BMI progress over time
- [ ] Export history to PDF/CSV
- [ ] Add water intake tracking
- [ ] Integrate with fitness trackers
- [ ] Add meal photo logging
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Custom workout builder
- [ ] Calorie calculator
- [ ] Macro tracking

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Yazid**
- GitHub: [@yazidha09](https://github.com/yazidha09)
- Repository: [BMI Calculator](https://github.com/yazidha09/BMI)

## 🙏 Acknowledgments

- OpenRouter for providing access to AI models
- Meta for the LLaMA 3.2 model
- Flutter team for the amazing framework
- Google Fonts for beautiful typography
- The fitness and nutrition science community

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Check existing issues for solutions
- Review the documentation

## ⚠️ Disclaimer

This app provides general health, fitness, and nutrition information for educational purposes only. It is not a substitute for professional medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider before starting any diet, exercise program, or making health-related decisions.

---

**Made with ❤️ using Flutter**
