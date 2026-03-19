import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';
import 'package:ijaaz_app/application/settings_service.dart';

class ConceptsMapPage extends StatefulWidget {
  const ConceptsMapPage({Key? key}) : super(key: key);

  @override
  State<ConceptsMapPage> createState() => _ConceptsMapPageState();
}

class _ConceptsMapPageState extends State<ConceptsMapPage> {
  String selectedLabel = '';
  Map<String, Map<String, dynamic>> conceptsData = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFromCentralStore();
  }

  Future<void> _loadFromCentralStore() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }

    final instances = QuranDataLoader.allInstances;
    Map<String, int> counts = {};
    int total = instances.length;

    for (var inst in instances) {
      String arabicConcept = AmthalTranslator.translate(inst['Child_Concept']?.toString() ?? 'مفاهيم متنوعة');
      counts[arabicConcept] = (counts[arabicConcept] ?? 0) + 1;
    }

    final bool isArabic = SettingsService().locale.languageCode == 'ar';
    final Map<String, Map<String, dynamic>> processed = {};
    counts.forEach((key, count) {
      processed[key] = {
        'desc': isArabic 
            ? 'تحليل بلاغي مفصل لمفهوم ($key) المستخلص من الشواهد القرآنية، يوضح دلالات هذا المفهوم في السياق القرآني.'
            : 'Detailed rhetorical analysis for concept ($key) extracted from verses, exposing its semantic footprint within the Quranic context.',
        'count': count,
        'percent': (count / total) * 100,
      };
    });

    setState(() {
      conceptsData = processed;
      if (processed.isNotEmpty) selectedLabel = processed.keys.first;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';
    final currentData = conceptsData[selectedLabel] ?? {'desc': '', 'count': 0, 'percent': 0.0};

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'أطلس المفاهيم البلاغية' : 'Rhetorical Concepts Atlas', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: isDark ? theme.appBarTheme.backgroundColor : const Color(0xFF1F3444),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double chartSize = math.min(constraints.maxWidth, constraints.maxHeight * 0.5) * 0.85;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTapDown: (details) => _handleTap(details.localPosition, chartSize),
                      child: CustomPaint(
                        size: Size(chartSize, chartSize),
                        painter: SunburstSimplePainter(
                          selectedLabel: selectedLabel,
                          labels: conceptsData.keys.toList(),
                          isArabic: isArabic,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildDetailPanel(currentData, theme, isDark, isArabic),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailPanel(Map<String, dynamic> data, ThemeData theme, bool isDark, bool isArabic) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  selectedLabel,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontFamily: 'Kitab')
                )
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: isDark ? theme.colorScheme.primary.withOpacity(0.2) : const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(10)),
                child: Text('${(data['percent'] as double).toStringAsFixed(1)}%', style: TextStyle(color: isDark ? theme.colorScheme.primaryContainer : const Color(0xFF1976D2), fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            data['desc'],
            style: TextStyle(fontSize: 15, color: isDark ? Colors.grey[400] : const Color(0xFF555555), height: 1.6, fontFamily: 'Kitab')
          ),
          Divider(height: 40, color: isDark ? Colors.white12 : Colors.black12),
          Row(
            children: [
              Icon(Icons.menu_book_rounded, color: isDark ? Colors.grey[500] : Colors.blueGrey, size: 22),
              const SizedBox(width: 10),
              Text(isArabic ? 'عدد الشواهد القرآنية: ${data['count']} آية' : 'Quranic Evidence Count: ${data['count']} verses', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTap(Offset localPos, double size) {
    final labels = conceptsData.keys.toList();
    if (labels.isEmpty) return;
    final center = Offset(size / 2, size / 2);
    final dx = localPos.dx - center.dx;
    final dy = localPos.dy - center.dy;
    final r = math.sqrt(dx * dx + dy * dy);

    if (r < size * 0.15 || r > size / 2) return;

    double degrees = (math.atan2(dy, dx) * 180 / math.pi + 90 + 360) % 360;
    final step = 360 / labels.length;
    final index = (degrees / step).floor().clamp(0, labels.length - 1);

    setState(() => selectedLabel = labels[index]);
  }
}

class SunburstSimplePainter extends CustomPainter {
  final String selectedLabel;
  final List<String> labels;
  final bool isArabic;

  SunburstSimplePainter({required this.selectedLabel, required this.labels, required this.isArabic});

  @override
  void paint(Canvas canvas, Size size) {
    if (labels.isEmpty) return;
    final center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;
    final double sweepStep = 360 / labels.length;

    for (int i = 0; i < labels.length; i++) {
      final isSelected = labels[i] == selectedLabel;
      final paint = Paint()
        ..color = HSLColor.fromAHSL(1.0, (i * 360 / labels.length) % 360, 0.4, 0.6).toColor().withOpacity(isSelected ? 1.0 : 0.5)
        ..style = PaintingStyle.fill;

      double startRad = (i * sweepStep - 90) * math.pi / 180;
      double sweepRad = (sweepStep - 0.5) * math.pi / 180;

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRad, sweepRad, true, paint);

      if (isSelected) {
        canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startRad, sweepRad, true, Paint()..color = Colors.white.withOpacity(0.5)..style = PaintingStyle.stroke..strokeWidth = 3);
      }

      _drawTextOnArc(canvas, center, radius * 0.7, startRad + sweepRad / 2, labels[i], isSelected);
    }

    canvas.drawCircle(center, radius * 0.3, Paint()..color = Colors.white);
  }

  void _drawTextOnArc(Canvas canvas, Offset center, double radius, double angle, String text, bool isSelected) {
    if (!isSelected && labels.length > 20) return;

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black87,
          fontSize: isSelected ? 11 : 9,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Kitab'
        )
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + math.pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -radius - (tp.height / 2)));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SunburstSimplePainter oldDelegate) => true;
}
