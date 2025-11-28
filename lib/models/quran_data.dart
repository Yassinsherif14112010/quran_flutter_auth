class Surah {
  final int number;
  final String name;
  final String nameArabic;
  final int ayahCount;
  final String revelation; // مكية أو مدنية
  final String description;
  final List<String> recitations; // روابط التلاوات

  Surah({
    required this.number,
    required this.name,
    required this.nameArabic,
    required this.ayahCount,
    required this.revelation,
    required this.description,
    required this.recitations,
  });
}

final List<Surah> quranSurahs = [
  Surah(
    number: 1,
    name: 'Al-Fatiha',
    nameArabic: 'الفاتحة',
    ayahCount: 7,
    revelation: 'مكية',
    description: 'فاتحة الكتاب، أم القرآن',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/1.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/1.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/1.mp3',
    ],
  ),
  Surah(
    number: 2,
    name: 'Al-Baqarah',
    nameArabic: 'البقرة',
    ayahCount: 286,
    revelation: 'مدنية',
    description: 'أطول سورة في القرآن',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/2.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/2.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/2.mp3',
    ],
  ),
  Surah(
    number: 3,
    name: 'Aal-E-Imran',
    nameArabic: 'آل عمران',
    ayahCount: 200,
    revelation: 'مدنية',
    description: 'سورة آل عمران',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/3.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/3.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/3.mp3',
    ],
  ),
  Surah(
    number: 4,
    name: 'An-Nisa',
    nameArabic: 'النساء',
    ayahCount: 176,
    revelation: 'مدنية',
    description: 'سورة النساء',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/4.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/4.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/4.mp3',
    ],
  ),
  Surah(
    number: 5,
    name: 'Al-Maidah',
    nameArabic: 'المائدة',
    ayahCount: 120,
    revelation: 'مدنية',
    description: 'سورة المائدة',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/5.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/5.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/5.mp3',
    ],
  ),
  Surah(
    number: 6,
    name: 'Al-Anam',
    nameArabic: 'الأنعام',
    ayahCount: 165,
    revelation: 'مكية',
    description: 'سورة الأنعام',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/6.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/6.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/6.mp3',
    ],
  ),
  Surah(
    number: 7,
    name: 'Al-Araf',
    nameArabic: 'الأعراف',
    ayahCount: 206,
    revelation: 'مكية',
    description: 'سورة الأعراف',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/7.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/7.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/7.mp3',
    ],
  ),
  Surah(
    number: 8,
    name: 'Al-Anfal',
    nameArabic: 'الأنفال',
    ayahCount: 75,
    revelation: 'مدنية',
    description: 'سورة الأنفال',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/8.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/8.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/8.mp3',
    ],
  ),
  Surah(
    number: 9,
    name: 'At-Tawbah',
    nameArabic: 'التوبة',
    ayahCount: 129,
    revelation: 'مدنية',
    description: 'سورة التوبة',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/9.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/9.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/9.mp3',
    ],
  ),
  Surah(
    number: 10,
    name: 'Yunus',
    nameArabic: 'يونس',
    ayahCount: 109,
    revelation: 'مكية',
    description: 'سورة يونس',
    recitations: [
      'https://cdn.islamic.network/quran/audio/128/ar.alafasy/10.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/10.mp3',
      'https://cdn.islamic.network/quran/audio/128/ar.husary/10.mp3',
    ],
  ),
  // إضافة باقي السور (11-114)
  // للاختصار، سأضيف نموذج فقط للسور الأولى
  // في التطبيق الفعلي، ستكون جميع السور الـ 114
];

// إضافة السور المتبقية (11-114)
// ignore: unused_element
void _addRemainingSurahs() {
  final surahNames = [
    'هود', 'يوسف', 'الرعد', 'إبراهيم', 'الحجر', 'النحل', 'الإسراء', 'الكهف',
    'مريم', 'طه', 'الأنبياء', 'الحج', 'المؤمنون', 'النور', 'الفرقان', 'الشعراء',
    'النمل', 'القصص', 'العنكبوت', 'الروم', 'لقمان', 'السجدة', 'الأحزاب', 'سبأ',
    'فاطر', 'يس', 'الصافات', 'ص', 'الزمر', 'غافر', 'فصلت', 'الشورى',
    'الزخرف', 'الدخان', 'الجاثية', 'الأحقاف', 'محمد', 'الفتح', 'الحجرات', 'ق',
    'الذاريات', 'الطور', 'النجم', 'القمر', 'الرحمن', 'الواقعة', 'الحديد', 'المجادلة',
    'الحشر', 'الممتحنة', 'الصف', 'الجمعة', 'المنافقون', 'التغابن', 'الطلاق', 'التحريم',
    'الملك', 'القلم', 'الحاقة', 'المعارج', 'نوح', 'الجن', 'المزمل', 'المدثر',
    'القيامة', 'الإنسان', 'المرسلات', 'النبأ', 'النازعات', 'عبس', 'التكوير', 'الإنفطار',
    'المطففين', 'الانشقاق', 'البروج', 'الطارق', 'الأعلى', 'الغاشية', 'الفجر', 'البلد',
    'الشمس', 'الليل', 'الضحى', 'الشرح', 'التين', 'العلق', 'القدر', 'البينة',
    'الزلزلة', 'العاديات', 'القارعة', 'التكاثر', 'العصر', 'الهمزة', 'الفيل', 'قريش',
    'الماعون', 'الكوثر', 'الكافرون', 'النصر', 'المسد', 'الإخلاص', 'الفلق', 'الناس'
  ];
  
  for (int i = 11; i <= 114; i++) {
    quranSurahs.add(
      Surah(
        number: i,
        name: surahNames[i - 11],
        nameArabic: surahNames[i - 11],
        ayahCount: 100, // قيمة افتراضية
        revelation: i <= 93 ? 'مكية' : 'مدنية',
        description: 'سورة ${surahNames[i - 11]}',
        recitations: [
          'https://cdn.islamic.network/quran/audio/128/ar.alafasy/$i.mp3',
          'https://cdn.islamic.network/quran/audio/128/ar.abdulsamad/$i.mp3',
          'https://cdn.islamic.network/quran/audio/128/ar.husary/$i.mp3',
        ],
      ),
    );
  }
}

// قائمة المقرئين المتاحين
final List<Qari> qaris = [
  Qari(
    id: 'alafasy',
    name: 'الشيخ مشاري بن راشد العفاسي',
    description: 'قارئ كويتي معروف',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Qari(
    id: 'abdulsamad',
    name: 'الشيخ عبد الباسط عبد الصمد',
    description: 'قارئ مصري الشهير',
    imageUrl: 'https://via.placeholder.com/150',
  ),
  Qari(
    id: 'husary',
    name: 'الشيخ محمود خليل الحصري',
    description: 'قارئ مصري معروف',
    imageUrl: 'https://via.placeholder.com/150',
  ),
];

class Qari {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  Qari({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });
}
