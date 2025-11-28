import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
  final List<Resource> resources = [
    // تلاوات كاملة
    Resource(
      title: 'تلاوة الشيخ عبد الباسط عبد الصمد',
      description: 'تلاوة كاملة للقرآن الكريم - جودة عالية',
      category: 'تلاوات',
      size: '2.5 GB',
      downloads: 15420,
      url: 'https://example.com/abdulbasit-complete.zip',
      icon: Icons.music_note,
      color: Colors.blue,
    ),
    Resource(
      title: 'تلاوة الشيخ محمود خليل الحصري',
      description: 'تلاوة مرتلة - صوت جميل وواضح',
      category: 'تلاوات',
      size: '2.3 GB',
      downloads: 12350,
      url: 'https://example.com/husary-complete.zip',
      icon: Icons.music_note,
      color: Colors.purple,
    ),
    Resource(
      title: 'تلاوة الشيخ عبد الرحمن السديس',
      description: 'تلاوة معاصرة - جودة استوديو',
      category: 'تلاوات',
      size: '2.1 GB',
      downloads: 9870,
      url: 'https://example.com/sudais-complete.zip',
      icon: Icons.music_note,
      color: Colors.green,
    ),
    
    // نصوص وكتب
    Resource(
      title: 'القرآن الكريم - نص كامل',
      description: 'نص القرآن الكريم بصيغة PDF',
      category: 'نصوص',
      size: '15 MB',
      downloads: 28450,
      url: 'https://example.com/quran-text.pdf',
      icon: Icons.description,
      color: Colors.orange,
    ),
    Resource(
      title: 'تفسير ابن كثير',
      description: 'تفسير شامل للقرآن الكريم',
      category: 'تفاسير',
      size: '45 MB',
      downloads: 18920,
      url: 'https://example.com/tafsir-ibn-kathir.pdf',
      icon: Icons.book,
      color: Colors.red,
    ),
    Resource(
      title: 'أحكام التجويد',
      description: 'شرح مفصل لقواعد التجويد',
      category: 'تجويد',
      size: '8 MB',
      downloads: 12340,
      url: 'https://example.com/tajweed-rules.pdf',
      icon: Icons.school,
      color: Colors.teal,
    ),
    
    // تطبيقات
    Resource(
      title: 'تطبيق قارئ القرآن',
      description: 'تطبيق متقدم لقراءة القرآن',
      category: 'تطبيقات',
      size: '45 MB',
      downloads: 34560,
      url: 'https://example.com/quran-reader-app.apk',
      icon: Icons.apps,
      color: Colors.indigo,
    ),
    Resource(
      title: 'تطبيق أوقات الصلاة',
      description: 'تطبيق دقيق لأوقات الصلاة',
      category: 'تطبيقات',
      size: '12 MB',
      downloads: 45670,
      url: 'https://example.com/prayer-times-app.apk',
      icon: Icons.apps,
      color: Colors.pink,
    ),
  ];

  late List<Resource> filteredResources;
  String selectedCategory = 'الكل';

  @override
  void initState() {
    super.initState();
    filteredResources = resources;
  }

  void filterByCategory(String category) {
    setState(() {
      selectedCategory = category;
      if (category == 'الكل') {
        filteredResources = resources;
      } else {
        filteredResources = resources
            .where((r) => r.category == category)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['الكل', 'تلاوات', 'نصوص', 'تفاسير', 'تجويد', 'تطبيقات'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الموارد والتحميلات'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // فئات التصفية
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) => filterByCategory(category),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Theme.of(context).primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),

            // قائمة الموارد
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredResources.length,
                itemBuilder: (context, index) {
                  final resource = filteredResources[index];
                  return _buildResourceCard(resource);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceCard(Resource resource) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: resource.color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    resource.icon,
                    color: resource.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resource.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resource.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(resource.category),
                  backgroundColor: resource.color.withOpacity(0.2),
                  labelStyle: TextStyle(color: resource.color),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(resource.size),
                  backgroundColor: Colors.grey[200],
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 8),
                Icon(Icons.download, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${resource.downloads}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _downloadResource(resource),
                icon: const Icon(Icons.download),
                label: const Text('تحميل'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: resource.color,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadResource(Resource resource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحميل الملف'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الملف: ${resource.title}'),
            const SizedBox(height: 8),
            Text('الحجم: ${resource.size}'),
            const SizedBox(height: 8),
            const Text('سيتم فتح الملف في المتصفح'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              if (await canLaunchUrl(Uri.parse(resource.url))) {
                await launchUrl(Uri.parse(resource.url));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('لا يمكن فتح الرابط')),
                );
              }
            },
            child: const Text('تحميل'),
          ),
        ],
      ),
    );
  }
}

class Resource {
  final String title;
  final String description;
  final String category;
  final String size;
  final int downloads;
  final String url;
  final IconData icon;
  final Color color;

  Resource({
    required this.title,
    required this.description,
    required this.category,
    required this.size,
    required this.downloads,
    required this.url,
    required this.icon,
    required this.color,
  });
}