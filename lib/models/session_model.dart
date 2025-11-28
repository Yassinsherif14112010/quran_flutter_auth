import 'package:flutter/material.dart'; // 1. تمت إضافة هذا السطر لتعريف الألوان

class SessionModel {
  final String id;
  final String studentId;
  final String? hafizId;
  final int surahNumber;
  final String surahName;
  final int startVerse;
  final int endVerse;
  final DateTime sessionDate;
  final Duration sessionDuration;
  final double accuracy;
  final SessionStatus status;
  final String? audioPath;
  final List<ErrorDetail> errors;
  final String? notes;
  final double? rating;
  final DateTime createdAt;
  final DateTime? updatedAt;

  SessionModel({
    required this.id,
    required this.studentId,
    this.hafizId,
    required this.surahNumber,
    required this.surahName,
    required this.startVerse,
    required this.endVerse,
    required this.sessionDate,
    required this.sessionDuration,
    required this.accuracy,
    required this.status,
    this.audioPath,
    required this.errors,
    this.notes,
    this.rating,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'hafizId': hafizId,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'startVerse': startVerse,
      'endVerse': endVerse,
      'sessionDate': sessionDate.toIso8601String(),
      'sessionDuration': sessionDuration.inSeconds,
      'accuracy': accuracy,
      'status': status.toString(),
      'audioPath': audioPath,
      'errors': errors.map((e) => e.toJson()).toList(),
      'notes': notes,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      hafizId: json['hafizId'] as String?,
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      startVerse: json['startVerse'] as int,
      endVerse: json['endVerse'] as int,
      sessionDate: DateTime.parse(json['sessionDate'] as String),
      sessionDuration: Duration(seconds: json['sessionDuration'] as int),
      accuracy: (json['accuracy'] as num).toDouble(),
      status: _parseStatus(json['status'] as String),
      audioPath: json['audioPath'] as String?,
      errors: (json['errors'] as List?)
              ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notes: json['notes'] as String?,
      rating: (json['rating'] as num?)?.toDouble(), // تحسين لتحويل الأرقام بأمان
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  static SessionStatus _parseStatus(String status) {
    switch (status) {
      case 'SessionStatus.completed':
        return SessionStatus.completed;
      case 'SessionStatus.pending':
        return SessionStatus.pending;
      case 'SessionStatus.inProgress':
        return SessionStatus.inProgress;
      default:
        return SessionStatus.completed;
    }
  }

  SessionModel copyWith({
    String? id,
    String? studentId,
    String? hafizId,
    int? surahNumber,
    String? surahName,
    int? startVerse,
    int? endVerse,
    DateTime? sessionDate,
    Duration? sessionDuration,
    double? accuracy,
    SessionStatus? status,
    String? audioPath,
    List<ErrorDetail>? errors,
    String? notes,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      hafizId: hafizId ?? this.hafizId,
      surahNumber: surahNumber ?? this.surahNumber,
      surahName: surahName ?? this.surahName,
      startVerse: startVerse ?? this.startVerse,
      endVerse: endVerse ?? this.endVerse,
      sessionDate: sessionDate ?? this.sessionDate,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      accuracy: accuracy ?? this.accuracy,
      status: status ?? this.status,
      audioPath: audioPath ?? this.audioPath,
      errors: errors ?? this.errors,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ErrorDetail {
  final String word;
  final String correctWord;
  final ErrorType errorType;
  final int position;
  final String? suggestion;

  ErrorDetail({
    required this.word,
    required this.correctWord,
    required this.errorType,
    required this.position,
    this.suggestion,
  });

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'correctWord': correctWord,
      'errorType': errorType.toString(),
      'position': position,
      'suggestion': suggestion,
    };
  }

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      word: json['word'] as String,
      correctWord: json['correctWord'] as String,
      errorType: _parseErrorType(json['errorType'] as String),
      position: json['position'] as int,
      suggestion: json['suggestion'] as String?,
    );
  }

  static ErrorType _parseErrorType(String type) {
    switch (type) {
      case 'ErrorType.pronunciation':
        return ErrorType.pronunciation;
      case 'ErrorType.tajweed':
        return ErrorType.tajweed;
      case 'ErrorType.missing':
        return ErrorType.missing;
      case 'ErrorType.extra':
        return ErrorType.extra;
      default:
        return ErrorType.pronunciation;
    }
  }
}

enum SessionStatus {
  pending,
  inProgress,
  completed,
}

enum ErrorType {
  pronunciation,
  tajweed,
  missing,
  extra,
}

extension ErrorTypeExtension on ErrorType {
  String get displayName {
    switch (this) {
      case ErrorType.pronunciation:
        return 'خطأ في النطق';
      case ErrorType.tajweed:
        return 'خطأ في التجويد';
      case ErrorType.missing:
        return 'كلمة ناقصة';
      case ErrorType.extra:
        return 'كلمة زائدة';
    }
  }

  Color get color {
    switch (this) {
      case ErrorType.pronunciation:
        return const Color(0xFFFF9800); // برتقالي
      case ErrorType.tajweed:
        return const Color(0xFF2196F3); // أزرق
      case ErrorType.missing:
        return const Color(0xFFF44336); // أحمر
      case ErrorType.extra:
        return const Color(0xFF9C27B0); // بنفسجي
    }
  }
}