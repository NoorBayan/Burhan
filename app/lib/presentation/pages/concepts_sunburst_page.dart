import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';
import 'package:ijaaz_app/application/settings_service.dart';
import 'package:ijaaz_app/presentation/pages/concept_graph_page.dart';

class ConceptsSunburstPage extends StatefulWidget {
  const ConceptsSunburstPage({Key? key}) : super(key: key);

  @override
  State<ConceptsSunburstPage> createState() => _ConceptsSunburstPageState();
}

class _ConceptsSunburstPageState extends State<ConceptsSunburstPage> {
  String selectedLabel = '';
  String selectedDesc = '';
  int selectedCount = 0;
  double selectedPercent = 0.0;
  int? currentParentId;

  Map<String, _ConceptNode> hierarchy = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    bool isArabic = SettingsService().locale.languageCode == 'ar';
    selectedLabel = isArabic ? 'اختر قسماً' : 'Select a Section';
    selectedDesc = isArabic ? 'مرر فوق أي قسم لرؤية التفاصيل، واضغط للغوص أعمق في الخريطة.' : 'Hover over any section to see details, and tap to dive deeper into the map.';
    _prepareHierarchicalData();
  }

  Future<void> _prepareHierarchicalData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    _process();
  }

  void _process() {
    if (!mounted) return;

    final data = QuranDataLoader.allInstances;
    Map<String, _ConceptNode> tempHierarchy = {};

    final bool isArabic = SettingsService().locale.languageCode == 'ar';
    final Map<int, String> mainNames = AmthalTranslator.getMainConcepts();

    for (var inst in data) {
      int domId = inst['Dominant_Concept'] ?? 0;
      String parentName = mainNames[domId] ?? (isArabic ? 'مفاهيم أخرى' : 'Other Concepts');
      String childName = AmthalTranslator.translate(inst['Child_Concept']?.toString() ?? 'عام');

      if (!tempHierarchy.containsKey(parentName)) {
        tempHierarchy[parentName] = _ConceptNode(id: domId, name: parentName, color: _getColorForMain(domId));
      }
      tempHierarchy[parentName]!.addChild(childName);
    }

    setState(() {
      hierarchy = tempHierarchy;
      isLoading = false;
    });
  }

  Color _getColorForMain(int id) {
    final colors = [
      const Color(0xFF0D47A1),
      const Color(0xFF1565C0),
      const Color(0xFF1976D2),
      const Color(0xFF1E88E5),
      const Color(0xFF2196F3),
      Colors.blue,
      Colors.blue
    ];
    return colors[id % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';

    if (isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(isArabic ? 'جاري تحليل البيانات القرآنية...' : 'Analyzing Quranic Data...', style: TextStyle(fontFamily: 'Kitab', color: theme.textTheme.bodyLarge?.color)),
            ],
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'أطلس المفاهيم القرآنية' : 'Quranic Concepts Atlas', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: isDark ? theme.appBarTheme.backgroundColor : Colors.blue[800],
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 600;
            if (isMobile) {
              return Column(
                children: [
                  Expanded(child: _buildChartArea(constraints.maxWidth, constraints.maxHeight * 0.55, theme, isDark, isArabic)),
                  _buildSidebar(fullWidth: true, theme: theme, isDark: isDark, isArabic: isArabic),
                ],
              );
            } else {
              return Row(
                children: [
                  _buildSidebar(fullWidth: false, theme: theme, isDark: isDark, isArabic: isArabic),
                  Expanded(child: _buildChartArea(constraints.maxWidth, constraints.maxHeight, theme, isDark, isArabic)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildChartArea(double width, double height, ThemeData theme, bool isDark, bool isArabic) {
    double chartSize = math.min(width, height) * 0.9;
    return Center(
      child: Container(
        width: chartSize,
        height: chartSize,
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTapDown: (details) => _handleTap(details.localPosition, chartSize, isArabic),
          child: CustomPaint(
            size: Size(chartSize, chartSize),
            painter: SunburstMultiLevelPainter(hierarchy: hierarchy, selectedLabel: selectedLabel, isDark: isDark, isArabic: isArabic),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebar({required bool fullWidth, required ThemeData theme, required bool isDark, required bool isArabic}) {
    return Container(
      width: fullWidth ? double.infinity : 320,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: fullWidth ? const BorderRadius.vertical(top: Radius.circular(30)) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.08), blurRadius: 15, offset: const Offset(0, -5))
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF0F2F5), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(selectedLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontFamily: 'Kitab'))),
                ],
              ),
              const SizedBox(height: 16),
              Text(selectedDesc, style: TextStyle(height: 1.6, fontSize: 14, color: isDark ? Colors.grey[400] : Colors.blueGrey, fontFamily: 'Kitab')),
              const Divider(height: 32),
              if (selectedCount > 0) ...[
                _statRow(isArabic ? 'عدد الشواهد:' : 'Evidence Count:', isArabic ? '$selectedCount آية' : '$selectedCount verses', theme, isDark),
                const SizedBox(height: 12),
                _statRow(isArabic ? 'النسبة المئوية:' : 'Percentage:', '${selectedPercent.toStringAsFixed(1)}%', theme, isDark),
              ],
              const SizedBox(height: 24),
              if (currentParentId != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (c) => ConceptGraphPage(initialConceptId: currentParentId)));
                    },
                    icon: const Icon(Icons.hub_rounded, color: Colors.white, size: 20),
                    label: Text(isArabic ? 'استكشاف الشبكة العلائقية' : 'Explore Relational Network', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value, ThemeData theme, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 14, fontFamily: 'Kitab')),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: isDark ? theme.colorScheme.surfaceVariant : Colors.blue[50], borderRadius: BorderRadius.circular(8)),
          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.textTheme.bodyLarge?.color)),
        ),
      ],
    );
  }

  void _handleTap(Offset pos, double size, bool isArabic) {
    final center = Offset(size / 2, size / 2);
    final dx = pos.dx - center.dx;
    final dy = pos.dy - center.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final angle = (math.atan2(dy, dx) * 180 / math.pi + 90 + 360) % 360;

    double totalWeight = hierarchy.values.fold(0, (sum, item) => sum + item.weight);
    if (totalWeight == 0) return;
    double startAngle = 0;

    for (var parent in hierarchy.values) {
      double sweepAngle = (parent.weight / totalWeight) * 360;
      if (angle >= startAngle && angle < startAngle + sweepAngle) {
        if (distance >= size * 0.28 && distance < size * 0.5) {
          double childStart = startAngle;
          for (var entry in parent.children.entries) {
            double childSweep = (entry.value / parent.weight) * sweepAngle;
            if (angle >= childStart && angle < childStart + childSweep) {
              setState(() {
                selectedLabel = entry.key;
                currentParentId = parent.id;
                selectedCount = entry.value;
                selectedPercent = (entry.value / QuranDataLoader.allInstances.length) * 100;
                selectedDesc = isArabic 
                    ? "مفهوم فرعي دقيق يوضح دلالات ($selectedLabel) في النص القرآني. يمكنك تتبع علاقات هذا المفهوم بالمفاهيم الكبرى والروابط البلاغية عبر الشبكة."
                    : "A detailed sub-concept illustrating the meanings of ($selectedLabel) in the Quran text. You can track this concept's relations and rhetorical links across the network.";
              });
              return;
            }
            childStart += childSweep;
          }
        } else if (distance >= size * 0.1 && distance < size * 0.28) {
          setState(() {
            selectedLabel = parent.name;
            currentParentId = parent.id;
            selectedCount = parent.weight;
            selectedPercent = (parent.weight / QuranDataLoader.allInstances.length) * 100;
            selectedDesc = isArabic
                ? "يمثل ($selectedLabel) محوراً بلاغياً مركزياً يضم مجموعة من المفاهيم الفرعية المترابطة."
                : "($selectedLabel) represents a central rhetorical pivot comprising a collection of interconnected sub-concepts.";
          });
          return;
        }
      }
      startAngle += sweepAngle;
    }
  }
}

class _ConceptNode {
  final int id;
  final String name;
  final Color color;
  Map<String, int> children = {};
  int weight = 0;
  _ConceptNode({required this.id, required this.name, required this.color});
  void addChild(String childName) {
    children[childName] = (children[childName] ?? 0) + 1;
    weight++;
  }
}

class SunburstMultiLevelPainter extends CustomPainter {
  final Map<String, _ConceptNode> hierarchy;
  final String selectedLabel;
  final bool isDark;
  final bool isArabic;

  SunburstMultiLevelPainter({required this.hierarchy, required this.selectedLabel, required this.isDark, required this.isArabic});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double innerRadius = size.width * 0.18;
    final double midRadius = size.width * 0.32;
    final double outerRadius = size.width * 0.48;

    final Color baseInnerRing = isDark ? Colors.grey[800]! : Colors.white;
    final outerWhitePaint = Paint()..color = baseInnerRing..style = PaintingStyle.fill;
    canvas.drawCircle(center, size.width * 0.55, outerWhitePaint);

    final centerWhitePaint = Paint()..color = baseInnerRing..style = PaintingStyle.fill;
    canvas.drawCircle(center, innerRadius * 0.9, centerWhitePaint);

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: isDark 
            ? [Colors.blueGrey[900]!, Colors.blueGrey[800]!, Colors.blueGrey[700]!, Colors.blueGrey[800]!]
            : [Colors.blue[50]!, Colors.blue[200]!, Colors.blue[400]!, Colors.blue[600]!],
        stops: const [0.0, 0.25, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: outerRadius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, outerRadius, bgPaint);

    double totalWeight = hierarchy.values.fold(0, (sum, item) => sum + item.weight);
    if (totalWeight == 0) return;

    double startAngle = -math.pi / 2;

    hierarchy.forEach((parentName, node) {
      double sweepAngle = (node.weight / totalWeight) * 2 * math.pi;

      final innerPaint = Paint()
        ..shader = LinearGradient(colors: [node.color.withOpacity(0.95), node.color.withOpacity(0.35)]).createShader(Rect.fromCircle(center: center, radius: midRadius))
        ..style = PaintingStyle.fill;

      _drawSegment(canvas, center, innerRadius, midRadius, startAngle, sweepAngle, innerPaint, node.name);

      double childStartAngle = startAngle;
      node.children.forEach((childName, count) {
        double childSweep = (count / node.weight) * sweepAngle;
        final childPaint = Paint()
          ..shader = LinearGradient(colors: [node.color.withOpacity(0.85), node.color.withOpacity(0.25)]).createShader(Rect.fromCircle(center: center, radius: outerRadius))
          ..style = PaintingStyle.fill;

        _drawSegment(canvas, center, midRadius, outerRadius, childStartAngle, childSweep, childPaint, childName);
        childStartAngle += childSweep;
      });
      startAngle += sweepAngle;
    });

    canvas.drawCircle(center, innerRadius * 0.7, Paint()..color = baseInnerRing);
  }

  void _drawSegment(Canvas canvas, Offset center, double innerR, double outerR, double startAngle, double sweepAngle, Paint paint, String label) {
    if (sweepAngle < 0.01) return;
    final path = Path()
      ..arcTo(Rect.fromCircle(center: center, radius: outerR), startAngle, sweepAngle, false)
      ..arcTo(Rect.fromCircle(center: center, radius: innerR), startAngle + sweepAngle, -sweepAngle, false)
      ..close();
    canvas.drawPath(path, paint);
    if (sweepAngle > 0.15) {
      _drawTextOnArc(canvas, center, (innerR + outerR) / 2, startAngle + sweepAngle / 2, label);
    }
  }

  void _drawTextOnArc(Canvas canvas, Offset center, double radius, double angle, String text) {
    final isSelected = text == selectedLabel;
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: isSelected ? 11 : 9, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, shadows: const [Shadow(color: Colors.black, blurRadius: 2)], fontFamily: 'Kitab')
      ),
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle + math.pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -radius - tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant SunburstMultiLevelPainter oldDelegate) => true;
}
