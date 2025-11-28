import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'listening_session_screen.dart';

class SelectSurahScreen extends StatefulWidget {
  final UserModel student;
  final UserModel hafiz;

  const SelectSurahScreen({
    Key? key,
    required this.student,
    required this.hafiz,
  }) : super(key: key);

  @override
  State<SelectSurahScreen> createState() => _SelectSurahScreenState();
}

class _SelectSurahScreenState extends State<SelectSurahScreen> {
  final List<Map<String, dynamic>> surahs = [
    {'number': 1, 'name': 'الفاتحة', 'ayahs': 7},
    {'number': 2, 'name': 'البقرة', 'ayahs': 286},
    {'number': 3, 'name': 'آل عمران', 'ayahs': 200},
    {'number': 4, 'name': 'النساء', 'ayahs': 176},
    {'number': 5, 'name': 'المائدة', 'ayahs': 120},
    {'number': 6, 'name': 'الأنعام', 'ayahs': 165},
    {'number': 7, 'name': 'الأعراف', 'ayahs': 206},
    {'number': 8, 'name': 'الأنفال', 'ayahs': 75},
    {'number': 9, 'name': 'التوبة', 'ayahs': 129},
    {'number': 10, 'name': 'يونس', 'ayahs': 109},
    {'number': 11, 'name': 'هود', 'ayahs': 123},
    {'number': 12, 'name': 'يوسف', 'ayahs': 111},
    {'number': 13, 'name': 'الرعد', 'ayahs': 43},
    {'number': 14, 'name': 'إبراهيم', 'ayahs': 52},
    {'number': 15, 'name': 'الحجر', 'ayahs': 99},
    {'number': 16, 'name': 'النحل', 'ayahs': 128},
    {'number': 17, 'name': 'الإسراء', 'ayahs': 111},
    {'number': 18, 'name': 'الكهف', 'ayahs': 110},
    {'number': 19, 'name': 'مريم', 'ayahs': 98},
    {'number': 20, 'name': 'طه', 'ayahs': 135},
  ];

  String _searchQuery = '';
  late List<Map<String, dynamic>> _filteredSurahs;

  @override
  void initState() {
    super.initState();
    _filteredSurahs = surahs;
  }

  void _filterSurahs(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredSurahs = surahs;
      } else {
        _filteredSurahs = surahs
            .where((surah) =>
                surah['name'].contains(query) ||
                surah['number'].toString().contains(query))
            .toList();
      }
    });
  }

  void _startSession(Map<String, dynamic> surah) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ListeningSessionScreen(
          student: widget.student,
          hafiz: widget.hafiz,
          surahName: surah['name'],
          surahNumber: surah['number'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر السورة'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // بطاقة المحفظ
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.menu_book),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hafiz.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.hafiz.rating ?? 4.8}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.school,
                            size: 16,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.hafiz.yearsOfExperience ?? 5} سنوات',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // حقل البحث
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: _filterSurahs,
              decoration: InputDecoration(
                hintText: 'ابحث عن السورة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),

          // قائمة السور
          Expanded(
            child: _filteredSurahs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'لم يتم العثور على سور',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = _filteredSurahs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                surah['number'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            surah['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${surah['ayahs']} آية',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey[400],
                          ),
                          onTap: () => _startSession(surah),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
