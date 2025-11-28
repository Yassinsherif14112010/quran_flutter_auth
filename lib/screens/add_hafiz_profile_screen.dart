import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AddHafizProfileScreen extends StatefulWidget {
  final UserModel hafiz;

  const AddHafizProfileScreen({
    Key? key,
    required this.hafiz,
  }) : super(key: key);

  @override
  State<AddHafizProfileScreen> createState() => _AddHafizProfileScreenState();
}

class _AddHafizProfileScreenState extends State<AddHafizProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _bioController;
  late TextEditingController _certificateController;
  late TextEditingController _experienceController;
  late TextEditingController _rateController;
  late TextEditingController _availabilityController;

  List<String> _specializations = [];
  List<String> _languages = ['العربية'];
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _bioController = TextEditingController(
      text: widget.hafiz.bio ?? '',
    );
    _certificateController = TextEditingController(
      text: widget.hafiz.hafizCertificate ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.hafiz.yearsOfExperience?.toString() ?? '',
    );
    _rateController = TextEditingController(
      text: widget.hafiz.sessionRate?.toString() ?? '50',
    );
    _availabilityController = TextEditingController(
      text: 'متاح الآن',
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _certificateController.dispose();
    _experienceController.dispose();
    _rateController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ ملفك الشخصي بنجاح'),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ملف محفظ'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // صورة الملف الشخصي
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('سيتم إضافة تحميل الصور قريباً'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('تحميل صورة'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // السيرة الذاتية
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'السيرة الذاتية',
                  hintText: 'اكتب نبذة عن نفسك...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال السيرة الذاتية';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // الشهادات
              TextFormField(
                controller: _certificateController,
                decoration: InputDecoration(
                  labelText: 'الشهادات والتكوينات',
                  hintText: 'مثال: شهادة حفظ القرآن الكريم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.card_membership),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال الشهادات';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // سنوات الخبرة
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'سنوات الخبرة',
                  hintText: 'عدد السنوات',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.work),
                  suffixText: 'سنة',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال سنوات الخبرة';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // سعر الجلسة
              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(
                  labelText: 'سعر الجلسة',
                  hintText: 'السعر بالريال',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                  suffixText: 'ر.س',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'يرجى إدخال سعر الجلسة';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // التخصصات
              Text(
                'التخصصات',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildSpecializationChip('حفظ القرآن'),
                  _buildSpecializationChip('تجويد'),
                  _buildSpecializationChip('تفسير'),
                  _buildSpecializationChip('قراءات'),
                ],
              ),

              const SizedBox(height: 16),

              // اللغات
              Text(
                'اللغات',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  _buildLanguageChip('العربية'),
                  _buildLanguageChip('الإنجليزية'),
                  _buildLanguageChip('الأردية'),
                  _buildLanguageChip('الإندونيسية'),
                ],
              ),

              const SizedBox(height: 16),

              // الحالة
              Text(
                'الحالة',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: true,
                          label: Text('متاح الآن'),
                          icon: Icon(Icons.check_circle),
                        ),
                        ButtonSegment(
                          value: false,
                          label: Text('غير متاح'),
                          icon: Icon(Icons.cancel),
                        ),
                      ],
                      selected: {_isAvailable},
                      onSelectionChanged: (Set<bool> newSelection) {
                        setState(() {
                          _isAvailable = newSelection.first;
                        });
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // زر الحفظ
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'حفظ الملف الشخصي',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 16),

              // معلومات إضافية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'معلومات مهمة:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• ملفك الشخصي سيظهر للطلاب الباحثين عن محفظين\n'
                      '• تأكد من ملء جميع البيانات بدقة\n'
                      '• يمكنك تحديث ملفك في أي وقت\n'
                      '• سيتم التحقق من بيانات الملف من قبل الإدارة',
                      style: TextStyle(
                        fontSize: 11,
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

  Widget _buildSpecializationChip(String label) {
    final isSelected = _specializations.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          if (isSelected) {
            _specializations.remove(label);
          } else {
            _specializations.add(label);
          }
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildLanguageChip(String label) {
    final isSelected = _languages.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          if (isSelected) {
            _languages.remove(label);
          } else {
            _languages.add(label);
          }
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
