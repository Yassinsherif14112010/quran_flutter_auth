import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة المعلومات'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الإحصائيات الرئيسية
            _buildStatsCard(context, isDark),
            const SizedBox(height: 24),

            // رسم بياني للتقدم الأسبوعي
            _buildWeeklyProgressChart(context, isDark),
            const SizedBox(height: 24),

            // رسم بياني للسور المحفوظة
            _buildMemorizedSurahsChart(context, isDark),
            const SizedBox(height: 24),

            // رسم بياني للدقة
            _buildAccuracyChart(context, isDark),
            const SizedBox(height: 24),

            // إحصائيات تفصيلية
            _buildDetailedStats(context, isDark),
            const SizedBox(height: 24),

            // الإنجازات
            _buildAchievements(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إحصائياتك اليوم',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                  icon: Icons.timer,
                  label: 'الوقت',
                  value: '45 دقيقة',
                  isDark: isDark,
                ),
                _buildStatItem(
                  icon: Icons.check_circle,
                  label: 'الجلسات',
                  value: '3',
                  isDark: isDark,
                ),
                _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'الدقة',
                  value: '92%',
                  isDark: isDark,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyProgressChart(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'التقدم الأسبوعي',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        // التصحيح هنا: إضافة !
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
                          if (value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 60),
                        FlSpot(1, 75),
                        FlSpot(2, 80),
                        FlSpot(3, 85),
                        FlSpot(4, 90),
                        FlSpot(5, 88),
                        FlSpot(6, 95),
                      ],
                      isCurved: true,
                      color: Theme.of(context).primaryColor,
                      barWidth: 3,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Theme.of(context).primaryColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemorizedSurahsChart(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'توزيع السور المحفوظة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: Colors.blue,
                      value: 35,
                      title: 'محفوظ\n35%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.orange,
                      value: 25,
                      title: 'قيد التعلم\n25%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.green,
                      value: 20,
                      title: 'مراجعة\n20%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    PieChartSectionData(
                      color: Colors.grey,
                      value: 20,
                      title: 'لم تبدأ\n20%',
                      radius: 60,
                      titleStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                  sectionsSpace: 0,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyChart(BuildContext context, bool isDark) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تطور الدقة الشهري',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        // التصحيح هنا: إضافة !
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'];
                          if (value.toInt() < months.length) {
                            return Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: 65, color: Theme.of(context).primaryColor),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: 72, color: Theme.of(context).primaryColor),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: 78, color: Theme.of(context).primaryColor),
                    ]),
                    BarChartGroupData(x: 3, barRods: [
                      BarChartRodData(toY: 85, color: Theme.of(context).primaryColor),
                    ]),
                    BarChartGroupData(x: 4, barRods: [
                      BarChartRodData(toY: 90, color: Theme.of(context).primaryColor),
                    ]),
                    BarChartGroupData(x: 5, barRods: [
                      BarChartRodData(toY: 92, color: Theme.of(context).primaryColor),
                    ]),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedStats(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إحصائيات تفصيلية',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildStatRow(
          context,
          'إجمالي الجلسات',
          '127',
          Icons.check_circle,
          isDark,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          context,
          'الوقت الإجمالي',
          '45 ساعة',
          Icons.timer,
          isDark,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          context,
          'السور المحفوظة',
          '15 سورة',
          Icons.book,
          isDark,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          context,
          'متوسط الدقة',
          '87%',
          Icons.trending_up,
          isDark,
        ),
        const SizedBox(height: 8),
        _buildStatRow(
          context,
          'الترتيب',
          '#45 عالمياً',
          Icons.leaderboard,
          isDark,
        ),
      ],
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievements(BuildContext context, bool isDark) {
    final achievements = [
      {'icon': '🏆', 'title': 'البداية الموفقة', 'description': 'أكمل أول جلسة تسميع'},
      {'icon': '⭐', 'title': 'النجم الصاعد', 'description': 'حقق 90% دقة'},
      {'icon': '🎯', 'title': 'المتفاني', 'description': 'تسميع لمدة 7 أيام متتالية'},
      {'icon': '🔥', 'title': 'الحريص', 'description': 'حفظ 5 سور كاملة'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الإنجازات',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Card(
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      achievement['icon'] as String,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      achievement['description'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}