import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'home_screen.dart';

class UserTypeSelectionScreen extends StatefulWidget {
  final UserModel user;

  const UserTypeSelectionScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UserTypeSelectionScreen> createState() =>
      _UserTypeSelectionScreenState();
}

class _UserTypeSelectionScreenState extends State<UserTypeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),

              // العنوان
              const Text(
                'مرحباً بك في تِلاوة',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                'اختر نوع حسابك لتبدأ رحلتك',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // بطاقة الطالب
              _buildUserTypeCard(
                icon: Icons.school,
                title: 'طالب',
                description: 'أريد حفظ وتعلم القرآن الكريم',
                color: Colors.blue,
                features: [
                  'تسميع ذكي مع الذكاء الاصطناعي',
                  'تسميع مع محفظين متطوعين',
                  'متصفح قرآن متقدم',
                  'رسوم بيانية للتقدم',
                  'تحميل الموارد والملفات',
                  'شهادات وجوائز',
                ],
                onTap: () => _selectUserType(UserType.student),
              ),

              const SizedBox(height: 20),

              // بطاقة المحفظ
              _buildUserTypeCard(
                icon: Icons.menu_book,
                title: 'محفظ',
                description: 'أساعد الطلاب على التسميع والتصحيح',
                color: Colors.green,
                features: [
                  'استقبال طلبات تسميع من الطلاب',
                  'تقييم الطلاب وإعطاء ملاحظات',
                  'إدارة جدول الجلسات',
                  'عرض إحصائيات الأداء',
                  'شهادة محفظ معتمد',
                  'مكافآت وحوافز',
                ],
                onTap: () => _selectUserType(UserType.hafiz),
              ),

              const SizedBox(height: 40),

              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.amber[700],
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'معلومة مهمة',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'يمكنك تغيير نوع حسابك لاحقاً من الإعدادات. كل نوع حساب له مميزات وميزات خاصة به.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة والعنوان
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 32,
                        color: color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // الميزات
                const Text(
                  'الميزات:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                ...features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: color,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 16),

                // زر الاختيار
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'اختر $title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectUserType(UserType userType) {
    final updatedUser = widget.user.copyWith(userType: userType);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HomeScreen(user: updatedUser),
      ),
    );
  }
}
