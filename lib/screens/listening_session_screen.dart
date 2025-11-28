import 'dart:io'; // 1. استيراد مكتبة IO للتعامل مع الملفات
import 'package:flutter/material.dart';
import 'package:record/record.dart'; // مكتبة التسجيل
import 'package:audioplayers/audioplayers.dart'; // مكتبة التشغيل
import 'package:path_provider/path_provider.dart'; // 2. لتحديد مسار الحفظ
import '../models/user_model.dart';

class ListeningSessionScreen extends StatefulWidget {
  final UserModel student;
  final UserModel hafiz;
  final String surahName;
  final int surahNumber;

  const ListeningSessionScreen({
    Key? key,
    required this.student,
    required this.hafiz,
    required this.surahName,
    required this.surahNumber,
  }) : super(key: key);

  @override
  State<ListeningSessionScreen> createState() => _ListeningSessionScreenState();
}

class _ListeningSessionScreenState extends State<ListeningSessionScreen> {
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  
  bool _isRecording = false;
  bool _isPlayingStudent = false;
  bool _isPlayingHafiz = false;
  
  String? _studentRecordingPath;
  // ignore: unused_field
  String? _hafizRecordingPath; // لم تستخدم بعد، يمكن حذفها أو استخدامها لاحقاً
  
  Duration _recordingDuration = Duration.zero;
  Duration _studentPlaybackDuration = Duration.zero;
  // ignore: unused_field
  Duration _hafizPlaybackDuration = Duration.zero; // لم تستخدم بعد

  List<String> _errors = [];
  List<String> _corrections = [];
  double _accuracy = 0;
  
  bool _isAnalyzing = false;
  bool _sessionCompleted = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder(); // 4. تهيئة AudioRecorder
    _audioPlayer = AudioPlayer();
    
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _studentPlaybackDuration = duration;
        });
      }
    });
    
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _studentPlaybackDuration = position;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlayingStudent = false;
          _isPlayingHafiz = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioRecorder.dispose(); // 5. تحرير الموارد بشكل صحيح
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      // 6. التحقق من الأذونات
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        // 7. بدء التسجيل مع تحديد المسار ونوع التشفير
        const config = RecordConfig(encoder: AudioEncoder.aacLc); 
        await _audioRecorder.start(config, path: path);
        
        setState(() {
          _isRecording = true;
          _recordingDuration = Duration.zero;
          _studentRecordingPath = path; // حفظ المسار المتوقع
        });
        
        // محاكاة عداد الوقت (بسيط)
        // في التطبيق الحقيقي يفضل استخدام Timer
        Future.delayed(const Duration(seconds: 1), () {
          if (_isRecording && mounted) {
            setState(() {
              _recordingDuration = const Duration(seconds: 1);
            });
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في بدء التسجيل: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    try {
      // 8. إيقاف التسجيل والحصول على المسار
      final path = await _audioRecorder.stop();
      
      setState(() {
        _isRecording = false;
        _studentRecordingPath = path;
      });
      
      // بدء التحليل
      if (path != null) {
        _analyzeRecording();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في إيقاف التسجيل: $e')),
        );
      }
    }
  }

  void _analyzeRecording() {
    setState(() {
      _isAnalyzing = true;
      _errors = [];
      _corrections = [];
      _accuracy = 0;
    });
    
    // محاكاة التحليل
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _accuracy = 85.5;
          _errors = [
            'كلمة "الرحمن" - نطق غير صحيح',
            'آية 5 - توقف طويل غير مناسب',
            'تشكيل "الميم" - غير واضح',
          ];
          _corrections = [
            'الرحمن: يُنطق بفتح الراء وضم الحاء',
            'تجنب التوقفات الطويلة بين الكلمات',
            'وضح نطق الحروف الساكنة',
          ];
        });
      }
    });
  }

  Future<void> _playStudentRecording() async {
    if (_studentRecordingPath == null) return;
    
    try {
      if (_isPlayingStudent) {
        await _audioPlayer.pause();
        setState(() {
          _isPlayingStudent = false;
        });
      } else {
        // 9. استخدام DeviceFileSource للملفات المحلية
        await _audioPlayer.play(DeviceFileSource(_studentRecordingPath!));
        setState(() {
          _isPlayingStudent = true;
          _isPlayingHafiz = false; // إيقاف أي صوت آخر
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في التشغيل: $e')),
        );
      }
    }
  }

  void _playHafizCorrection() {
    setState(() {
      _isPlayingHafiz = !_isPlayingHafiz;
      _isPlayingStudent = false; // إيقاف تسجيل الطالب
    });
    
    if (_isPlayingHafiz) {
      // محاكاة
      Future.delayed(const Duration(seconds: 5), () {
        if (mounted && _isPlayingHafiz) {
          setState(() {
            _isPlayingHafiz = false;
          });
        }
      });
    }
  }

  void _completeSession() {
    setState(() {
      _sessionCompleted = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ الجلسة بنجاح')),
    );
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسميع ${widget.surahName}'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // معلومات الجلسة (Student Info)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.school)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.student.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'الطالب',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.menu_book)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.hafiz.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'المحفظ',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // قسم التسجيل والتحكم
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'تسجيل الطالب',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    
                    if (!_sessionCompleted)
                      Center(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _isRecording ? _stopRecording : _startRecording,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isRecording ? Colors.red : Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isRecording ? Colors.red : Theme.of(context).primaryColor)
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isRecording ? Icons.stop : Icons.mic,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _isRecording ? 'جاري التسجيل...' : 'اضغط للتسجيل',
                              style: TextStyle(
                                fontSize: 16,
                                color: _isRecording ? Colors.red : Colors.grey[600],
                              ),
                            ),
                            if (_isRecording)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  '${_recordingDuration.inSeconds}s',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                    // تشغيل التسجيل
                    if (_studentRecordingPath != null && !_isAnalyzing)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _playStudentRecording,
                              icon: Icon(_isPlayingStudent ? Icons.pause : Icons.play_arrow),
                              label: Text(_isPlayingStudent ? 'إيقاف التشغيل' : 'تشغيل التسجيل'),
                            ),
                            const SizedBox(height: 12),
                            // هنا يمكنك إضافة شريط تقدم التشغيل الحقيقي إذا أردت
                          ],
                        ),
                      ),

                    // مؤشر التحليل
                    if (_isAnalyzing)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('جاري تحليل التسجيل...'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // عرض النتائج
            if (_accuracy > 0 && !_isAnalyzing)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // نسبة الدقة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'نسبة الدقة',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _accuracy >= 80 ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${_accuracy.toStringAsFixed(1)}%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: _accuracy >= 80 ? Colors.green : Colors.orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // الأخطاء
                      if (_errors.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'الأخطاء المكتشفة:',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            ..._errors.map((error) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, size: 20, color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(error, style: const TextStyle(fontSize: 13))),
                                ],
                              ),
                            )),
                            const SizedBox(height: 16),
                          ],
                        ),

                      // التصحيحات
                      if (_corrections.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'التصحيحات:',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                            ),
                            const SizedBox(height: 8),
                            ..._corrections.map((correction) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(correction, style: const TextStyle(fontSize: 13))),
                                ],
                              ),
                            )),
                          ],
                        ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // تصحيح المحفظ (محاكاة)
            if (_accuracy > 0 && !_isAnalyzing)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('تصحيح المحفظ', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _playHafizCorrection,
                        icon: Icon(_isPlayingHafiz ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlayingHafiz ? 'إيقاف' : 'استمع لتصحيح المحفظ'),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // زر الإنهاء
            if (_accuracy > 0 && !_isAnalyzing)
              ElevatedButton(
                onPressed: _completeSession,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'إنهاء الجلسة',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}