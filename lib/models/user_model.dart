// lib/models/user_model.dart

enum UserType {
  student,
  hafiz,
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password; // تمت إضافته
  final UserType userType;
  final String phone; // الاسم الموحد هو phone
  final String? profileImage;
  final DateTime createdAt; // تمت إضافته
  final bool isVerified; // تمت إضافته

  // --- بيانات المحفظ ---
  final String? bio;
  final String? hafizCertificate;
  final int? yearsOfExperience;
  final double? sessionRate;
  final bool isAvailable;
  final List<String> specializations;
  final List<String> languages;
  final double rating;
  final int reviewCount;

  // --- إحصائيات (للطالب والمحفظ) ---
  final int sessionsCompleted;
  final List<int>? memorizedSurahs;
  final double? averageAccuracy;
  final int? totalSessionsAttended;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.userType,
    required this.phone,
    this.profileImage,
    required this.createdAt,
    this.isVerified = false,
    
    // المحفظ
    this.bio,
    this.hafizCertificate,
    this.yearsOfExperience,
    this.sessionRate,
    this.isAvailable = true,
    this.specializations = const [],
    this.languages = const ['العربية'],
    this.rating = 0.0,
    this.reviewCount = 0,
    
    // الإحصائيات
    this.sessionsCompleted = 0,
    this.memorizedSurahs,
    this.averageAccuracy,
    this.totalSessionsAttended,
  });

  // تحويل من JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '', // قراءة كلمة المرور
      userType: json['userType'] == 'UserType.hafiz' || json['userType'] == 'hafiz'
          ? UserType.hafiz
          : UserType.student,
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isVerified: json['isVerified'] == 1 || json['isVerified'] == true,
      
      bio: json['bio'],
      hafizCertificate: json['hafizCertificate'],
      yearsOfExperience: int.tryParse(json['yearsOfExperience'].toString()),
      sessionRate: double.tryParse(json['sessionRate'].toString()),
      isAvailable: json['isAvailable'] == 1 || json['isAvailable'] == true,
      
      specializations: json['specializations'] != null
          ? List<String>.from(json['specializations'])
          : [],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : ['العربية'],
          
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      sessionsCompleted: json['sessionsCompleted'] ?? 0,
      memorizedSurahs: json['memorizedSurahs'] != null
          ? List<int>.from(json['memorizedSurahs'])
          : null,
      averageAccuracy: (json['averageAccuracy'] ?? 0.0).toDouble(),
      totalSessionsAttended: json['totalSessionsAttended'],
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'userType': userType.toString().split('.').last,
      'phone': phone,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified ? 1 : 0,
      
      'bio': bio,
      'hafizCertificate': hafizCertificate,
      'yearsOfExperience': yearsOfExperience,
      'sessionRate': sessionRate,
      'isAvailable': isAvailable ? 1 : 0,
      'specializations': specializations,
      'languages': languages,
      'rating': rating,
      'reviewCount': reviewCount,
      
      'sessionsCompleted': sessionsCompleted,
      'memorizedSurahs': memorizedSurahs,
      'averageAccuracy': averageAccuracy,
      'totalSessionsAttended': totalSessionsAttended,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserType? userType,
    String? phone,
    String? profileImage,
    DateTime? createdAt,
    bool? isVerified,
    String? bio,
    String? hafizCertificate,
    int? yearsOfExperience,
    double? sessionRate,
    bool? isAvailable,
    List<String>? specializations,
    List<String>? languages,
    double? rating,
    int? reviewCount,
    int? sessionsCompleted,
    List<int>? memorizedSurahs,
    double? averageAccuracy,
    int? totalSessionsAttended,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      userType: userType ?? this.userType,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      bio: bio ?? this.bio,
      hafizCertificate: hafizCertificate ?? this.hafizCertificate,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      sessionRate: sessionRate ?? this.sessionRate,
      isAvailable: isAvailable ?? this.isAvailable,
      specializations: specializations ?? this.specializations,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      memorizedSurahs: memorizedSurahs ?? this.memorizedSurahs,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      totalSessionsAttended: totalSessionsAttended ?? this.totalSessionsAttended,
    );
  }
}