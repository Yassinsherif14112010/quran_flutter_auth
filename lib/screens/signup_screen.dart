import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../services/database_service.dart';
import 'home_screen.dart';
import 'add_hafiz_profile_screen.dart';

class SignupScreen extends StatefulWidget {
  // تم إصلاح تحذير super parameters
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
  UserType? _selectedUserType;

  final _dbService = DatabaseService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _selectedUserType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('كلمات المرور غير متطابقة')),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى الموافقة على الشروط والأحكام')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final existingUser = await _dbService.getUserByEmail(_emailController.text);
      
      // 1. إصلاح استخدام context بعد await
      if (!mounted) return; 

      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('هذا البريد الإلكتروني مسجل بالفعل')),
        );
        setState(() => _isLoading = false);
        return;
      }

      // 2. إصلاح أخطاء الأنواع (Null Safety)
      final newUser = UserModel(
        id: const Uuid().v4(),
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        userType: _selectedUserType!,
        phone: _phoneController.text,
        createdAt: DateTime.now(),
        isVerified: false,
        
        // الحقول الاختيارية (Nullable) نمرر لها null عادي
        memorizedSurahs: _selectedUserType == UserType.student ? [] : null,
        averageAccuracy: _selectedUserType == UserType.student ? 0.0 : null,
        totalSessionsAttended: _selectedUserType == UserType.student ? 0 : null,
        yearsOfExperience: _selectedUserType == UserType.hafiz ? 0 : null,
        
        // الحقول الإجبارية (Non-Nullable) نمرر لها 0 بدلاً من null
        rating: 0.0, 
        sessionsCompleted: 0,
      );

      await _dbService.saveUser(newUser);

      if (!mounted) return; // تحقق مرة أخرى قبل التوجيه

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إنشاء الحساب بنجاح')),
      );

      if (_selectedUserType == UserType.hafiz) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AddHafizProfileScreen(hafiz: newUser),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(user: newUser),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم الكامل',
                  hintText: 'أحمد محمد علي',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  hintText: 'example@email.com',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: '0501234567',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('نوع الحساب', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildUserTypeOption(UserType.student, 'طالب', Icons.school, Colors.blue),
                  const SizedBox(width: 12),
                  _buildUserTypeOption(UserType.hafiz, 'محفظ', Icons.menu_book, Colors.green),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'تأكيد كلمة المرور',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.grey[700]),
                          children: [
                            const TextSpan(text: 'أوافق على '),
                            TextSpan(
                              text: 'الشروط والأحكام',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('إنشاء الحساب', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('هل لديك حساب بالفعل؟ '),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeOption(UserType type, String label, IconData icon, Color color) {
    final isSelected = _selectedUserType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedUserType = type),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // 3. إصلاح withOpacity (استخدام الطريقة الحديثة إذا كنت تستخدم Flutter 3.22+ أو العادية)
            // سأستخدم الطريقة الآمنة المتوافقة مع الجميع
            color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? color : Colors.grey,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}