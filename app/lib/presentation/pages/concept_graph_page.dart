import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ijaaz_app/application/data_loader.dart';
import 'package:ijaaz_app/application/amthal_translator.dart';
import 'package:ijaaz_app/application/settings_service.dart';

class ConceptGraphPage extends StatefulWidget {
  final int? initialConceptId;
  const ConceptGraphPage({super.key, this.initialConceptId});

  @override
  State<ConceptGraphPage> createState() => _ConceptGraphPageState();
}

class _ConceptGraphPageState extends State<ConceptGraphPage> {
  late Map<int, String> conceptMap;

  late int selectedConceptId;
  bool isLoading = true;
  late List<_Node> nodes = [];
  late List<_Arrow> arrows = [];

  @override
  void initState() {
    super.initState();
    conceptMap = AmthalTranslator.getMainConcepts();
    selectedConceptId = widget.initialConceptId ?? 6;
    _initData();
  }

  Future<void> _initData() async {
    if (QuranDataLoader.allInstances.isEmpty) {
      await QuranDataLoader.loadInitialData();
    }
    if (mounted) setState(() => isLoading = false);
  }

  int _getCountForConcept(int id) => QuranDataLoader.allInstances.where((inst) => inst['Dominant_Concept'] == id).length;

  List<Map<String, String>> _getRelationsForSelected() {
    final isArabic = SettingsService().locale.languageCode == 'ar';
    final instanceIds = QuranDataLoader.allInstances
        .where((inst) => inst['Dominant_Concept'] == selectedConceptId)
        .map((inst) => inst['Instance_ID'])
        .toSet();

    // جلب العلاقات التي يكون أحد طرفيها ينتمي لهذا المفهوم
    return QuranDataLoader.allRelations
        .where((rel) => instanceIds.contains(rel['Instance_ID_1']) || instanceIds.contains(rel['Instance_ID_2']))
        .map((rel) {
          return {
            'type': rel['Relation_Type']?.toString() ?? (isArabic ? "رابط بلاغي" : "Rhetorical Link"),
            'purpose': rel['Governing_Rhetorical_Purpose']?.toString() ?? "",
          };
        })
        .take(10)
        .toList();
  }

  void _buildGraph(Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    nodes = [];
    int index = 0;
    
    double spreadRadius = math.min(size.width, size.height) * (size.width < 600 ? 0.28 : 0.35);

    conceptMap.forEach((id, name) {
      double angle = (2 * math.pi * index) / conceptMap.length;
      Offset pos = Offset(center.dx + spreadRadius * math.cos(angle), center.dy + spreadRadius * math.sin(angle));

      double count = _getCountForConcept(id).toDouble();
      double circleSize = 15.0 + (count * 0.04);

      nodes.add(_Node(
        id: id,
        label: name,
        center: pos,
        radius: circleSize.clamp(18, 28),
        color: id == selectedConceptId ? const Color(0xFF3282B8) : Colors.blue.withOpacity(0.3),
      ));
      index++;
    });

    arrows = [];
    // رسم العلاقات الفعلية بين المفاهيم بناءً على ملف الروابط
    for (var rel in QuranDataLoader.allRelations.take(60)) {
      try {
        final inst1 = QuranDataLoader.allInstances.firstWhere((i) => i['Instance_ID'] == rel['Instance_ID_1']);
        final inst2 = QuranDataLoader.allInstances.firstWhere((i) => i['Instance_ID'] == rel['Instance_ID_2']);

        var fromNode = nodes.firstWhere((n) => n.id == inst1['Dominant_Concept']);
        var toNode = nodes.firstWhere((n) => n.id == inst2['Dominant_Concept']);
        if (fromNode != toNode) {
          // تجنب تكرار الأسهم بين نفس العقدتين في الرسم البياني
          if (!arrows.any((a) => (a.from == fromNode && a.to == toNode) || (a.from == toNode && a.to == fromNode))) {
            arrows.add(_Arrow(from: fromNode, to: toNode));
          }
        }
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = SettingsService().locale.languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(isArabic ? 'شبكة العلاقات المفهومية' : 'Conceptual Relations Network', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          backgroundColor: isDark ? theme.appBarTheme.backgroundColor : const Color(0xFF1F3444),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = constraints.maxWidth < 700;
            if (isMobile) {
              return Column(
                children: [
                  Expanded(child: _buildGraphArea(constraints.maxWidth, constraints.maxHeight * 0.55, theme, isDark, isArabic)),
                  _buildSidebar(isFullWidth: true, theme: theme, isDark: isDark, isArabic: isArabic),
                ],
              );
            } else {
              return Row(
                children: [
                  _buildSidebar(isFullWidth: false, theme: theme, isDark: isDark, isArabic: isArabic),
                  Expanded(child: _buildGraphArea(constraints.maxWidth, constraints.maxHeight, theme, isDark, isArabic)),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildGraphArea(double width, double height, ThemeData theme, bool isDark, bool isArabic) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: _GridPainter(isDark: isDark))),
        LayoutBuilder(
          builder: (context, constraints) {
            _buildGraph(Size(constraints.maxWidth, constraints.maxHeight));
            return GestureDetector(
              onTapDown: (details) {
                final local = details.localPosition;
                for (final n in nodes) {
                  if ((local - n.center).distance <= n.radius + 20) {
                    setState(() => selectedConceptId = n.id);
                    break;
                  }
                }
              },
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _GraphPainter(nodes: nodes, arrows: arrows, selectedId: selectedConceptId, theme: theme, isDark: isDark, isArabic: isArabic),
              ),
            );
          },
        ),
        Positioned(
          top: 10,
          right: isArabic ? 10 : null,
          left: isArabic ? null : 10,
          child: Chip(
            label: Text(isArabic ? 'اضغط على العقدة لاستكشاف الروابط البلاغية' : 'Tap on a node to explore rhetorical links', style: TextStyle(fontSize: 10, fontFamily: 'Kitab', color: isDark ? Colors.white : Colors.black87)),
            backgroundColor: isDark ? Colors.grey[800]?.withOpacity(0.8) : Colors.white70,
          ),
        )
      ],
    );
  }

  Widget _buildSidebar({required bool isFullWidth, required ThemeData theme, required bool isDark, required bool isArabic}) {
    final String label = conceptMap[selectedConceptId] ?? (isArabic ? "غير معروف" : "Unknown");
    final int count = _getCountForConcept(selectedConceptId);
    final List<Map<String, String>> relations = _getRelationsForSelected();

    return Container(
      width: isFullWidth ? double.infinity : 350,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: isFullWidth ? const BorderRadius.vertical(top: Radius.circular(30)) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(isDark ? 0.3 : 0.05), blurRadius: 15, offset: const Offset(0, -5))],
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isArabic ? 'استكشاف الروابط البلاغية' : 'Explore Rhetorical Links', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontFamily: 'Kitab')),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: isDark ? theme.colorScheme.surfaceVariant : const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color, fontFamily: 'Kitab')),
                  const SizedBox(height: 8),
                  _statBadge(isArabic ? 'عدد الشواهد المتصلة' : 'Connected Evidence', isArabic ? '$count شاهد' : '$count verses', theme, isDark),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isArabic ? 'أغراض بلاغية مرتبطة:' : 'Related Rhetorical Purposes:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.grey[400] : Colors.blueGrey)),
            const SizedBox(height: 12),
            if (isFullWidth) 
              SizedBox(height: 180, child: _buildRelationList(relations, theme, isDark, isArabic))
            else
              Expanded(child: _buildRelationList(relations, theme, isDark, isArabic)),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationList(List<Map<String, String>> relations, ThemeData theme, bool isDark, bool isArabic) {
    if (relations.isEmpty) return Text(isArabic ? 'لا توجد روابط بلاغية مسجلة حالياً لهذا المفهوم في قاعدة البيانات.' : 'No rhetorical links are currently registered for this concept in the database.', style: TextStyle(fontSize: 12, color: isDark ? Colors.grey[500] : Colors.grey, fontFamily: 'Kitab'));
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: relations.length,
      itemBuilder: (context, index) {
        final rel = relations[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.primary.withOpacity(0.1) : Colors.blue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? theme.colorScheme.primary.withOpacity(0.2) : Colors.blue.withOpacity(0.1))
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 16, color: Colors.orangeAccent),
                  const SizedBox(width: 8),
                  Text(rel['type']!, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.primary)),
                ],
              ),
              const SizedBox(height: 6),
              Text(rel['purpose']!, style: TextStyle(fontSize: 12, color: theme.textTheme.bodyMedium?.color, height: 1.4, fontFamily: 'Kitab')),
            ],
          ),
        );
      },
    );
  }

  Widget _statBadge(String label, String value, ThemeData theme, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.blueGrey, fontSize: 12)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary, fontSize: 13)),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  final bool isDark;
  _GridPainter({required this.isDark});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = isDark ? Colors.white.withOpacity(0.02) : Colors.grey.withOpacity(0.04)..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 30) canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 30) canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }
  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}

class _Node {
  final int id;
  final String label;
  final Offset center;
  final double radius;
  final Color color;
  _Node({required this.id, required this.label, required this.center, required this.radius, required this.color});
}

class _Arrow {
  final _Node from;
  final _Node to;
  _Arrow({required this.from, required this.to});
}

class _GraphPainter extends CustomPainter {
  final List<_Node> nodes;
  final List<_Arrow> arrows;
  final int selectedId;
  final ThemeData theme;
  final bool isDark;
  final bool isArabic;

  _GraphPainter({required this.nodes, required this.arrows, required this.selectedId, required this.theme, required this.isDark, required this.isArabic});

  @override
  void paint(Canvas canvas, Size size) {
    final arrowPaint = Paint()..color = isDark ? Colors.grey[700]! : Colors.blueGrey.withOpacity(0.15)..strokeWidth = 1.2..style = PaintingStyle.stroke;
    
    for (final a in arrows) {
      final path = Path()
        ..moveTo(a.from.center.dx, a.from.center.dy)
        ..quadraticBezierTo(
          (a.from.center.dx + a.to.center.dx) / 2 + 10, 
          (a.from.center.dy + a.to.center.dy) / 2 + 10, 
          a.to.center.dx, a.to.center.dy
        );
      canvas.drawPath(path, arrowPaint);
    }

    for (final n in nodes) {
      final isSelected = n.id == selectedId;
      if (isSelected) {
        canvas.drawCircle(n.center, n.radius + 8, Paint()..color = n.color.withOpacity(isDark ? 0.3 : 0.15));
        canvas.drawCircle(n.center, n.radius + 4, Paint()..color = n.color.withOpacity(isDark ? 0.6 : 0.3));
      }
      canvas.drawCircle(n.center, n.radius, Paint()..color = n.color);
      canvas.drawCircle(n.center, n.radius, Paint()..color = isSelected ? theme.textTheme.bodyLarge!.color! : (isDark ? Colors.grey[900]! : Colors.white).withOpacity(0.6)..style = PaintingStyle.stroke..strokeWidth = isSelected ? 2.5 : 1.5);

      final tp = TextPainter(
        text: TextSpan(
          text: n.label, 
          style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1F3444), fontSize: isSelected ? 11 : 9, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontFamily: 'Kitab')
        ),
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      )..layout();
      tp.paint(canvas, n.center - Offset(tp.width / 2, -n.radius - 12));
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) => true;
}
