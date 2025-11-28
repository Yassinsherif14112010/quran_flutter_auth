import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/surahs_data.dart';

class QuranBrowserAdvanced extends StatefulWidget {
  const QuranBrowserAdvanced({Key? key}) : super(key: key);

  @override
  State<QuranBrowserAdvanced> createState() => _QuranBrowserAdvancedState();
}

class _QuranBrowserAdvancedState extends State<QuranBrowserAdvanced> {
  late AudioPlayer _audioPlayer;
  List<Surah> filteredSurahs = surahs;
  String searchQuery = '';
  String selectedReciter = 'عبد الباسط عبد الصمد';
  Surah? currentPlayingSurah;
  bool isPlaying = false;

  final List<String> reciters = [
    'عبد الباسط عبد الصمد',
    'محمود خليل الحصري',
    'عبد الرحمن السديس',
    'سعود الشريم',
    'ياسين الجزائري',
    'محمد صديق المنشاوي',
    'عماد زكي البارودي',
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _filterSurahs(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredSurahs = surahs;
      } else {
        filteredSurahs = searchSurahs(query);
      }
    });
  }

  Future<void> _playSurah(Surah surah) async {
    try {
      final url = surah.recitations[selectedReciter];
      if (url == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('لا توجد تلاوة لهذا الشيخ')),
        );
        return;
      }

      if (currentPlayingSurah?.number == surah.number && isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.setUrl(url);
        await _audioPlayer.play();
        setState(() {
          currentPlayingSurah = surah;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في التشغيل: $e')),
      );
    }
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
              onChanged: _filterSurahs,
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
                  'اختر المقرئ:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reciters.length,
                    itemBuilder: (context, index) {
                      final reciter = reciters[index];
                      final isSelected = selectedReciter == reciter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(reciter),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedReciter = reciter;
                            });
                          },
                          backgroundColor: Colors.grey[200],
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 12,
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
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لم يتم العثور على سور',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: filteredSurahs.length,
                    itemBuilder: (context, index) {
                      final surah = filteredSurahs[index];
                      final isCurrentPlaying =
                          currentPlayingSurah?.number == surah.number;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
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
                                '${surah.number}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            surah.nameArabic,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${surah.verses} آية • ${surah.revelation}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              color: isCurrentPlaying
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: Icon(
                                isCurrentPlaying && isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: isCurrentPlaying
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onPressed: () => _playSurah(surah),
                            ),
                          ),
                          onTap: () {
                            _showSurahDetails(surah);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showSurahDetails(Surah surah) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SurahDetailsSheet(
        surah: surah,
        selectedReciter: selectedReciter,
        onReciterChanged: (reciter) {
          setState(() {
            selectedReciter = reciter;
          });
          Navigator.pop(context);
        },
        onPlay: () {
          _playSurah(surah);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class SurahDetailsSheet extends StatelessWidget {
  final Surah surah;
  final String selectedReciter;
  final Function(String) onReciterChanged;
  final VoidCallback onPlay;

  const SurahDetailsSheet({
    Key? key,
    required this.surah,
    required this.selectedReciter,
    required this.onReciterChanged,
    required this.onPlay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final reciters = surah.recitations.keys.toList();

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // رأس الورقة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surah.nameArabic,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${surah.verses} آية • ${surah.revelation}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'السورة ${surah.number}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الوصف
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              surah.description,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),

          // اختيار المقرئ
          const Text(
            'اختر المقرئ:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: reciters.length,
              itemBuilder: (context, index) {
                final reciter = reciters[index];
                final isSelected = selectedReciter == reciter;

                return GestureDetector(
                  onTap: () => onReciterChanged(reciter),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color:
                              isSelected ? Colors.white : Colors.grey[600],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reciter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // زر التشغيل
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onPlay,
              icon: const Icon(Icons.play_arrow),
              label: const Text('استمع للسورة كاملة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
