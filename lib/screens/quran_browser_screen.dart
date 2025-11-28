import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/quran_data.dart';

class QuranBrowserScreen extends StatefulWidget {
  const QuranBrowserScreen({Key? key}) : super(key: key);

  @override
  State<QuranBrowserScreen> createState() => _QuranBrowserScreenState();
}

class _QuranBrowserScreenState extends State<QuranBrowserScreen> {
  late AudioPlayer _audioPlayer;
  String _searchQuery = '';
  String _selectedQari = 'alafasy';
  Surah? _currentPlayingSurah;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        _isPlaying = playerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  List<Surah> get filteredSurahs {
    if (_searchQuery.isEmpty) {
      return quranSurahs;
    }
    return quranSurahs
        .where((surah) =>
            surah.nameArabic.contains(_searchQuery) ||
            surah.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            surah.number.toString().contains(_searchQuery))
        .toList();
  }

  Future<void> _playSurah(Surah surah) async {
    try {
      final recitationUrl = surah.recitations[0]; // استخدم المقرئ الأول
      await _audioPlayer.setUrl(recitationUrl);
      await _audioPlayer.play();
      setState(() {
        _currentPlayingSurah = surah;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في تشغيل الصوت: $e')),
      );
    }
  }

  Future<void> _pauseSurah() async {
    await _audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('متصفح القرآن الكريم'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن سورة...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // اختيار المقرئ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر المقرئ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: qaris.length,
                    itemBuilder: (context, index) {
                      final qari = qaris[index];
                      final isSelected = _selectedQari == qari.id;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          selected: isSelected,
                          label: Text(qari.name),
                          onSelected: (selected) {
                            setState(() {
                              _selectedQari = qari.id;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Colors.blue,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // قائمة السور
          Expanded(
            child: filteredSurahs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لم يتم العثور على سور',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = filteredSurahs[index];
                      final isCurrentPlaying =
                          _currentPlayingSurah?.number == surah.number;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                surah.number.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            surah.nameArabic,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${surah.ayahCount} آية • ${surah.revelation}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: isCurrentPlaying
                              ? IconButton(
                                  onPressed: _isPlaying
                                      ? _pauseSurah
                                      : () => _playSurah(surah),
                                  icon: Icon(
                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.blue,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () => _playSurah(surah),
                                  icon: const Icon(Icons.play_arrow),
                                ),
                          onTap: () => _playSurah(surah),
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
