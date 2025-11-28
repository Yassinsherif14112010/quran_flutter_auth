import 'dart:io'; // 1. للتحقق من نظام التشغيل (Windows/Android...)
import 'package:flutter/foundation.dart'; // 2. للتحقق من الويب (kIsWeb)
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // 3. مكتبة قاعدة البيانات للكمبيوتر

// --- استيراد ملفاتك ---
import 'providers/theme_provider.dart';
import 'screens/human_listening_screen.dart'; // عشان HafizProvider
import 'screens/login_screen.dart';

void main() {
  // 1. ضمان تهيئة بيئة Flutter قبل أي كود
  WidgetsFlutterBinding.ensureInitialized();

  // 2. تهيئة قاعدة البيانات (الحل لمشكلة الصورة)
  if (kIsWeb) {
    // الويب لا يدعم sqflite
    print("Web detected: SQLite not supported");
  } else {
    // إذا كان ويندوز، لينكس، أو ماك
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  runApp(
    // 3. تغليف التطبيق بـ MultiProvider
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => HafizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'تِلاوة - Tilawa',
          debugShowCheckedModeBanner: false,
          
          // السمة (Theme)
          theme: themeProvider.getLightTheme(),
          darkTheme: themeProvider.getDarkTheme(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          
          // اللغة العربية
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('ar', 'SA'),
            Locale('en', 'US'),
          ],
          locale: const Locale('ar', 'SA'),
          
          // شاشة البداية
          home: const LoginScreen(),
        );
      },
    );
  }
}