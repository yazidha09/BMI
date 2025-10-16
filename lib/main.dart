import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'database/database_helper.dart';
import 'models/bmi_record.dart';
import 'services/ai_service.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const BmiPage(),
    );
  }
}

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  final heightCtrl = TextEditingController();
  final weightCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedActivity = 'Sedentary';
  String _selectedBodyComp = 'Balanced';
  double? _bmi;
  String _status = '';
  final _dbHelper = DatabaseHelper.instance;
  final _aiService = AIService();
  String? _aiAdvice;
  bool _isLoadingAdvice = false;

  void _calculateBMI() async {
    final h = double.tryParse(heightCtrl.text);
    final w = double.tryParse(weightCtrl.text);
    final age = int.tryParse(ageCtrl.text);

    if (h == null || w == null || h <= 0 || age == null || age <= 0) {
      setState(() {
        _bmi = null;
        _status = 'Enter valid numbers!';
        _aiAdvice = null;
      });
      return;
    }
    final bmi = w / ((h / 100) * (h / 100));
    String s;
    if (bmi < 18.5)
      s = 'Underweight';
    else if (bmi < 25)
      s = 'Normal';
    else if (bmi < 30)
      s = 'Overweight';
    else
      s = 'Obese';

    setState(() {
      _bmi = bmi;
      _status = s;
      _isLoadingAdvice = true;
      _aiAdvice = null;
    });

    // Save to database
    final record = BmiRecord(
      height: h,
      weight: w,
      bmi: bmi,
      status: s,
      date: DateTime.now(),
      gender: _selectedGender,
      age: age,
      activityLevel: _selectedActivity,
      bodyComposition: _selectedBodyComp,
    );
    await _dbHelper.insertRecord(record);

    // Get AI advice
    final advice = await _aiService.getBMIAdvice(
      bmi: bmi,
      status: s,
      height: h,
      weight: w,
      gender: _selectedGender,
      age: age,
      activityLevel: _selectedActivity,
      bodyComposition: _selectedBodyComp,
    );

    setState(() {
      _aiAdvice = advice;
      _isLoadingAdvice = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BMI record saved!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    heightCtrl.dispose();
    weightCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('BMI Calculator'),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
            tooltip: 'View History',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gender Selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gender',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Male'),
                            value: 'Male',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Female'),
                            value: 'Female',
                            groupValue: _selectedGender,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age (years)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: heightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: weightCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Activity Level Selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Level',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedActivity,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Sedentary',
                          child: Text('Sedentary (Little or no exercise)'),
                        ),
                        DropdownMenuItem(
                          value: 'Fitness',
                          child: Text('Fitness (Light exercise 1-3 days/week)'),
                        ),
                        DropdownMenuItem(
                          value: 'Bodybuilding',
                          child: Text('Bodybuilding (Intense training)'),
                        ),
                        DropdownMenuItem(
                          value: 'CrossFit',
                          child: Text('CrossFit (High intensity workouts)'),
                        ),
                        DropdownMenuItem(
                          value: 'Running',
                          child: Text('Running (Regular cardio)'),
                        ),
                        DropdownMenuItem(
                          value: 'Other Sport',
                          child: Text('Other Sport (Active lifestyle)'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedActivity = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Body Composition Selection
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Body Composition',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'How would you describe your body?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      title: const Text(
                        'Skinny/Ectomorph (Hard to gain weight)',
                      ),
                      value: 'Skinny',
                      groupValue: _selectedBodyComp,
                      onChanged: (value) {
                        setState(() {
                          _selectedBodyComp = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Balanced'),
                            value: 'Balanced',
                            groupValue: _selectedBodyComp,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyComp = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('Mostly Fat'),
                            value: 'Mostly Fat',
                            groupValue: _selectedBodyComp,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyComp = value!;
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                    RadioListTile<String>(
                      title: const Text('Mostly Muscles (Athletic/Muscular)'),
                      value: 'Mostly Muscles',
                      groupValue: _selectedBodyComp,
                      onChanged: (value) {
                        setState(() {
                          _selectedBodyComp = value!;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _calculateBMI,
                child: Text(
                  'Calculate BMI',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _bmi == null
                      ? Colors.grey[300]
                      : _status == 'Normal'
                      ? Colors.green[100]
                      : _status == 'Underweight'
                      ? Colors.blue[100]
                      : _status == 'Overweight'
                      ? Colors.orange[100]
                      : Colors.red[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _bmi == null ? '--' : _bmi!.toStringAsFixed(1),
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              // AI Advice Section
              if (_bmi != null || _isLoadingAdvice) ...[
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.psychology,
                            color: theme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'AI Health Advice',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingAdvice)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_aiAdvice != null)
                        Text(
                          _aiAdvice!,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _dbHelper = DatabaseHelper.instance;
  List<BmiRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    final records = await _dbHelper.getAllRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  Future<void> _deleteRecord(int id) async {
    await _dbHelper.deleteRecord(id);
    _loadRecords();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record deleted!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.green[100]!;
      case 'Underweight':
        return Colors.blue[100]!;
      case 'Overweight':
        return Colors.orange[100]!;
      case 'Obese':
        return Colors.red[100]!;
      default:
        return Colors.grey[300]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('BMI History'),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No BMI records yet',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getStatusColor(record.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Row(
                        children: [
                          Text(
                            'BMI: ${record.bmi.toStringAsFixed(1)}',
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              record.status,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            'Height: ${record.height.toStringAsFixed(1)} cm  •  Weight: ${record.weight.toStringAsFixed(1)} kg',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${record.gender}, ${record.age} years  •  ${record.activityLevel}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Body: ${record.bodyComposition}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(record.date),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Record'),
                              content: const Text(
                                'Are you sure you want to delete this record?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteRecord(record.id!);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
