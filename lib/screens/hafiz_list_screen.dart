import 'package:flutter/material.dart';
import 'select_surah_screen.dart';
import '../models/user_model.dart';
import '../services/database_service.dart'; // تأكد من الاستيراد
import 'chat_screen.dart';

class HafizListScreen extends StatefulWidget {
  final UserModel currentUser;

  const HafizListScreen({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  @override
  State<HafizListScreen> createState() => _HafizListScreenState();
}

class _HafizListScreenState extends State<HafizListScreen> {
  final _searchController = TextEditingController();
  final _dbService = DatabaseService(); // إنشاء كائن قاعدة البيانات
  
  String _selectedFilter = 'الكل';
  bool _isLoading = true; // مؤشر التحميل
  List<UserModel> _allHafizList = []; // القائمة التي سنجلبها من الداتابيز

  @override
  void initState() {
    super.initState();
    _fetchHafizData(); // استدعاء دالة جلب البيانات عند البدء
  }

  // دالة لجلب البيانات من قاعدة البيانات
  Future<void> _fetchHafizData() async {
    setState(() => _isLoading = true);
    try {
      final hafizList = await _dbService.getAllHafiz();
      if (mounted) {
        setState(() {
          _allHafizList = hafizList;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching hafiz: $e");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // دالة الفلترة والبحث (تطبق على القائمة المجلوبة)
  List<UserModel> get _filteredHafizList {
    return _allHafizList.where((hafiz) {
      // 1. البحث بالاسم
      final matchesSearch = hafiz.name
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
      
      // 2. الفلترة حسب النوع
      bool matchesFilter = true;
      if (_selectedFilter == 'متاح الآن') {
        matchesFilter = hafiz.isAvailable;
      } else if (_selectedFilter == 'الأعلى تقييماً') {
        matchesFilter = (hafiz.rating) >= 4.5;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظون المتاحون'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن محفظ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (_) {
                setState(() {}); // إعادة بناء الشاشة عند الكتابة لتحديث النتائج
              },
            ),
          ),

          // فلاتر
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('الكل'),
                const SizedBox(width: 8),
                _buildFilterChip('متاح الآن'),
                const SizedBox(width: 8),
                _buildFilterChip('الأعلى تقييماً'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // قائمة المحفظين
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator()) // عرض مؤشر تحميل
                : _filteredHafizList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _allHafizList.isEmpty 
                                  ? 'لا يوجد محفظون مسجلون بعد' 
                                  : 'لا توجد نتائج تطابق بحثك',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator( // إمكانية السحب للتحديث
                        onRefresh: _fetchHafizData,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredHafizList.length,
                          itemBuilder: (context, index) {
                            final hafiz = _filteredHafizList[index];
                            return _buildHafizCard(context, hafiz);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedFilter = label;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildHafizCard(BuildContext context, UserModel hafiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة الرمزية (أو الصورة الشخصية إذا وجدت)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    image: hafiz.profileImage != null && hafiz.profileImage!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(hafiz.profileImage!), // يمكن تغييرها لـ FileImage إذا كانت محلية
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: hafiz.profileImage == null || hafiz.profileImage!.isEmpty
                      ? Center(
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),

                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hafiz.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // التقييم والجلسات
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${hafiz.rating.toStringAsFixed(1)} (${hafiz.reviewCount} تقييم)',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // الخبرة والتخصصات
                      if (hafiz.yearsOfExperience != null)
                        Text(
                          '${hafiz.yearsOfExperience} سنوات خبرة',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      if (hafiz.specializations.isNotEmpty)
                         Text(
                          hafiz.specializations.take(2).join('، '), // عرض أول تخصصين فقط
                          style: TextStyle(
                            fontSize: 11,
                            color: Theme.of(context).primaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),

                // حالة التواجد والسعر
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: hafiz.isAvailable 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        hafiz.isAvailable ? 'متاح' : 'مشغول',
                        style: TextStyle(
                          color: hafiz.isAvailable ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (hafiz.sessionRate != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        '${hafiz.sessionRate} ر.س/جلسة',
                         style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // الأزرار (محادثة و طلب تسميع)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            currentUser: widget.currentUser,
                            otherUser: hafiz,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                    label: const Text('محادثة'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: hafiz.isAvailable 
                        ? () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SelectSurahScreen(
                                  student: widget.currentUser,
                                  hafiz: hafiz,
                                ),
                              ),
                            );
                          }
                        : null, // تعطيل الزر إذا لم يكن متاحاً
                    icon: const Icon(Icons.videocam_outlined, size: 18),
                    label: const Text('طلب تسميع'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}