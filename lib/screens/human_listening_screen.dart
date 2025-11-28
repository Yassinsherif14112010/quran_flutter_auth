import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1. المزود (Provider)
class HafizProvider extends ChangeNotifier {
  // القائمة
  List<Hafiz> _hafizes = [];

  List<Hafiz> get hafizes => _hafizes;

  // دالة الإضافة
  void addHafiz(Hafiz hafiz) {
    _hafizes.add(hafiz);
    notifyListeners();
  }

  // --- (جديد) دالة الحذف ---
  void removeHafiz(Hafiz hafiz) {
    _hafizes.remove(hafiz);
    notifyListeners();
  }
}

// 2. شاشة التسجيل (كما هي)
class HafizRegistrationScreen extends StatefulWidget {
  const HafizRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<HafizRegistrationScreen> createState() => _HafizRegistrationScreenState();
}

class _HafizRegistrationScreenState extends State<HafizRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  String _name = '';
  String _specialization = '';
  int _experience = 0;
  int _price = 0;
  String _availability = 'متاح الآن';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل محفظ جديد')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'اسم المحفظ', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(labelText: 'التخصص (مثلاً: تجويد)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                onSaved: (value) => _specialization = value!,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'سنوات الخبرة', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _experience = int.parse(value ?? '0'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: 'السعر للجلسة', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _price = int.parse(value ?? '0'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _availability,
                decoration: const InputDecoration(labelText: 'الحالة', border: OutlineInputBorder()),
                items: ['متاح الآن', 'متاح غداً', 'مشغول حالياً']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _availability = val!),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('إضافة المحفظ للقائمة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      final newHafiz = Hafiz(
        id: DateTime.now().millisecondsSinceEpoch,
        name: _name,
        specialization: _specialization,
        experience: _experience,
        rating: 5.0,
        reviews: 0,
        languages: ['العربية'],
        availability: _availability,
        image: '👨‍🏫',
        price: _price,
      );

      Provider.of<HafizProvider>(context, listen: false).addHafiz(newHafiz);

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المحفظ بنجاح!'), backgroundColor: Colors.green),
      );
    }
  }
}

// 3. الشاشة الرئيسية
class HumanListeningScreen extends StatefulWidget {
  const HumanListeningScreen({Key? key}) : super(key: key);

  @override
  State<HumanListeningScreen> createState() => _HumanListeningScreenState();
}

class _HumanListeningScreenState extends State<HumanListeningScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('التسميع البشري'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'تسجيل كمحفظ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HafizRegistrationScreen()),
                );
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المحفظون المتاحون'),
              Tab(text: 'طلباتي'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildHafizesTab(),
            _buildMyRequestsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildHafizesTab() {
    return Consumer<HafizProvider>(
      builder: (context, provider, child) {
        final hafizes = provider.hafizes;
        
        if (hafizes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('لا يوجد محفظون متاحون حالياً'),
                Text('اضغط على أيقونة الإضافة بالأعلى لتسجيل محفظ', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: hafizes.length,
          itemBuilder: (context, index) {
            final hafiz = hafizes[index];
            // تمرير الـ index أو الكائن للحذف
            return _buildHafizCard(hafiz, context);
          },
        );
      },
    );
  }

  // --- (تعديل) إضافة زر الحذف هنا ---
  Widget _buildHafizCard(Hafiz hafiz, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(hafiz.image, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(width: 12),
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
                      Text(
                        hafiz.specialization,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${hafiz.rating} (${hafiz.reviews} تقييم)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // --- زر الحذف (جديد) ---
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  tooltip: 'حذف المحفظ',
                  onPressed: () => _confirmDelete(context, hafiz),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text('${hafiz.experience} سنة خبرة'),
                  backgroundColor: Colors.green.withOpacity(0.2),
                  labelStyle: const TextStyle(fontSize: 11),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Chip(
                  label: Text(hafiz.availability),
                  backgroundColor: Colors.blue.withOpacity(0.2),
                  labelStyle: const TextStyle(fontSize: 11),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Chip(
                  label: Text('${hafiz.price} ر.س/جلسة'),
                  backgroundColor: Colors.orange.withOpacity(0.2),
                  labelStyle: const TextStyle(fontSize: 11),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _requestListeningSession(hafiz),
                child: const Text('طلب جلسة تسميع'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- دالة تأكيد الحذف ---
  void _confirmDelete(BuildContext context, Hafiz hafiz) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من رغبتك في حذف "${hafiz.name}" من القائمة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              // استدعاء الحذف من المزود
              Provider.of<HafizProvider>(context, listen: false).removeHafiz(hafiz);
              Navigator.pop(ctx); // إغلاق النافذة
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم حذف المحفظ بنجاح')),
              );
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRequestsTab() {
    final requests = [
      ListeningRequest(
        id: 1,
        hafizName: 'الشيخ أحمد محمد',
        surah: 'سورة الفاتحة',
        status: 'قيد الانتظار',
        requestDate: '2025-11-17',
        scheduledDate: '2025-11-18',
        notes: 'أريد تصحيح النطق',
      ),
    ];

    if (requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'لا توجد طلبات',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(requests[index]);
      },
    );
  }

  Widget _buildRequestCard(ListeningRequest request) {
    final statusColor = request.status == 'مكتملة'
        ? Colors.green
        : request.status == 'قيد الانتظار'
            ? Colors.orange
            : Colors.blue;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.hafizName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('السورة: ${request.surah}'),
            Text('الموعد: ${request.scheduledDate}'),
          ],
        ),
      ),
    );
  }

  void _requestListeningSession(Hafiz hafiz) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('طلب جلسة تسميع'),
        content: Text('هل تريد تأكيد الطلب مع ${hafiz.name}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إرسال الطلب بنجاح')),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}

class Hafiz {
  final int id;
  final String name;
  final String specialization;
  final int experience;
  final double rating;
  final int reviews;
  final List<String> languages;
  final String availability;
  final String image;
  final int price;

  Hafiz({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.languages,
    required this.availability,
    required this.image,
    required this.price,
  });
}

class ListeningRequest {
  final int id;
  final String hafizName;
  final String surah;
  final String status;
  final String requestDate;
  final String scheduledDate;
  final String notes;

  ListeningRequest({
    required this.id,
    required this.hafizName,
    required this.surah,
    required this.status,
    required this.requestDate,
    required this.scheduledDate,
    required this.notes,
  });
}