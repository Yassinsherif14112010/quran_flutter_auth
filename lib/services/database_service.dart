import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'quran_memorization.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // 1. جدول المستخدمين
    // تمت إضافة عمود password هنا
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL, -- تمت الإضافة
        userType TEXT NOT NULL,
        phone TEXT,
        profileImage TEXT,
        createdAt TEXT NOT NULL,
        isVerified INTEGER NOT NULL DEFAULT 0, -- تمت الإضافة
        
        -- بيانات المحفظ الإضافية
        bio TEXT,
        hafizCertificate TEXT,
        yearsOfExperience INTEGER,
        sessionRate REAL,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        specializations TEXT, 
        languages TEXT,
        rating REAL,
        reviewCount INTEGER DEFAULT 0,
        
        -- إحصائيات
        sessionsCompleted INTEGER DEFAULT 0,
        memorizedSurahs TEXT,
        averageAccuracy REAL,
        totalSessionsAttended INTEGER DEFAULT 0
      )
    ''');

    // 2. جدول جلسات التسميع
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        studentId TEXT NOT NULL,
        hafizId TEXT,
        surahNumber INTEGER NOT NULL,
        surahName TEXT NOT NULL,
        startVerse INTEGER NOT NULL,
        endVerse INTEGER NOT NULL,
        sessionDate TEXT NOT NULL,
        sessionDuration INTEGER NOT NULL,
        accuracy REAL NOT NULL,
        status TEXT NOT NULL,
        audioPath TEXT,
        errors TEXT NOT NULL,
        notes TEXT,
        rating REAL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        FOREIGN KEY (studentId) REFERENCES users(id),
        FOREIGN KEY (hafizId) REFERENCES users(id)
      )
    ''');

    // 3. جدول الإحصائيات
    await db.execute('''
      CREATE TABLE statistics (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL UNIQUE,
        totalSessions INTEGER NOT NULL DEFAULT 0,
        totalAccuracy REAL NOT NULL DEFAULT 0,
        memorizedSurahs INTEGER NOT NULL DEFAULT 0,
        totalDuration INTEGER NOT NULL DEFAULT 0,
        lastSessionDate TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
    ''');
  }

  // ============ عمليات المستخدمين ============

  Future<void> saveUser(UserModel user) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'id': user.id,
        'name': user.name,
        'email': user.email,
        'password': user.password, // تم تفعيل حفظ كلمة المرور
        'userType': user.userType.toString().split('.').last,
        'phone': user.phone,
        'profileImage': user.profileImage,
        'createdAt': user.createdAt.toIso8601String(),
        'isVerified': user.isVerified ? 1 : 0, // تحويل bool إلى int
        
        // الحقول الجديدة
        'bio': user.bio,
        'hafizCertificate': user.hafizCertificate,
        'yearsOfExperience': user.yearsOfExperience,
        'sessionRate': user.sessionRate,
        'isAvailable': user.isAvailable ? 1 : 0,
        'specializations': jsonEncode(user.specializations),
        'languages': jsonEncode(user.languages),
        'rating': user.rating,
        'reviewCount': user.reviewCount,
        
        // إحصائيات
        'sessionsCompleted': user.sessionsCompleted,
        'memorizedSurahs': user.memorizedSurahs != null ? jsonEncode(user.memorizedSurahs) : null,
        'averageAccuracy': user.averageAccuracy,
        'totalSessionsAttended': user.totalSessionsAttended,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) return null;
    return _mapToUser(result.first);
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isEmpty) return null;
    return _mapToUser(result.first);
  }

  Future<List<UserModel>> getAllHafiz() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'userType = ?',
      whereArgs: ['hafiz'],
      orderBy: 'rating DESC',
    );

    if (result.isEmpty) return [];

    return result.map((map) => _mapToUser(map)).toList();
  }

  Future<void> updateUser(UserModel user) async {
    final db = await database;
    await db.update(
      'users',
      {
        'name': user.name,
        'phone': user.phone,
        'profileImage': user.profileImage,
        'bio': user.bio,
        'hafizCertificate': user.hafizCertificate,
        'yearsOfExperience': user.yearsOfExperience,
        'sessionRate': user.sessionRate,
        'isAvailable': user.isAvailable ? 1 : 0,
        'specializations': jsonEncode(user.specializations),
        'languages': jsonEncode(user.languages),
        'rating': user.rating,
        'reviewCount': user.reviewCount,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // تم إصلاح هذه الدالة لتشمل password و createdAt
  UserModel _mapToUser(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'], // القراءة من قاعدة البيانات
      userType: map['userType'] == 'hafiz' ? UserType.hafiz : UserType.student,
      phone: map['phone'],
      profileImage: map['profileImage'],
      createdAt: DateTime.parse(map['createdAt']), // تحويل النص إلى تاريخ
      isVerified: map['isVerified'] == 1, // تحويل الرقم إلى bool
      
      bio: map['bio'],
      hafizCertificate: map['hafizCertificate'],
      yearsOfExperience: map['yearsOfExperience'],
      sessionRate: map['sessionRate'],
      isAvailable: map['isAvailable'] == 1,
      
      specializations: map['specializations'] != null
          ? List<String>.from(jsonDecode(map['specializations']))
          : [],
      languages: map['languages'] != null
          ? List<String>.from(jsonDecode(map['languages']))
          : ['العربية'],
          
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      sessionsCompleted: map['sessionsCompleted'] ?? 0,
      memorizedSurahs: map['memorizedSurahs'] != null
          ? List<int>.from(jsonDecode(map['memorizedSurahs']))
          : null,
      averageAccuracy: (map['averageAccuracy'] ?? 0.0).toDouble(),
      totalSessionsAttended: map['totalSessionsAttended'],
    );
  }

  // ============ عمليات الجلسات ============

  Future<void> saveSession(SessionModel session) async {
    final db = await database;
    await db.insert(
      'sessions',
      {
        'id': session.id,
        'studentId': session.studentId,
        'hafizId': session.hafizId,
        'surahNumber': session.surahNumber,
        'surahName': session.surahName,
        'startVerse': session.startVerse,
        'endVerse': session.endVerse,
        'sessionDate': session.sessionDate.toIso8601String(),
        'sessionDuration': session.sessionDuration.inSeconds,
        'accuracy': session.accuracy,
        'status': session.status.toString(),
        'audioPath': session.audioPath,
        'errors': jsonEncode(
          session.errors.map((e) => e.toJson()).toList(),
        ),
        'notes': session.notes,
        'rating': session.rating,
        'createdAt': session.createdAt.toIso8601String(),
        'updatedAt': session.updatedAt?.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await _updateStatistics(session.studentId);
  }

  Future<List<SessionModel>> getSessionsByUserId(String userId) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'studentId = ?',
      whereArgs: [userId],
      orderBy: 'sessionDate DESC',
    );

    return result.map((map) => _mapToSession(map)).toList();
  }

  SessionModel _mapToSession(Map<String, dynamic> map) {
    final errorsList = jsonDecode(map['errors']) as List;
    final errors = errorsList
        .map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
        .toList();

    return SessionModel(
      id: map['id'],
      studentId: map['studentId'],
      hafizId: map['hafizId'],
      surahNumber: map['surahNumber'],
      surahName: map['surahName'],
      startVerse: map['startVerse'],
      endVerse: map['endVerse'],
      sessionDate: DateTime.parse(map['sessionDate']),
      sessionDuration: Duration(seconds: map['sessionDuration']),
      accuracy: map['accuracy'],
      status: _parseStatus(map['status']),
      audioPath: map['audioPath'],
      errors: errors,
      notes: map['notes'],
      rating: map['rating'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : null,
    );
  }

  SessionStatus _parseStatus(String status) {
    if (status.contains('completed')) return SessionStatus.completed;
    if (status.contains('inProgress')) return SessionStatus.inProgress;
    return SessionStatus.pending;
  }

  // ============ عمليات الإحصائيات ============

  Future<void> _updateStatistics(String userId) async {
    final db = await database;
    final sessions = await getSessionsByUserId(userId);

    if (sessions.isEmpty) return;

    final totalSessions = sessions.length;
    final totalAccuracy = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(0, (sum, s) => sum + s.accuracy) /
            sessions.length;
    final totalDuration = sessions.fold<int>(
      0,
      (sum, s) => sum + s.sessionDuration.inSeconds,
    );

    final lastSessionDate =
        sessions.isNotEmpty ? sessions.first.sessionDate : null;

    await db.insert(
      'statistics',
      {
        'id': userId,
        'userId': userId,
        'totalSessions': totalSessions,
        'totalAccuracy': totalAccuracy,
        'memorizedSurahs': _countMemorizedSurahs(sessions),
        'totalDuration': totalDuration,
        'lastSessionDate': lastSessionDate?.toIso8601String(),
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  int _countMemorizedSurahs(List<SessionModel> sessions) {
    final memorized = <int>{};
    for (final session in sessions) {
      if (session.accuracy >= 90) {
        memorized.add(session.surahNumber);
      }
    }
    return memorized.length;
  }

  Future<Map<String, dynamic>?> getStatistics(String userId) async {
    final db = await database;
    final result = await db.query(
      'statistics',
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return result.isNotEmpty ? result.first : null;
  }

  // حذف قاعدة البيانات
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'quran_memorization.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}