import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'dart:io';

class AudioCorrectionScreen extends StatefulWidget {
  const AudioCorrectionScreen({Key? key}) : super(key: key);

  @override
  State<AudioCorrectionScreen> createState() => _AudioCorrectionScreenState();
}

class _AudioCorrectionScreenState extends State<AudioCorrectionScreen> {
  late final AudioRecorder _recorder;
  bool _isRecording = false;
  // ignore: unused_field
  String? _recordedPath;
  String _selectedSurah = 'الفاتحة';
  String _selectedAyah = '1';
  
  late CorrectionResult _correctionResult;
  bool _showCorrection = false;

  final List<String> sheikhs = [
    'الشيخ عبد الباسط عبد الصمد',
    'الشيخ محمود خليل الحصري',
    'الشيخ عبد الرحمن السديس',
    'الشيخ سعود الشريم',
    'الشيخ ياسين الجزائري',
  ];

  String _selectedSheikh = 'الشيخ عبد الباسط عبد الصمد';

  @override
  void initState() {
    super.initState();
    _recorder = AudioRecorder();
    _correctionResult = CorrectionResult(
      ayah: 'الحمد لله رب العالمين',
      userRecitation: '',
      errors: [],
      correctRecitation: 'الحمد لله رب العالمين',
      accuracy: 0,
    );
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final Directory tempDir = await getTemporaryDirectory();
        final String fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        final String filePath = '${tempDir.path}/$fileName';

        const config = RecordConfig(
          encoder: AudioEncoder.aacLc,
        );

        await _recorder.start(config, path: filePath);
        
        setState(() {
          _isRecording = true;
          _showCorrection = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path != null) {
        setState(() {
          _recordedPath = path;
          _isRecording = false;
        });
        
        await _analyzeRecording();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ: $e')),
      );
    }
  }

  Future<void> _analyzeRecording() async {
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _correctionResult = CorrectionResult(
        ayah: 'الحمد لله رب العالمين',
        userRecitation: 'الحمد لله رب العالمين',
        errors: [
          ErrorDetail(
            word: 'الحمد',
            position: 0,
            userPronunciation: 'الحمد',
            correctPronunciation: 'الْحَمْد',
            errorType: 'تشكيل',
            severity: 'منخفض',
          ),
          ErrorDetail(
            word: 'العالمين',
            position: 3,
            userPronunciation: 'العالمين',
            correctPronunciation: 'الْعَالَمِين',
            errorType: 'نطق',
            severity: 'متوسط',
          ),
        ],
        correctRecitation: 'الحمد لله رب العالمين',
        accuracy: 85,
      );
      _showCorrection = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التسميع والتصحيح الذكي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'اختر السورة والآية',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedSurah,
                        decoration: InputDecoration(
                          labelText: 'السورة',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: ['الفاتحة', 'البقرة', 'آل عمران', 'النساء']
                            .map((surah) => DropdownMenuItem(
                                  value: surah,
                                  child: Text(surah),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSurah = value ?? 'الفاتحة';
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedAyah,
                        decoration: InputDecoration(
                          labelText: 'الآية',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: ['1', '2', '3', '4', '5']
                            .map((ayah) => DropdownMenuItem(
                                  value: ayah,
                                  child: Text('الآية $ayah'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedAyah = value ?? '1';
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isRecording
                              ? Colors.red.withOpacity(0.2)
                              : Colors.blue.withOpacity(0.2),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _isRecording
                                ? _stopRecording
                                : _startRecording,
                            borderRadius: BorderRadius.circular(60),
                            child: Icon(
                              _isRecording ? Icons.stop : Icons.mic,
                              size: 50,
                              color: _isRecording ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _isRecording ? 'جاري التسجيل...' : 'اضغط للتسجيل',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              if (_showCorrection) ...[
                Card(
                  color: _correctionResult.accuracy >= 80
                      ? Colors.green.withOpacity(0.1)
                      : Colors.orange.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'نسبة الدقة',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: _correctionResult.accuracy / 100,
                                  minHeight: 8,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation(
                                    _correctionResult.accuracy >= 80
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${_correctionResult.accuracy}%',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (_correctionResult.errors.isNotEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الأخطاء المكتشفة',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _correctionResult.errors.length,
                            itemBuilder: (context, index) {
                              final error = _correctionResult.errors[index];
                              return _buildErrorCard(error);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'استمع للتصحيح الصحيح',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _selectedSheikh,
                          decoration: InputDecoration(
                            labelText: 'اختر الشيخ',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                          items: sheikhs
                              .map((sheikh) => DropdownMenuItem(
                                    value: sheikh,
                                    child: Text(sheikh),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSheikh = value ?? sheikhs[0];
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'تشغيل تلاوة $_selectedSheikh',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('استمع للتصحيح'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(ErrorDetail error) {
    final severityColor = error.severity == 'منخفض'
        ? Colors.yellow
        : error.severity == 'متوسط'
            ? Colors.orange
            : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: severityColor),
        borderRadius: BorderRadius.circular(8),
        color: severityColor.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'الكلمة: "${error.word}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: severityColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  error.severity,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'نوع الخطأ: ${error.errorType}',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            'نطقك: ${error.userPronunciation}',
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
          const SizedBox(height: 4),
          Text(
            'الصحيح: ${error.correctPronunciation}',
            style: const TextStyle(fontSize: 12, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class CorrectionResult {
  final String ayah;
  final String userRecitation;
  final List<ErrorDetail> errors;
  final String correctRecitation;
  final int accuracy;

  CorrectionResult({
    required this.ayah,
    required this.userRecitation,
    required this.errors,
    required this.correctRecitation,
    required this.accuracy,
  });
}

class ErrorDetail {
  final String word;
  final int position;
  final String userPronunciation;
  final String correctPronunciation;
  final String errorType;
  final String severity;

  ErrorDetail({
    required this.word,
    required this.position,
    required this.userPronunciation,
    required this.correctPronunciation,
    required this.errorType,
    required this.severity,
  });
}