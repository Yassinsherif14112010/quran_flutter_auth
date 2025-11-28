import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/session_model.dart';
import '../services/database_service.dart';
import 'login_screen.dart';
import 'hafiz_list_screen.dart';
import 'add_hafiz_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserModel _currentUser;
  final _dbService = DatabaseService();
  Map<String, dynamic>? _statistics;
  List<SessionModel> _sessions = [];

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
    _loadStatistics();
    _loadSessions();
  }

  Future<void> _loadStatistics() async {
    final stats = await _dbService.getStatistics(_currentUser.id);
    if (mounted) {
      setState(() {
        _statistics = stats;
      });
    }
  }

  Future<void> _loadSessions() async {
    final sessions = await _dbService.getSessionsByUserId(_currentUser.id);
    if (mounted) {
      setState(() {
        _sessions = sessions;
      });
    }
  }

  // دالة تسجيل الخروج (تم إصلاح التكرار ودمج المنطق)
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // إزالة جميع الشاشات السابقة والذهاب لصفحة الدخول
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تِلاوة - Tilawa'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة المستخدم
              _buildUserCard(),

              const SizedBox(height: 24),

              // الإحصائيات (حسب نوع المستخدم)
              if (_currentUser.userType == UserType.student)
                _buildStudentStatistics()
              else
                _buildHafizStatistics(),

              const SizedBox(height: 24),

              // الجلسات الأخيرة
              _buildRecentSessions(),

              const SizedBox(height: 24),

              // الميزات الرئيسية (تم إصلاح التنسيق هنا)
              _buildFeatures(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard() {
    final isStudent = _currentUser.userType == UserType.student;
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isStudent
                    ? Colors.blue.withOpacity(0.2)
                    : Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                isStudent ? Icons.school : Icons.menu_book,
                size: 40,
                color: isStudent ? Colors.blue : Colors.green,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentUser.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentUser.email,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isStudent
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isStudent ? 'طالب' : 'محفظ',
                      style: TextStyle(
                        fontSize: 11,
                        color: isStudent ? Colors.blue : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentStatistics() {
    final stats = _statistics;
    final totalSessions = stats?['totalSessions'] ?? 0;
    final totalAccuracy = stats?['totalAccuracy'] ?? 0.0;
    final memorizedSurahs = stats?['memorizedSurahs'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائياتك',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'الجلسات',
                value: totalSessions.toString(),
                icon: Icons.mic,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'متوسط الدقة',
                value: '${totalAccuracy.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'السور المحفوظة',
                value: memorizedSurahs.toString(),
                icon: Icons.book,
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHafizStatistics() {
    final stats = _statistics;
    // final totalSessions = stats?['totalSessions'] ?? 0; // يمكن استخدامها لاحقاً
    final rating = _currentUser.rating;
    final sessionsCompleted = _currentUser.sessionsCompleted ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائياتك',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                title: 'الجلسات المكتملة',
                value: sessionsCompleted.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'التقييم',
                value: rating.toStringAsFixed(1),
                icon: Icons.star,
                color: Colors.amber,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                title: 'سنوات الخبرة',
                value: (_currentUser.yearsOfExperience ?? 0).toString(),
                icon: Icons.school,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSessions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الجلسات الأخيرة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        if (_sessions.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 48,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لا توجد جلسات بعد',
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ..._sessions.take(3).map((session) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.mic,
                  color: _getAccuracyColor(session.accuracy),
                ),
                title: Text(session.surahName),
                subtitle: Text(
                  'الدقة: ${session.accuracy.toStringAsFixed(1)}%',
                ),
                trailing: Text(
                  '${session.sessionDate.day}/${session.sessionDate.month}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            );
          // ignore: unnecessary_to_list_in_spreads
          }).toList(),
      ],
    );
  }

  // --- تم إصلاح هذا الجزء بالكامل ---
  Widget _buildFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الميزات الرئيسية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        if (_currentUser.userType == UserType.student) ...[
          _buildFeatureButton(
            icon: Icons.mic,
            title: 'التسميع الذكي',
            subtitle: 'سجل صوتك واحصل على تصحيح فوري',
            onTap: () {
               // Navigator.push...
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            icon: Icons.people,
            title: 'اختر محفظاً',
            subtitle: 'تسميع مباشر مع محفظين متطوعين',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HafizListScreen(currentUser: _currentUser),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            icon: Icons.book,
            title: 'متصفح القرآن',
            subtitle: 'استمع للسور مع مقرئين مختلفين',
            onTap: () {},
          ),
        ] else ...[
          _buildFeatureButton(
            icon: Icons.person_add,
            title: 'إضافة ملفي الشخصي',
            subtitle: 'أضف معلوماتك ليجدك الطلاب',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AddHafizProfileScreen(hafiz: _currentUser),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            icon: Icons.check_circle,
            title: 'طلبات التسميع',
            subtitle: 'استقبل طلبات تسميع من الطلاب',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildFeatureButton(
            icon: Icons.rate_review,
            title: 'تقييم الطلاب',
            subtitle: 'قيّم أداء الطلاب وأعطهم ملاحظات',
            onTap: () {},
          ),
        ],
      ],
    );
  }

  Widget _buildFeatureButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.blue, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 90) return Colors.green;
    if (accuracy >= 70) return Colors.orange;
    return Colors.red;
  }
}